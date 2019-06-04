//
// Created by 雷京颢 on 2018/7/18.
//

#ifndef ENTEREEG_NUMPY_BASIC_H
#define ENTEREEG_NUMPY_BASIC_H

#include <algorithm>
#include <vector>
#include <deque>

namespace EnterTech {
namespace EnterEEG {

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

}
}

namespace EnterTech {
namespace EnterEEG {

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

}
}

#endif //ENTEREEG_NUMPY_BASIC_H
