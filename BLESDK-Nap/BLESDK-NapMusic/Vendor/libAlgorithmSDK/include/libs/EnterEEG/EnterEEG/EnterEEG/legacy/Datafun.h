//
// Created by 雷京颢 on 2017/12/15.
//

#ifndef ENTEREEG_LIBS_DATAFUN_H
#define ENTEREEG_LIBS_DATAFUN_H

#include "Basic.h"

namespace EnterTech{
namespace EnterEEG{

/**
 * 模拟 Matlab 中的一维filter函数，为Direct Form II Transposed
 * @tparam T   需要浮点型
 * @param b    b
 * @param a    a
 * @param x    x
 *
 * @return  结果
 */
template <typename T> std::vector<T> filter(const std::vector<T> &b, const std::vector<T> &aa, const std::vector<T> &x);


/**
 * 累加函数，同 Matlab 中一致
 * @tparam T   需要支持加法
 * @param data 待累加的向量
 * @return     累加结果
 */
template <typename T> std::vector<T> cumsum(const std::vector<T> &data);

/**
 * 按行排列矩阵函数
 * @tparam T    任意支持大小比较的类型
 * @param data  待排列矩阵
 * @return      排列结果
 */
template <typename T> std::vector<std::vector<T>> sortrows(const std::vector<std::vector<T>> &data);

/**
 * 以col列为基准按行排列矩阵函数
 * @tparam T    任意支持大小比较的类型
 * @param data  待排列矩阵
 * @param col   列基准
 * @return      排列结果
 */
template <typename T> std::vector<std::vector<T>> sortrows(const std::vector<std::vector<T>> &data, size_t col, bool matlabIndex = true);

}
}

namespace EnterTech{
namespace EnterEEG{

template <typename T> std::vector<T> filter(const std::vector<T> &b, const std::vector<T> &aa, const std::vector<T> &x) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    
    if (aa.empty())
        throw std::invalid_argument("filter parameter a should not be empty");
    std::vector<T> y;

    //归一化系数
    std::vector<T> a;
    if (auto factor=(aa[0]) != 1.0){
        for (auto data : aa)
            a.emplace_back(data/factor);
    } else {
        a = aa;
    }

    for (size_t n=0; n < x.size(); n++) {
        T yn = 0.0;
        for (size_t nb=0; n >= nb && nb < b.size(); nb++){
            yn += b[nb]*x[n-nb];
        }
        for (size_t na=1; n >= na && na < a.size(); na++){
            yn -= (a[na]*y[n-na]);
        }
        y.emplace_back(yn);
    }
    return y;
}

template <typename T> std::vector<T> cumsum(const std::vector<T> &data) {
    std::vector<T> res = data;
    if (res.empty())
        return res;
    for (auto it = res.begin() + 1; it != res.end(); it++) {
        *it = (*it) + *(it - 1);
    }
    return res;
}

template <typename T> std::vector<std::vector<T>> sortrows(const std::vector<std::vector<T>> &data) {
    auto res = data;
    if (data.empty())
        return res;
    auto rowLength = data[0].size();
    for (auto && row : data) {
        if (row.size() != rowLength) throw std::invalid_argument("input matrix row should be same size");
    }

    std::sort(res.begin(), res.end(), [](const std::vector<T> &a, const std::vector<T> &b)->bool {
        for (auto ita = a.begin(), itb = b.begin(); ita != a.end(); ita++, itb++) {
            if (*ita < *itb) return true;
            if (*ita > *itb) return false;
        }
        return true;
    });
    return res;
}

template <typename T> std::vector<std::vector<T>> sortrows(const std::vector<std::vector<T>> &data, size_t col, bool matlabIndex) {
    if (matlabIndex && col ==0) throw std::invalid_argument("col index should larger than 1 in matlabIndex mode");
    auto rowLength = data[0].size();
    for (auto && row : data) {
        if (row.size() != rowLength) throw std::invalid_argument("input matrix row should be same size");
    }
    if (matlabIndex) col--;
    if (rowLength < col) throw std::out_of_range("col index should in data range");

    auto res = data;
    std::stable_sort(res.begin(), res.end(), [&](const std::vector<T> &a, const std::vector<T> &b) -> bool {
        return a[col] < b[col];
    });
    return res;
}

}
}

#endif //MATLABTOOLBOX_MATLABTOOLBOX_DATAFUN_H
