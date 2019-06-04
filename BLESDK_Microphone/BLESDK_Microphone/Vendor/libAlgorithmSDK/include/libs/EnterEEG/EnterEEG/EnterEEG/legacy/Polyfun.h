//
// Created by 雷京颢 on 2018/6/11.
//

#ifndef ENTEREEG_LIBS_POLYFUN_H
#define ENTEREEG_LIBS_POLYFUN_H
#include <vector>
#include <deque>

#include "Basic.h"

//函数声明
namespace EnterTech {
namespace EnterEEG {

/**
 * 多项式拟合，用最小二乘法拟合形如y= p(1)*x^n + p(2)*x^(n-1) +...+ p(n)*x + p(n+1) 的函数
 * @param x  自变量
 * @param y  应变量
 * @param n  多项式拟合项数
 *
 * @return  多项式拟合系数结果p
 */
template <typename T> std::vector<T> polyfit(const std::vector<T> &x, const std::vector<T> &y, size_t n);

/**
 * 多项式计算函数，公式 Y = P(1)*X^N + P(2)*X^(N-1) + ... + P(N)*X + P(N+1)
 * @param p  多项式系数
 * @param x  自变量
 *
 * @return  结果
 */
template <typename T> std::vector<T> polyval(const std::vector<T> &p, const std::vector<T> &x);

}
}

namespace EnterTech {
namespace EnterEEG {

template <typename T> std::vector<T> polyval(const std::vector<T> &p, const std::vector<T> &x){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if (p.size() == 0)
        throw std::invalid_argument("p size should not be 0");
    std::vector<T> y;
    y.reserve(x.size());
    for (auto it1 = x.cbegin(); it1 != x.cend(); it1++) {
        auto res = 0.0;
        auto tmp = 1.0;
        for (auto it2 = p.crbegin(); it2 != p.crend(); it2++) {
            res += (tmp*(*it2));
            tmp *= (*it1);
        }
        y.emplace_back(res);
    }
    return y;
}

template <typename T> std::vector<T> polyfit(const std::vector<T> &x, const std::vector<T> &y, size_t n){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if (x.size() != y.size())
        throw std::invalid_argument("x, y size not equal");
    if (x.size() == 0)
        throw std::invalid_argument("x size should not be 0");
    if (n != 1)
        throw std::invalid_argument("currently only support n=1");
    double t1=0, t2=0, t3=0, t4=0;
    for (int i=0; i< static_cast<int>(x.size()); ++i) {
        t1 += x[i]*x[i];
        t2 += x[i];
        t3 += x[i]*y[i];
        t4 += y[i];
    }
    std::vector<T> p;
    p.emplace_back((t3*x.size() - t2*t4) / (t1*x.size() - t2*t2));
    p.emplace_back((t1*t4 - t2*t3) / (t1*x.size() - t2*t2));
    return p;
}

}
}
#endif //ENTEREEG_LIBS_POLYFUN_H
