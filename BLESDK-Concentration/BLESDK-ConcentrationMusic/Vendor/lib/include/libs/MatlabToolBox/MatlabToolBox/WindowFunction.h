//
//  WindowFunction.h
//  MatlabToolBox
//
//  Created by leijinghao on 16/8/9.
//  Copyright © 2016年 EnterTech. All rights reserved.
//
//  该文件定义了窗函数
//

#ifndef MatlabToolBox_MatlabToolBox_WindowFunction_H
#define MatlabToolBox_MatlabToolBox_WindowFunction_H

#include "Basic.h"


//函数声明
namespace EnterTech {
namespace MatlabToolBox {

/**
 *  汉明窗
 *
 *  @param n      所需汉明窗长度
 *
 *  @return       返回结果
 */
template <typename T> std::vector<T> hamming(size_t n);

namespace WindowFunctionInner {

/**
 *  汉明窗内部调用函数
 *
 *  @param m      m
 *  @param n      n
 *  @param window 窗函数名
 
 *  @return       返回结果
 */
template <typename T> std::vector<T> calc_window(size_t m, size_t n, const std::string& window);

}

}
}

//函数定义
namespace EnterTech {
namespace MatlabToolBox {

template <typename T> std::vector<T> hamming(size_t n) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<T> w;

    size_t half = 0;
    bool evenFlag = false;
    if (0 == n % 2) { //Even
        half = n / 2;
        evenFlag = true;
    } else { //Odd
        half = (n + 1) / 2;
    }

    w = WindowFunctionInner::calc_window<T>(half, n, "hamming");
    auto res = w;
    res.reserve(w.size() * 2);
    if (evenFlag) {
        res.insert(res.end(), w.crbegin(), w.crend());
    } else {
        res.insert(res.end(), w.crbegin()+1, w.crend());
    }
    return res;
}

namespace WindowFunctionInner {

template <typename T> std::vector<T> calc_window(size_t m, size_t n, const std::string& window) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if (window != "hamming") {
        throw std::invalid_argument("calc_window only support hamming");
    }

    std::vector<T> w;
    w.reserve(m);
    for (unsigned i = 0; i <= m - 1; ++i) {
        w.push_back(0.54 - 0.46 * cos(2 * M_PI * i / (n - 1)));
    }
    return w;
}

}

}
}

#endif
