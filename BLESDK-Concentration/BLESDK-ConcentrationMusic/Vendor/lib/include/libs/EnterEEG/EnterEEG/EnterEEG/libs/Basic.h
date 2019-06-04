//
// Created by 雷京颢 on 2018/6/7.
//

#ifndef ENTEREEG_LIBS_BASIC_H
#define ENTEREEG_LIBS_BASIC_H

#include <vector>
#include <complex>
#include <algorithm>
#include <numeric>
#include <stdexcept>
#include <functional>

namespace EnterTech {
namespace EnterEEG {

/**
 *  模拟python内截取数组内一段数据的操作。
 *
 *  @param data   原始数组vector
 *  @param start  与python一致的截取开始下标
 *  @param end    与python一致的截取截取下标
 *
 *  @return  截取结果vector
 */
template <typename T> std::vector<T> truncate(const std::vector<T> &data, int start, int endIndex);

/**
 *  模拟python内截取数组内数据操作。支持负数下标志
 *
 *  @param data   原始数组vector
 *  @param index  与python一致的截取下标
 *
 *  @return  截取结果
 */
template <typename T> T truncate(const std::vector<T> &data, int index);

/**
 *  用于实数类型的求平均，参数必须包含一个以上的数据！注意内部会将T类型转换成long double累加！因此需要保证从T类型到long double转换的存在
 *
 *  @param data 待求数据的vector
 *
 *  @return 数据平均值
 */
template <typename T> T mean(const std::vector<T> &data);

/**
 *  用于各种数据类型的求最大值
 *
 *  @param data 待求数据的vector
 *
 *  @return 数据最大值
 */
template <typename T> T max(const std::vector<T> &data);

/**
 *  用于各种数据类型的求最小值
 *
 *  @param data 待求数据的vector
 *
 *  @return 数据最小值
 */
template <typename T> T min(const std::vector<T> &data);

/**
 *  求和。
 *
 *  @param data 待求数据的vector
 *
 *  @return 数据和
 */
template <typename T> T sum(const std::vector<T> &data);

/**
 *  求和。
 *
 *  @param data 待求数据的vector
 *
 *  @return 数据和
 */
template <typename T> T sum(const std::deque<T> &data);

/**
 *  模拟numpy中的数组相减 res=data1-data2
 *
 * @param data1  被减数
 * @param data2  减数
 *
 * @return 数组相减结果
 */
template <typename T> std::vector<T> minus(const std::vector<T> &data1, const std::vector<T> &data2);

/**
 *  模拟numpy中的数组标量相减 res=data1-data2
 *
 * @param data1  被减数数组
 * @param data2  减数标量
 *
 * @return 相减结果
 */
template <typename T> std::vector<T> minus(const std::vector<T> &data1, const T &data2);

/**
 *  模拟numpy中的数组相加 res=data1+data2
 *
 * @param data1  被加数
 * @param data2  加数
 *
 * @return 相加结果
 */
template <typename T> std::vector<T> add(const std::vector<T> &data1, const std::vector<T> &data2);

/**
 *  模拟numpy中的数组标量相加 res=data1+data2
 *
 * @param data1  被加数数组
 * @param data2  加数标量
 *
 * @return 相加结果
 */
template <typename T> std::vector<T> add(const std::vector<T> &data1, const T &data2);

/**
 * 模拟numpy中的点乘 res = data1*data2
 *
 * @tparam T 任意支持乘法的量
 * @param data1 data1
 * @param data2 data2
 *
 * @return 点乘结果
 */
template <typename T> std::vector<T> dotMultiply(const std::vector<T> &data1, const std::vector<T> &data2);

/**
 * 模拟numpy中的数组标量相乘 res=data1*data2
 * @tparam T     任意支持乘法的量
 * @param data1  数组
 * @param data2  标量
 * @return 相乘结果
 */
template <typename T> std::vector<T> multiply(const std::vector<T> &data1, const T &data2);

/**
 *  将各类实数（浮点数和整数）转换为复数
 *
 *  @param data   实数
 *
 *  @return  复数
 */
template <typename T> std::vector<std::complex<T>> toComplex(const std::vector<T> &data);

/**
 *  将实数和纯虚数合成为复数
 *
 *  @param real   实数
 *  @param img    纯虚数
 *
 *  @return  复数
 */
template <typename T> std::vector<std::complex<T> > toComplex(const std::vector<T> &real, const std::vector<T> &img);

/**
 *  取复数的实数部分
 *
 *  @param data 需要操作的数据
 *
 *  @return 实数结果
 */
template <typename T> std::vector<T> real(const std::vector<std::complex<T>> &data);

/**
 *  模拟python中形如a[start:end] = val的赋值
 *
 *  @param data  待处理的数组
 *  @param start 开始下标
 *  @param end   结束下标
 *  @param val   需要的赋值
 */
template <typename T> void set(std::vector<T> &data, size_t start, size_t end, const T &val);

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
 *  模拟matlab内截取数组内一段数据的操作,带步进参数。注意！这里为了和matlab保持一致，start和end的index从1开始计数
 *
 *  @param data   原始数组vector
 *  @param start  与MATLAB一致的截取开始下标（含）
 *  @param step   步进
 *  @param end    与MATLAB一致的截取截取下标（含）
 *
 *  @return 截取结果vector
 */
template <typename T> std::vector<T> truncateMatlab(const std::vector<T> &data, size_t start, typename std::vector<T>::difference_type step, size_t end);

/**
 * 模拟Matlab中的any函数，判断数组中是否有非零元素
 * @tparam T  可以是整型或者浮点
 * @param data 输入
 * @return 是否有非零元素
 */
template <typename T> bool anyMatlab(const std::vector<T> &data);

/**
 *  模拟matlab中的find函数，注意从下标0开始计算
 *
 *  @param data 待处理的数组
 *  @param func 判断条件
 *
 *  @return  返回结果，注意从下标0开始计算
 */
template <typename T> std::vector<size_t> find(const std::vector<T> &data, std::function<bool(T)> func);


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
 *  @param data   待求数据vector
 *
 *  @return  求值结果
 */
template <typename T> std::vector<T> abs(const std::vector<std::complex<T> > &data);

/**
 *  排序
 *
 *  @param data   待排序vector
 *
 *  @return  排序结果
 */
template <typename T> std::vector<T> sort(const std::vector<T> &data);

/**
 *  求复数的共轭
 *
 *  @param data   输入
 *
 *  @return 返回结果result
 */
template <typename T> std::vector<std::complex<T>> conj(const std::vector<std::complex<T>> &data);


}
}


namespace EnterTech {
namespace EnterEEG {

template <typename T> std::vector<T> truncate(const std::vector<T> &data, int start, int endIndex) {
    std::vector<T> result;
    if (start < 0) start = static_cast<int>(data.size()) + start;
    if (endIndex < 0) endIndex = static_cast<int>(data.size()) + endIndex;

    if (start >= endIndex || static_cast<size_t>(start) == data.size())
        return result;
    endIndex = endIndex > static_cast<int>(data.size()) ? static_cast<int>(data.size()) : endIndex;
    auto startIt = data.cbegin() + start, endIt = data.cbegin() + endIndex;
    result.assign(startIt, endIt);
    return result;
}

template <typename T> T truncate(const std::vector<T> &data, int index) {
    if (index >= 0) return data[index];
    else return data[data.size()+index];
}

template <typename T> T mean(const std::vector<T> &data) {
    static_assert(std::is_floating_point<T>::value||
                  std::is_integral<T>::value, "T must float/int type!");
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    long double total = *data.begin();
    for (auto it = data.cbegin() + 1; it != data.cend(); ++it)
        total += (*it);
    return static_cast<T>(total / data.size());
}

template <typename T> T max(const std::vector<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T max = data[0];
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) > max)
            max = *it;
    }
    return max;
}

template <typename T> T min(const std::vector<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T min = data[0];
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) < min)
            min = *it;
    }
    return min;
}

template <typename T> T sum(const std::vector<T> &data) {
    static_assert(std::is_floating_point<T>::value||
                  std::is_integral<T>::value, "T must float/int type!");
    if (data.empty())
        return 0;
    return std::accumulate(data.cbegin() + 1, data.cend(), data[0]);
}

template <typename T> T sum(const std::deque<T> &data) {
    static_assert(std::is_floating_point<T>::value||
                  std::is_integral<T>::value, "T must float/int type!");
    if (data.empty())
        return 0;
    return std::accumulate(data.cbegin() + 1, data.cend(), data[0]);
}

template <typename T> std::vector<T> minus(const std::vector<T> &data1, const std::vector<T> &data2) {
    std::vector<T> res;
    if (data1.size() != data2.size())
        throw std::invalid_argument("data1 data2 size not equal.");
    res.reserve(data1.size());
    for(auto it1 = data1.cbegin(), it2 = data2.cbegin(); it1 != data1.cend(); it1++, it2++) {
        res.emplace_back((*it1)-(*it2));
    }
    return res;
}

template <typename T> std::vector<T> minus(const std::vector<T> &data1, const T &data2) {
    std::vector<T> res;
    res.reserve(data1.size());
    std::for_each(data1.cbegin(), data1.cend(), [&](const T &input){res.emplace_back(input - data2);});
    return res;
}

template <typename T> std::vector<T> add(const std::vector<T> &data1, const std::vector<T> &data2) {
    std::vector<T> res;
    if (data1.size() != data2.size())
        throw std::invalid_argument("data1 data2 size not equal.");
    res.reserve(data1.size());
    for(auto it1 = data1.cbegin(), it2 = data2.cbegin(); it1 != data1.cend(); it1++, it2++) {
        res.emplace_back((*it1)+(*it2));
    }
    return res;
}

template <typename T> std::vector<T> add(const std::vector<T> &data1, const T &data2) {
    std::vector<T> res;
    res.reserve(data1.size());
    std::for_each(data1.cbegin(), data1.cend(), [&](const T &input){res.emplace_back(input + data2);});
    return res;
}

template <typename T> std::vector<T> dotMultiply(const std::vector<T> &data1, const std::vector<T> &data2) {
    std::vector<T> res;
    if (data1.size() != data2.size())
        throw std::out_of_range("data1 data2 size not equal.");
    res.reserve(data1.size());
    for(auto it1 = data1.cbegin(), it2 = data2.cbegin(); it1 != data1.cend(); it1++, it2++) {
        res.emplace_back((*it1)*(*it2));
    }
    return res;
}

template <typename T> std::vector<T> multiply(const std::vector<T> &data1, const T &data2) {
    std::vector<T> res;
    res.reserve(data1.size());
    std::for_each(data1.cbegin(), data1.cend(), [&](const T &input){res.emplace_back(input * data2);});
    return res;
}

template <typename T> std::vector<std::complex<T>> toComplex(const std::vector<T> &data) {
    std::vector<std::complex<T>> result;
    for (auto it = data.cbegin(); it != data.cend(); it++) {
        result.emplace_back(std::complex<T>(*it, 0.0));
    }
    return result;
}

template <typename T> std::vector<std::complex<T>> toComplex(const std::vector<T> &real, const std::vector<T> &img) {
    if (real.size() != img.size())
        throw std::invalid_argument("real size and img size not equal");
    std::vector<std::complex<T>> result;
    for (auto it1 = real.cbegin(), it2 = img.cbegin(); it1 != real.cend(); it1++, it2++) {
        result.emplace_back(std::complex<T>(*it1, *it2));
    }
    return result;
}

template <typename T> std::vector<T> real(const std::vector<std::complex<T>> &data) {
    std::vector<T> res;
    res.reserve(data.size());
    for (auto it = data.cbegin(); it != data.cend(); it++)
        res.emplace_back((*it).real());
    return res;
}

template <typename T> void set(std::vector<T> &data, size_t startIndex, size_t endIndex, const T &val) {
    auto currentSize = data.size();

    if (startIndex >= currentSize)
        throw std::invalid_argument("start index out of bound");
    if (endIndex > currentSize)
        throw std::invalid_argument("end index out of bound");
    for (auto index = startIndex; index < endIndex; index ++) {
        data[index] = val;
    }
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

template <typename T> std::vector<T> truncateMatlab(const std::vector<T> &data, size_t start, typename std::vector<T>::difference_type step, size_t end) {
    std::vector<T> result;
    if (0 == step)
        throw std::invalid_argument("step should not be 0");
    if (start <= 0)
        throw std::out_of_range("start index<=0");
    if (start > data.size())
        throw std::out_of_range("start index>data size");

    if (end <= 0)
        throw std::out_of_range("end index<=0");
    if (end > data.size())
        throw std::out_of_range("end index>data size");

    if (step > 0 && start > end)
        throw std::out_of_range("step>0 but end index>start index");
    if (step < 0 && start < end)
        throw std::out_of_range("step<0 but start index>end index");

    if (step > 0) {
        for (auto index = start; index <= end; index += step)
            result.emplace_back(data[index - 1]);
    }
    else {
        for (auto index = start; index >= end; index += step)
            result.emplace_back(data[index - 1]);
    }
    return result;
}

template <typename T> std::vector<size_t> findMatlab(const std::vector<T> &data, std::function<bool(T)> func){
    std::vector<size_t> res;
    for (size_t index = 0; index < data.size(); index++){
        if(func(data[index])) res.emplace_back(index);
    }
    return res;
}

template <typename T> bool anyMatlab(const std::vector<T> &data) {
    for (auto &&item : data)
        if (item != 0) return true;
    return false;
}

template <typename T> std::vector<T> abs(const std::vector<std::complex<T>> &data) {
    std::vector<T> result;
    result.reserve(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const std::complex<T> &input){result.emplace_back(std::abs(input));});
    return result;
}

template <typename T> std::vector<T> abs(const std::vector<T> &data){
    std::vector<T> result;
    result.reserve(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const T &input){result.emplace_back(std::abs(input));});
    return result;
}

template <typename T> std::vector<T> sort(const std::vector<T> &data) {
    auto res = data;
    std::sort(res.begin(), res.end());
    return res;
}

template <typename T> std::vector<std::complex<T>> conj(const std::vector<std::complex<T> > &data) {
    std::vector<std::complex<T>> result;
    result.reserve(data.size());
    for (auto it = data.cbegin(); it != data.cend(); ++it)
        result.emplace_back(std::complex<T>((*it).real(), -(*it).imag()));
    return result;
}

}
}


#endif //ENTEREEG_LIBS_BASIC_H
