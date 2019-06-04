//
// Created by 雷京颢 on 2018/7/18.
//

#ifndef ENTEREEG_NUMPY_BASIC_H
#define ENTEREEG_NUMPY_BASIC_H

#include <algorithm>
#include <complex>
#include <vector>
#include <deque>
#include "../legacy/Basic.h"

namespace EnterTech {
namespace EnterEEG {

/**
 *  模拟numpy中形如a[start:end] = val的赋值
 *
 *  @param data  待处理的数组
 *  @param start 开始下标
 *  @param end   结束下标
 *  @param val   需要的赋值
 */
template <typename T> void npSet(std::vector<T> &data, int start, int end, const T &val);

/**
 * 模拟 numpy 的 median 操作
 * @tparam T   任意浮点型
 * @param data 输入数组
 * @return 中间值
 */
template <typename T> T median(const std::vector<T> &data);

/**
 * 模拟 numpy 的 median 操作
 * @tparam T   任意浮点型
 * @param data 输入数组
 * @return 中间值
 */
template <typename T> T median(const std::deque<T> &data);

/**
 * 用于 bool 量的求和
 * @param data
 * @return
 */
size_t sum(const std::deque<bool> &data);

/**
 *  实数求绝对值
 *
 *  @param data   待求数据vector
 *
 *  @return  求值结果
 */
template <typename T> std::vector<T> abs(const std::vector<T> &data);

/**
 *  复数求绝对值
 *
 *  @tparam T   任意浮点型
 *  @param data   待求数据vector
 *
 *  @return  求值结果
 */
template <typename T> std::vector<T> abs(const std::vector<std::complex<T>> &data);

/**
 * 求对数
 * @tparam T     任意浮点型
 * @param data   待求数据vector
 * @return   求值结果
 */
template <typename T> std::vector<T> log(const std::vector<T> &data);

/**
 * 模拟numpy中np.var() 函数
 * @tparam T   浮点型
 * @param data 待计算数组
 * @return 方差
 */
template <typename T> T var(const std::vector<T> &data);

/**
 * 模拟numpy中np.linspace() 函数
 * @tparam T       浮点型
 * @param start    序列起始值
 * @param stop     序列终止值
 * @param num      序列长度
 * @param endpoint 是否需要包含序列终止值
 * @return      线性分布数组
 */
template <typename T> std::vector<T> linspace(T start, T stop, size_t num, bool endpoint = true);

/**
 * 模拟numpy中np.linspace() 函数
 * @tparam T       浮点型
 * @param start    序列起始值
 * @param stop     序列终止值
 * @param num      序列长度
 * @param endpoint 是否需要包含序列终止值
 * @return      线性分布数组
 */
    template <typename T> std::vector<float> linspaceFloat(long start, T stop, size_t num, bool endpoint = true);

/**
 * 标准差
 * @tparam T   浮点型
 * @param data 待计算数组
 * @param ddof 自由度。当设置为 1 时为无偏估计
 * @return
 */
template <typename T> T std(const std::vector<T> &data, int ddof = 0);


/**
 * 四舍五入
 * @param T   浮点型
 * @return
 */
    template <typename T> size_t round(const T data);


/**
 * 数组求指数
 * @param data 待计算数组
 * @param ddof 自由度。当设置为 1 时为无偏估计
 * @return
 */
template <typename T> std::vector<T>  expArray(const std::vector<T> &data);


/**
 * 求精度
 * @param T double
 * @param len 长度
 * @return
 */
    template <class T> double round_size( T fl , size_t len);

}
}

namespace EnterTech {
namespace EnterEEG {

template <typename T> void npSet(std::vector<T> &data, int startIndex, int endIndex, const T &val) {
    auto currentSize = data.size();
    if (startIndex >= currentSize)
        return;
    if (endIndex > currentSize)
        endIndex = currentSize;
    for (auto index = startIndex; index < endIndex; index ++) {
        data[index] = val;
    }
}

template <typename T> T median(const std::vector<T> &data) {
    static_assert(std::is_floating_point<T>::value||
                  std::is_integral<T>::value, "T must float/int type!");
    // TODO 变为 O(n) 算法
    auto copyData = data;
    std::sort(copyData.begin(), copyData.end());
    auto dataSize = copyData.size();
    if (dataSize % 2 == 0)
        return (copyData[dataSize/2-1] + copyData[dataSize/2])/2.;
    else
        return copyData[(dataSize-1)/2];
}

template <typename T> T median(const std::deque<T> &data) {
    static_assert(std::is_floating_point<T>::value||
                  std::is_integral<T>::value, "T must float/int type!");
    // TODO 变为 O(n) 算法
    auto copyData = data;
    std::sort(copyData.begin(), copyData.end());
    auto dataSize = copyData.size();
    if (dataSize % 2 == 0)
        return (copyData[dataSize/2-1] + copyData[dataSize/2])/2.;
    else
        return copyData[(dataSize-1)/2];
}

template <typename T> std::vector<T> abs(const std::vector<std::complex<T>> &data) {
    std::vector<T> result;
    result.reserve(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const std::complex<T> &input){result.emplace_back(std::abs(input));});
    return result;
}

template <typename T> std::vector<T> abs(const std::vector<T> &data) {
    std::vector<T> result;
    result.reserve(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const T &input){result.emplace_back(std::abs(input));});
    return result;
}

template <typename T> std::vector<T> log(const std::vector<T> &data){
    std::vector<T> result;
    result.reserve(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const T &input){result.emplace_back(std::log(input));});
    return result;
}

template <typename T> T var(const std::vector<T> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto m = mean(data);
    T var = 0.0;
    for (auto item : data) {
       auto tmp = item - m;
        var += (tmp*tmp);
    }
    return var / data.size();
}

template <typename T> std::vector<T> linspace(T start, T stop, size_t num, bool endpoint) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    std::vector<T> res;
    if (0 == num)
        return res;
    if (1 == num) {
        res.emplace_back(start);
        return res;
    }
    res.reserve(num);
    if (start >= stop)
        throw std::invalid_argument("start should be smaller than stop");
    T step = endpoint ? (stop - start) / (num-1) : (stop - start) / num;
    for (size_t i = 0; i < num; i++) {
        res.emplace_back(start);
        start += step;
    }
    return res;
}

template <typename T> std::vector<float> linspaceFloat(long start, T stop, size_t num, bool endpoint) {
        //static_assert(std::is_floating_point<T>::value, "T must float type!");
        std::vector<float> res;
        if (0 == num)
            return res;
        if (1 == num) {
            res.emplace_back(start);
            return res;
        }
        res.reserve(num);

        if (start >= (long)stop)
            throw std::invalid_argument("start should be smaller than stop");
      float step = endpoint ? (float)(stop - start) / (num-1) : (float)(stop - start) / num;
        for (size_t i = 0; i < num; i++) {
            res.emplace_back(start);
            start += step;
        }
        return res;
    }


template <typename T> T std(const std::vector<T> &data, int ddof) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto me = mean(data);
    T sum = 0.;
    for (auto item : data) {
        auto tmp = item - me;
        sum += (tmp*tmp);
    }
    return sqrt(sum/(data.size() - ddof));
}

    template <typename T>  size_t round(const T data){
        size_t lNum = (size_t)(data + 0.5);
        return  lNum;
    }


    template <typename T> std::vector<T> expArray(const std::vector<T> &data){
        std::vector<T> tmp;
        for (auto e : data) {
            tmp.emplace_back(exp(e));
        }
        return  tmp;
    }

    template <class T> double round_size( T fl , size_t len) {
        double powMath = pow(10, len)*1.0;
        return std::round( fl * powMath ) / powMath;
    }

}
}

#endif //ENTEREEG_NUMPY_BASIC_H
