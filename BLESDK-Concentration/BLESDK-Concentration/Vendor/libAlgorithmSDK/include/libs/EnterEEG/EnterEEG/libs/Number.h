//
// Created by 雷京颢 on 2018/6/8.
//

#ifndef ENTEREEG_NUMBER_H
#define ENTEREEG_NUMBER_H

#include <vector>
#include <deque>

#include "Basic.h"


//函数声明
namespace EnterTech {
namespace EnterEEG {

/**
 * 找到质数 n 的一个原根，注意 matlab 中没有这个函数
 * @tparam T 整数类型
 * @param n  待求
 * @return   找到的原根
 */
template<typename T>
T findPrimitiveRoot(T n);

/**
 * 判断一个整数 n 是不是素数，简单算法，TODO使用AKS素数测试
 * @tparam T 整数类型
 * @param n  待判断整数
 *
 * @return   是否为素数
 */
template<typename T>
bool isprime(T n);

/**
 * 对 n 进行因式分解
 * @tparam T     整数类型
 * @param n      待分解数
 *
 * @return 结果
 */
template<typename T>
std::vector<T> factor(T n);

/**
 * 判断一个整数 a 是不是模 m 的原根，m 应该为素数。注意 matlab 中没有这个函数
 * @tparam T 整数类型
 * @param  a 待判断整数
 * @param  m 模
 *
 * @return 是否为原根
 */
template<typename T>
bool isPrimitiveRoot(T p, T m);

/**
 * 模幂运算 (a^k)%n 的较快速算法，注意 matlab 中没有这个函数
 * @tparam T 整数类型
 * @param a  a
 * @param k  k
 * @param n  n
 *
 * @return (a^k)%n
 */
template<typename T>
T expModuloN(T a, T k, T n);

/**
 * 求模逆元的模幂运算(a^(-k))%n, 注意 matlab 中没有这个函数
 * @tparam T
 * @param a
 * @param k
 * @param n
 *
 * @return (a^(-k))%n
 */
template<typename T>
T expModuloNInverse(T a, T k, T n);
}
}


namespace EnterTech {
namespace EnterEEG {


template <typename T> T findPrimitiveRoot(T n) {
    static_assert(std::is_unsigned<T>::value, "T must unsigned type!");

    if(!isprime(n))
        throw std::invalid_argument("n should be prime!");
    for (T primeRootCandidate = 2; primeRootCandidate <= n-1; primeRootCandidate++) {
        if (isPrimitiveRoot(primeRootCandidate, n)) return primeRootCandidate;
    }
    throw std::runtime_error("Prime root not found");
}

template <typename T> bool isprime(T n) {
    static_assert(std::is_unsigned<T>::value, "T must unsigned type!");

    if (n <= 1) throw std::invalid_argument("Prime/Composite test should bigger than 1");
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    T end = static_cast<T>(sqrt(n));
    for (T start = 3; start <= end; start+=2 ){
        if (n % start == 0) return false;
    }
    return true;
}

template <typename T> bool isPrimitiveRoot(T p, T m) {
    static_assert(std::is_unsigned<T>::value, "T must unsigned type!");

    T tot = m - 1;
    auto factors = factor(tot);

    //TODO faster possible
    for (T pi : factors) {
        if (expModuloN(p, tot/pi, m) == 1) return false;
    }
    return true;
}

template <typename T> std::vector<T> factor(T n) {
    static_assert(std::is_unsigned<T>::value, "T must unsigned type!");

    std::vector<T> result;
    if (1 == n) {
        result.emplace_back(1);
        return result;
    }
    for (T i = 2; i <= n; i++) {
        while (n != i) {
            if (n % i == 0) {
                result.emplace_back(i);
                n = n / i;
            } else
                break;
        }
    }
    result.emplace_back(n);
    return result;
}

template <typename T> T expModuloN(T a, T k, T n) {
    static_assert(std::is_unsigned<T>::value, "T must unsigned type!");

    if (k == 0) return 1;
    if (k == 1) return a % n;
    if (k == 2) return (a*a) % n;
    T k1 = k / 2;
    T k2 = k - k1;
    if (k1 < k2) {
        T tmp1 = expModuloN(a, k1, n);
        T tmp2 = (tmp1*a)%n;
        return (tmp1*tmp2) % n;
    } else {
        T tmp = expModuloN(a, k1, n);
        return (tmp*tmp) % n;
    }
}

template <typename T> T expModuloNInverse(T a, T k, T n) {
    static_assert(std::is_unsigned<T>::value, "T must unsigned type!");

    if (k == 0) return 1;
    if (k == 1) {
        for (T inverse = 0; inverse <= n-1; inverse++) {
            if ((a*inverse) % n == 1) return inverse;
        }
        throw std::runtime_error("modular inverse not found!");
    }
    T modInverse = expModuloNInverse<T>(a, 1, n);
    return expModuloN<T>(modInverse, k, n);
}

}
}

#endif //ENTEREEG_NUMBER_H
