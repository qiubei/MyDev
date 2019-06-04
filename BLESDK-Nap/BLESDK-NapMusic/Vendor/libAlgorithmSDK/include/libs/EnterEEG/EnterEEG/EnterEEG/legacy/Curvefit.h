//
// Created by 雷京颢 on 2017/12/13.
//

#ifndef ENTEREEG_LIBS_CURVEFIT_H
#define ENTEREEG_LIBS_CURVEFIT_H

#define UNUSED(x) (void)(x)

#include "Basic.h"
#include "Datafun.h"
#include "Eigen/Eigen.h"

//函数声明
namespace EnterTech {
namespace EnterEEG {

/**
 * 使用特定方法平滑数据，参见matlab内smooth.m 目前只支持loess方法
 * @tparam T      需要浮点型
 * @param x       x
 * @param y       y
 * @param span    span
 * @param method  method
 *
 * @return 平滑结果
 */
template<typename T>
std::vector<T> smooth(const std::vector<T> &x, const std::vector<T> &y, T span, const std::string &method);

namespace CurvefitInner {

/**
 * 使用Loess方法平滑数据，参见 W.S.Cleveland,
 * "Robust Locally Weighted Regression and Smoothing Scatterplots",
 * _J. of the American Statistical Ass._, Vol 74, No. 368 (Dec.,1979), pp. 829-836.
 * @tparam T     需要浮点型
 * @param x      x
 * @param y      y
 * @param span   span
 * @param method method
 * @param robust robust
 * @param iter   迭代次数
 *
 * @return 平滑结果
 */
template<typename T>
std::vector<T> lowess(const std::vector<T> &x, const std::vector<T> &y, T span, const std::string &method, bool robust, unsigned iter);

/**
 * 判断x是否是等差数列
 * @tparam T 得支持减法
 * @param x  待判断数组
 * @return   结果
 */
template<typename T>
bool isuniform(const std::vector<T> &x);

/**
 * 对自变量是等差数列的情况进行Loess方法平滑,
 * @tparam T        需要浮点型
 * @param y         因变量
 * @param span      span
 * @param useLoess  是否使用Loess
 *
 * @return 平滑结果
 */
template<typename T>
std::vector<T> unifloess(const std::vector<T> &y, size_t span, bool useLoess);

/**
 *  模拟matlab中的diff函数，注意res的长度会比data短1
 * @tparam T 可以是任意类型
 * @param data 输入
 *
 * @return diff结果
 */
template <typename T> std::vector<T> diff(const std::vector<T> &data);

}

}
}


namespace EnterTech {
namespace EnterEEG {

template<typename T>
std::vector<T> smooth(const std::vector<T> &x, const std::vector<T> &y, T span, const std::string &method) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    if (method != "loess")
        throw std::invalid_argument("smooth only support loess method!");
    if (x.size() != y.size())
        throw std::invalid_argument("x and y size should be same length");
    if (span <= 0)
        throw std::invalid_argument("span must be positive");
    if (x.size() == 0)
        throw std::invalid_argument("input array must not empty");

    std::vector<T> c;

    // realize span
    auto t = y.size();
    if (span < 1.0)
        span = ceil(span * t);

    // check x order
    for (auto it = x.begin(); true; it++) {
        auto it2 = it + 1;
        if (it2 == x.end())
            break;
        if (*it2 - *it < 0) {
            throw std::invalid_argument("currently x should be increase order!");
        }
    }
    return CurvefitInner::lowess(x, y, span, method, false, 5);
}

namespace CurvefitInner {

template<typename T>
std::vector<T> lowess(const std::vector<T> &x, const std::vector<T> &y, T span, const std::string &method, bool robust,
                       unsigned iter) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    UNUSED(iter);

    if (robust){
        throw std::invalid_argument("currently only support no robust");
    }

    auto n = y.size();
    span = floor(span);
    span = std::min(span, static_cast<T>(n));
    auto c = y;
    if (span == 1)
        return c;

    bool useLoess = (method == "loess");

    if (isuniform(diff(x))) {
        span = 2 * floor(span / 2) + 1;
        return unifloess(y, span, useLoess);
    } else {
        throw std::invalid_argument("currently x only support arithmetic progression");
    }
}

template<typename T>
bool isuniform(const std::vector<T> &x) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    if (x.size() <= 1)
        return true;
    auto diff = x[1] - x[0];
    for (auto it = x.begin(); true; it++) {
        auto next = it + 1;
        if (x.end() == next)
            return true;
        if ((*next - *it) != diff)
            return false;
    }
}

template<typename T>
std::vector<T> unifloess(const std::vector<T> &y, const size_t span, bool useLoess) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    if (span % 2 != 1)
        throw std::invalid_argument("span should be odd");

    // Omit points at the extremes, which have zero weight
    auto halfw = (span - 1) / 2;//halfwidth of entire span
    std::vector<T> d;//distances to pts with nonzero weight
    for (T data = 1.0 - halfw; data <= (halfw - 1.0); data += 1.0) {
        d.emplace_back(std::abs(data));
    }
    auto dmax = halfw;//max distance for tri-cubic weight

    //Set up weighted Vandermonde matrix using equally spaced X values
    std::vector<T> x1;
    for (T data = 2.0; data <= span - 1.0; data += 1.0) {
        x1.emplace_back(data - (halfw + 1.0));
    }

    //weight = (1 - (d/dmax).^3).^1.5
    std::vector<T> weight;
    weight.reserve(d.size());
    for (auto &&item : d) {
        auto tmp = item / dmax;
        tmp = 1 - tmp * tmp * tmp;
        weight.emplace_back(sqrt(tmp * tmp * tmp));
    }

    Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> v(x1.size(), 3);
     if (useLoess) {
        for (size_t index = 0; index < x1.size(); index++) {
            v(index, 0) = 1.0;
            v(index, 1) = x1[index];
            v(index, 2) = x1[index] * x1[index];
        }
    } else {
        throw std::invalid_argument("currently only support loess");
    }

    Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> V(v.rows(), v.cols());
    for (size_t row = 0; row < static_cast<size_t>(v.rows()); row++) {
        for (size_t col = 0; col < static_cast<size_t>(v.cols()); col++) {
            V(row, col) = v(row, col) * weight[row];
        }
    }

    Eigen::HouseholderQR<Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> > qr(V);
    Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> Q = qr.householderQ();
    Q.conservativeResize(V.rows(), V.cols());

    std::vector<T> alpha;
    for (size_t row = 0; row < static_cast<size_t>(Q.rows()); row++) {
        T tmp = 0.0;
        for (size_t col = 0; col < static_cast<size_t>(Q.cols()); col++) {
            tmp = tmp + Q(static_cast<size_t>(halfw) - 1, col) * Q(row, col);
        }
        alpha.emplace_back(tmp);
    }

    for (auto it1 = alpha.begin(), it2 = weight.begin(); it1 != alpha.end(); it1++, it2++)
        (*it1) = (*it1) * (*it2);

    auto ys = filter<T>(alpha, std::vector<T>(1, 1), y);
    for (size_t index = 0; index < ys.size() - span + 1; index++)
        ys[index + halfw] = ys[span + index - 2];

    x1.clear();
    for (size_t index = 1; index <= span - 1; index++)
        x1.emplace_back(index);
    v = Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic>(x1.size(), 3);
    for (size_t index = 0; index < x1.size(); index++) {
        v(index, 0) = 1.0;
        v(index, 1) = x1[index];
        v(index, 2) = x1[index] * x1[index];
    }

    for (size_t j = 1; j <= halfw; j++) {
        d.clear();
        for (size_t index = 1; index <= span - 1; index++)
            d.emplace_back(std::abs((static_cast<T>(index) - j)));
        weight.clear();
        for (const auto &item : d) {
            auto tmp = static_cast<T>(item) / (span - j);
            tmp = 1.0 - tmp * tmp * tmp;
            weight.emplace_back(sqrt(tmp * tmp * tmp));
        }
        V = Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic>(v.rows(), v.cols());
        for (size_t row = 0; row < static_cast<size_t>(v.rows()); row++) {
            for (size_t col = 0; col < static_cast<size_t>(v.cols()); col++) {
                V(row, col) = v(row, col) * weight[row];
            }
        }
        Eigen::HouseholderQR<Eigen::Matrix <T, Eigen::Dynamic, Eigen::Dynamic> > qr(V);
        Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> Q = qr.householderQ();
        Q.conservativeResize(V.rows(), V.cols());
        alpha.clear();
        for (size_t row = 0; row < static_cast<size_t>(Q.rows()); row++) {
            T tmp = 0.0;
            for (size_t col = 0; col < static_cast<size_t>(Q.cols()); col++) {
                tmp = tmp + Q(j - 1, col) * Q(row, col);
            }
            alpha.emplace_back(tmp);
        }
        for (auto it1 = alpha.begin(), it2 = weight.begin(); it1 != alpha.end(); it1++, it2++)
            (*it1) = (*it1) * (*it2);

        T tmp = 0.0;
        for (auto it1 = alpha.cbegin(), it2 = y.cbegin(); it1 != alpha.cend(); it1++, it2++)
            tmp = tmp + (*it1) * (*it2);
        ys[j - 1] = tmp;
        tmp = 0.0;

        {
            auto it1 = alpha.cbegin();
            auto it2 = y.crbegin();
            for (; it1 != alpha.cend(); it1++, it2++)
                tmp = tmp + (*it1) * (*it2);
        }
        ys[ys.size() - j] = tmp;
    }
    return ys;
}

template <typename T> std::vector<T> diff(const std::vector<T> &data) {
    std::vector<T> res;
    if (data.empty())
        return res;
    res.reserve(data.size()-1);
    for (auto it = data.cbegin(); true ; it++) {
        auto next = it+1;
        if (data.cend() == next)
            return res;
        res.emplace_back(*next-*it);
    }
}

}


}
}


#endif //MATLABTOOLBOX_MATLABTOOLBOX_CURVEFIT_H
