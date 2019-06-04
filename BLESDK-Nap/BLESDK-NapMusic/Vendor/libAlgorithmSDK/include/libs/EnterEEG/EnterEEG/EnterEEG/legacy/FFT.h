//
// Created by 雷京颢 on 2018/6/8.
//

#ifndef ENTEREEG_LIBS_FFT_H
#define ENTEREEG_LIBS_FFT_H

#include <vector>
#include <deque>
#include <numeric>
#include <complex>

#include "Basic.h"
#include "Number.h"

#ifndef M_PI
#define M_PI 3.141592653589793238462643
#endif

#ifndef DOUBLE_PI
#define DOUBLE_PI 6.283185307179586476925287
#endif


//函数声明
namespace EnterTech {
namespace EnterEEG {

/**
 *  fft计算，当输入数据长度是2的幂时使用基2-FFT算法迭代实现，复杂度O(nlogn);否则使用雷德算法和库利-图基混合基算法
 *
 *  @param data   输入数据（复数）
 *
 *  @return 输出数据（复数）
 *
 *  @see fft(const std::vector<std::complex<T> > &data,size_t N)
 *  @see fft(const std::vector<T> &data)
 *  @see recursiveFFT(const std::vector<std::complex<T> > &data)
 *  @see fft(const std::vector<T> &data, size_t N)
 */
template<typename T>
std::vector<std::complex<T>> fft(const std::vector<std::complex<T> > &data);

/**
 *  fft计算, 当输入数据长度是2的幂时使用基2-FFT算法迭代实现，复杂度O(nlogn);否则使用雷德算法和库利-图基混合基算法
 *
 *  @param data   输入数据(自动转换为复数)
 *
 *  @return 输出数据（复数）
 *
 *  @see fft(const std::vector<std::complex<T> > &data)
 *  @see fft(const std::vector<std::complex<T> > &data, size_t N)
 *  @see recursiveFFT(const std::vector<std::complex<T> > &data)
 *  @see fft(const std::vector<T> &data, size_t N)
 */
template<typename T>
std::vector<std::complex<T> > fft(const std::vector<T> &data);

/**
 *  fft计算, 当输入数据长度是2的幂时使用基2-FFT算法迭代实现，复杂度O(nlogn);否则使用雷德算法和库利-图基混合基算法
 *
 *  @param data   输入数据（复数）
 *  @param N      长度
 *
 *  @return  输出数据（复数）
 *
 *  @see fft(const std::vector<std::complex<T>> &data)
 *  @see fft(const std::vector<T> &data)
 *  @see recursiveFFT(const std::vector<std::complex<T>> &data)
 *  @see fft(const std::vector<T> &data,size_t N)
 */
template<typename T>
std::vector<std::complex<T> > fft(const std::vector<std::complex<T> > &data, size_t N);

/**
 *  fft计算, 当输入数据长度是2的幂时使用基2-FFT算法迭代实现，复杂度O(nlogn);否则使用雷德算法和库利-图基混合基算法
 *
 *  @param data   输入数据（复数）
 *  @param N      长度
 *
 *  @return 输出数据（复数）
 *
 *  @see fft(const std::vector<std::complex<T> > &data)
 *  @see fft(const std::vector<T> &data)
 *  @see recursiveFFT(const std::vector<std::complex<T> > &data)
 *  @see template <typename T> void fft(const std::vector<std::complex<T> > &data,size_t N)
 */
template<typename T>
std::vector<std::complex<T>> fft(const std::vector<T> &data, size_t N);

/**
 * ifft计算，直接使用 data 的长度作为运算点数
 * @tparam T     可以是任意浮点型
 * @param data   输入复数
 *
 * @return result 结果
 *
 * @see ifft(const std::vector<T> &data)
 * @see ifft(const std::vector<std::complex<T> > &data, size_t N)
 */
template<typename T>
std::vector<std::complex<T>> ifft(const std::vector<std::complex<T>> &data);

/**
 * ifft计算，直接使用 data 的长度作为运算点数
 * @tparam T     可以是任意浮点型
 * @param data   输入实数，自动转换为复数运算
 *
 * @return 结果（复数）
 *
 * @see ifft(const std::vector<std::complex<T>> &data)
 * @see ifft(const std::vector<std::complex<T> > &data, size_t N)
 */
template<typename T>
std::vector<std::complex<T>> ifft(const std::vector<T> &data);

/**
 * ifft计算，当输入数据长度是2的幂时使用基2-FFT算法迭代实现，复杂度O(nlogn);
 *
 * @param data   输入数据
 * @param N      长度
 *
 * @return result 输出数据
 *
 * @see ifft(const std::vector<std::complex<T>> &data)
 * @see ifft(const std::vector<T> &data)
 */
template<typename T>
std::vector<std::complex<T> > ifft(const std::vector<std::complex<T> > &data, size_t N);

/**
 *  ifft计算，当输入数据长度是2的幂时使用基2-FFT算法迭代实现，复杂度O(nlogn);
 *
 *  @param data   输入数据
 *  @param N      长度
 *
 *  @return 输出数据（复数）
 *
 *  @see ifft(const std::vector<std::complex<T> > &data, size_t N)
 *  @see ifft(const std::vector<T> &data)
 *  @see ifft(const std::vector<std::complex<T>> &data)
 */
template<typename T>
std::vector<std::complex<T>> ifft(const std::vector<T> &data, size_t N);

namespace FFTInner {
/**
 *  计算比n大的最小的2的幂
 *
 *  @param n n
 *
 *  @return 最小的2的幂
 */
template <typename T> T nextPowerOf2(T n);

/**
 *   dft 原始定义计算方法，时间复杂度 O(n^2)，仅供参考
 *
 *  @param data   输入数据
 *  @param N      长度
 *
 *  @return 输出数据（复数）
 */
template<typename T>
std::vector<std::complex<T>> dft(const std::vector<std::complex<T>> &data, size_t N);

/**
 *  radix-2 库利－图基迭代计算fft,参照算法导论中有关FFT部分
 *
 *  @param data   原始数据（复数）
 *
 *  @return fft后的结果（复数）
 */
template<typename T>
std::vector<std::complex<T>> radix2FFT(const std::vector<std::complex<T>> &data);

/**
 *  固定的8点fft算法，非递归的蝶形算法
 *
 *  @param data   原始数据（复数）
 *
 *  @return fft后的结果（复数）
 */
template<typename T>
std::vector<std::complex<T>> fft8(const std::vector<std::complex<T>> &data);

/**
 *  直接计算离散傅里叶变换的逆变换，时间复杂度 O(n^2)，仅供参考
 *
 * @param data   原始数据（复数）
 * @param N      长度
 *
 * @return 输出数据（复数）
 */
template<typename T>
std::vector<std::complex<T>> idft(const std::vector<std::complex<T>> &data, size_t N);

/**
 *  迭代计算ifft,参照算法导论中有关FFT部分,注意这个结果需要除以 N 才行！
 *
 *  @tparam T     必须是浮点型
 *  @param data   原始数据（复数）
 *
 *  @return ifft后的结果（复数）
 */
template<typename T>
std::vector<std::complex<T>> radix2IFFT(const std::vector<std::complex<T>> &data);

/**
 *  固定的8点ifft算法，非递归的蝶形算法
 *
 *  @param data   原始数据（复数）
 *
 *  @return ifft后的结果（复数）
 */
template<typename T>
std::vector<std::complex<T>> ifft8(const std::vector<std::complex<T>> &data);

/**
 * 雷德算法 fft
 * @tparam T   必须是浮点型
 * @param data 长度必须是素数
 *
 * @return 雷德算法结果（复数）
 */
template<typename T>
std::vector<std::complex<T>> raderFFT(const std::vector<std::complex<T>> &data);

/**
 * 库利-图基混合基算法加雷德算法 fft
 *
 * @tparam T 必须是浮点型
 * @param data
 *
 * @return fft结果(复数)
 */
template<typename T>
std::vector<std::complex<T>> hybridFFT(const std::vector<std::complex<T>> &data);

/**
 * 雷德算法 ifft
 * @tparam T   必须是浮点型
 * @param data 长度必须是素数
 *
 * @return ifft结果
 */
template<typename T>
std::vector<std::complex<T>> raderIFFT(const std::vector<std::complex<T>> &data);

/**
 * 库利-图基混合基算法加雷德算法 ifft
 * @tparam T
 * @param data
 *
 * @return ifft结果
 */
template<typename T>
std::vector<std::complex<T>> hybridIFFT(const std::vector<std::complex<T>> &data);

}
}
}


//函数定义
namespace EnterTech {
namespace EnterEEG {

template <typename T> std::vector<std::complex<T>> fft(const std::vector<T> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    return fft(toComplex(data));
}

template <typename T> std::vector<std::complex<T>> fft(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if (FFTInner::nextPowerOf2(data.size()) != data.size())
        return FFTInner::hybridFFT(data);
    else
        return FFTInner::radix2FFT(data);
}

template <typename T> std::vector<std::complex<T>> fft(const std::vector<std::complex<T>> &data, size_t N) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector <std::complex<T>> da = data;
    da.resize(N, std::complex<T>(0.0, 0.0));
    if (FFTInner::nextPowerOf2(N) != N) {
        return FFTInner::hybridFFT(da);
    } else {
        return FFTInner::radix2FFT(da);
    }
}

template <typename T> std::vector<std::complex<T> > fft(const std::vector<T> &data, size_t N) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    return fft(toComplex(data), N);
}

template <typename T> std::vector<std::complex<T>> ifft(const std::vector<std::complex<T>> &data){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    return ifft(data, data.size());
}

template <typename T> std::vector<std::complex<T>> ifft(const std::vector<T> &data){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    return ifft(toComplex(data), data.size());
}

template <typename T> std::vector<std::complex<T>> ifft(const std::vector<T> &data, size_t N) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    return ifft(toComplex(data), N);
}

template <typename T> std::vector<std::complex<T>> ifft(const std::vector<std::complex<T> > &data, size_t N) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");


    std::vector <std::complex<T>> da = data;
    da.resize(N, std::complex<T>(0.0, 0.0));
    if (FFTInner::nextPowerOf2(N) != N) {
        return FFTInner::hybridIFFT(da);
    } else {
        auto result = FFTInner::radix2IFFT(da);
        for (auto it = result.begin(); it != result.end(); ++it)
            (*it) = std::complex<T>((*it).real() / N, (*it).imag() / N);
        return result;
    }
}

namespace FFTInner {

template <typename T> T nextPowerOf2(T n) {
    if (n < 0)
        return n;
    unsigned int p = 1;
    if (n && !(n & (n - 1)))
        return n;

    while (p < n) {
        p <<= 1;
    }
    return p;
}

template<typename T>
std::vector<std::complex<T>> dft(const std::vector<std::complex<T>> &data, size_t N) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<std::complex<T>> result;
    result.reserve(N);
    for (size_t k = 0; k <= N - 1; k++) {
        std::complex<T> tmp(0.0, 0.0);
        for (size_t n = 0; n <= N - 1; n++) {
            tmp += data[n] * std::complex<T>(cos(DOUBLE_PI * k * n / N), -sin(DOUBLE_PI * k * n / N));
        }
        result.emplace_back(tmp);
    }
    return result;
}

template<typename T>
std::vector<std::complex<T>> fft8(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    static const std::vector<std::complex<T> > wn = {
            std::complex<T>(1.0, 0.0),
            std::complex<T>(cos(DOUBLE_PI / 8), -sin(DOUBLE_PI / 8)),
            std::complex<T>(cos(DOUBLE_PI / 4), -sin(DOUBLE_PI / 4)),
            std::complex<T>(cos(DOUBLE_PI * 3 / 8), -sin(DOUBLE_PI * 3 / 8))};

    std::vector<std::complex<T> > colTmp1, colTmp2, result;
    colTmp1.reserve(8);
    colTmp2.reserve(8);
    result.reserve(8);

    //DIT FFT
    colTmp1.emplace_back(data[0] + data[4]);
    colTmp1.emplace_back(data[0] - data[4]);
    colTmp1.emplace_back(data[2] + data[6]);
    colTmp1.emplace_back((data[2] - data[6]) * wn[2]);
    colTmp1.emplace_back(data[1] + data[5]);
    colTmp1.emplace_back(data[1] - data[5]);
    colTmp1.emplace_back(data[3] + data[7]);
    colTmp1.emplace_back((data[3] - data[7]) * wn[2]);

    colTmp2.emplace_back(colTmp1[0] + colTmp1[2]);
    colTmp2.emplace_back(colTmp1[1] + colTmp1[3]);
    colTmp2.emplace_back(colTmp1[0] - colTmp1[2]);
    colTmp2.emplace_back(colTmp1[1] - colTmp1[3]);
    colTmp2.emplace_back(colTmp1[4] + colTmp1[6]);
    colTmp2.emplace_back((colTmp1[5] + colTmp1[7]) * wn[1]);
    colTmp2.emplace_back((colTmp1[4] - colTmp1[6]) * wn[2]);
    colTmp2.emplace_back((colTmp1[5] - colTmp1[7]) * wn[3]);

    result.emplace_back(colTmp2[0] + colTmp2[4]);
    result.emplace_back(colTmp2[1] + colTmp2[5]);
    result.emplace_back(colTmp2[2] + colTmp2[6]);
    result.emplace_back(colTmp2[3] + colTmp2[7]);
    result.emplace_back(colTmp2[0] - colTmp2[4]);
    result.emplace_back(colTmp2[1] - colTmp2[5]);
    result.emplace_back(colTmp2[2] - colTmp2[6]);
    result.emplace_back(colTmp2[3] - colTmp2[7]);

    return result;
}

template<typename T>
std::vector<std::complex<T>> idft(const std::vector<std::complex<T>> &data, size_t N) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<std::complex<T>> result;
    result.reserve(N);
    for (size_t n = 0; n <= N - 1; n++) {
        std::complex<T> tmp(0.0, 0.0);
        for (size_t k = 0; k <= N - 1; k++) {
            tmp += data[k] * std::complex<T>(cos(DOUBLE_PI * k * n / N), sin(DOUBLE_PI * k * n / N));
        }
        result.emplace_back(std::complex<T>(tmp.real() / N, tmp.imag() / N));
    }
    return result;
}

template<typename T>
std::vector<std::complex<T>> ifft8(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    static const std::vector<std::complex<T> > wn = {
            std::complex<T>(1.0, 0.0),
            std::complex<T>(cos(DOUBLE_PI / 8), sin(DOUBLE_PI / 8)),
            std::complex<T>(cos(DOUBLE_PI / 4), sin(DOUBLE_PI / 4)),
            std::complex<T>(cos(DOUBLE_PI * 3 / 8), sin(DOUBLE_PI * 3 / 8))};

    std::vector<std::complex<T> > colTmp1, colTmp2, result;
    colTmp1.reserve(8);
    colTmp2.reserve(8);
    result.reserve(8);

    //DIT IFFT
    colTmp1.emplace_back(data[0] + data[4]);
    colTmp1.emplace_back(data[0] - data[4]);
    colTmp1.emplace_back(data[2] + data[6]);
    colTmp1.emplace_back((data[2] - data[6]) * wn[2]);
    colTmp1.emplace_back(data[1] + data[5]);
    colTmp1.emplace_back(data[1] - data[5]);
    colTmp1.emplace_back(data[3] + data[7]);
    colTmp1.emplace_back((data[3] - data[7]) * wn[2]);

    colTmp2.emplace_back(colTmp1[0] + colTmp1[2]);
    colTmp2.emplace_back(colTmp1[1] + colTmp1[3]);
    colTmp2.emplace_back(colTmp1[0] - colTmp1[2]);
    colTmp2.emplace_back(colTmp1[1] - colTmp1[3]);
    colTmp2.emplace_back(colTmp1[4] + colTmp1[6]);
    colTmp2.emplace_back((colTmp1[5] + colTmp1[7]) * wn[1]);
    colTmp2.emplace_back((colTmp1[4] - colTmp1[6]) * wn[2]);
    colTmp2.emplace_back((colTmp1[5] - colTmp1[7]) * wn[3]);

    result.emplace_back(colTmp2[0] + colTmp2[4]);
    result.emplace_back(colTmp2[1] + colTmp2[5]);
    result.emplace_back(colTmp2[2] + colTmp2[6]);
    result.emplace_back(colTmp2[3] + colTmp2[7]);
    result.emplace_back(colTmp2[0] - colTmp2[4]);
    result.emplace_back(colTmp2[1] - colTmp2[5]);
    result.emplace_back(colTmp2[2] - colTmp2[6]);
    result.emplace_back(colTmp2[3] - colTmp2[7]);
    return result;
}

template<typename T>
std::vector<std::complex<T>> radix2FFT(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto n = data.size();
    if (8 == n) {
        return fft8(data);
    }
    if (1 == n) {
        return data;
    }
    std::complex<T> wn(cos(DOUBLE_PI / n), -sin(DOUBLE_PI / n));
    std::complex<T> w(1, 0);
    typename std::vector<std::complex<T> > a0, a1;
    a0.reserve(data.size() / 2);
    a1.reserve(data.size() / 2);
    for (auto it = data.cbegin(); it != data.cend();) {
        a0.emplace_back((*it));
        ++it;
        a1.emplace_back((*it));
        ++it;
    }

    auto y0 = radix2FFT(a0);
    auto y1 = radix2FFT(a1);
    std::vector<std::complex<T>> result(n, std::complex<T>(0., 0.));
    for (size_t k = 0; k <= n / 2 - 1; k++) {
        result[k] = y0[k] + w * y1[k];
        result[k + n / 2] = y0[k] - w * y1[k];
        w = w * wn;
    }
    return result;
}

template<typename T>
std::vector<std::complex<T>> radix2IFFT(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto n = data.size();
    if (8 == n) {
        return ifft8(data);
    }
    if (1 == n) {
        return data;
    }
    std::complex<T> wn(cos(-DOUBLE_PI / n), -sin(-DOUBLE_PI / n));
    std::complex<T> w(1, 0);
    typename std::vector<std::complex<T> > a0, a1;
    a0.reserve(data.size() / 2);
    a1.reserve(data.size() / 2);
    for (auto it = data.cbegin(); it != data.cend();) {
        a0.emplace_back((*it));
        ++it;
        a1.emplace_back((*it));
        ++it;
    }

    auto y0 = radix2IFFT(a0);
    auto y1 = radix2IFFT(a1);
    std::vector<std::complex<T>> result(n, std::complex<T>(0., 0.));
    for (size_t k = 0; k <= n / 2 - 1; k++) {
        result[k] = y0[k] + w * y1[k];
        result[k + n / 2] = y0[k] - w * y1[k];
        w = w * wn;
    }
    return result;
}

template<typename T>
std::vector<std::complex<T>> raderFFT(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto N = data.size();
    auto X0 = std::accumulate(data.cbegin(), data.cend(), std::complex<T>(0.0, 0.0));
    auto g = findPrimitiveRoot(data.size());
    std::vector<std::complex<T>> aq, bq, product;
    std::vector<size_t> aqIndex, bqIndex;

    aqIndex.emplace_back(1);
    bqIndex.emplace_back(1);
    aq.emplace_back(data[1]);
    bq.emplace_back(std::complex<T>(cos(DOUBLE_PI / N), -sin(DOUBLE_PI / N)));
    auto exp = expModuloN(g, static_cast<size_t>(1), N);
    auto expInverse = expModuloNInverse(g, static_cast<size_t>(1), N);
    auto expInverseBase = expInverse;

    for (size_t index = 1; index <= N - 2; index++) {
        aqIndex.emplace_back(exp);
        bqIndex.emplace_back(expInverse);

        aq.emplace_back(data[exp]);
        auto tmp = expInverse * DOUBLE_PI / N;
        bq.emplace_back(std::complex<T>(cos(tmp), -sin(tmp)));

        exp = (exp * g) % N;
        expInverse = (expInverse * expInverseBase) % N;
    }

    // 补零
    auto M = nextPowerOf2(2 * N - 3);
    if (M != N - 1) {
        aq.insert(aq.begin() + 1, M - N + 1, std::complex<T>(0.0, 0.0));
        for (size_t index = 0; index < M - N + 1; index++)
            bq.emplace_back(bq[index]);
    }

    auto faq = radix2FFT(aq);
    auto fbq = radix2FFT(bq);
    for (size_t index = 0; index <= M - 1; index++) {
        product.emplace_back(faq[index] * fbq[index]);
    }
    auto inverseDFT = radix2IFFT(product);
    std::vector<std::complex<T>> result(N, std::complex<T>(0.0, 0.0));
    result[0] = X0;

    for (size_t index = 0; index < N - 1; index++)
        result[bqIndex[index]] = inverseDFT[index] / static_cast<T>(M) + data[0];

    return result;
}

template<typename T>
std::vector<std::complex<T>> raderIFFT(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto N = data.size();
    auto X0 = std::accumulate(data.cbegin(), data.cend(), std::complex<T>(0.0, 0.0));
    auto g = findPrimitiveRoot(data.size());
    std::vector<std::complex<T>> aq, bq, product;
    std::vector<size_t> aqIndex, bqIndex;

    aqIndex.emplace_back(1);
    bqIndex.emplace_back(1);
    aq.emplace_back(data[1]);
    bq.emplace_back(std::complex<T>(cos(DOUBLE_PI / N), sin(DOUBLE_PI / N)));

    auto exp = expModuloN(g, static_cast<size_t>(1), N);
    auto expInverse = expModuloNInverse(g, static_cast<size_t>(1), N);
    auto expInverseBase = expInverse;
    for (size_t index = 1; index <= N - 2; index++) {
        aqIndex.emplace_back(exp);
        bqIndex.emplace_back(expInverse);

        aq.emplace_back(data[exp]);
        auto tmp = expInverse * DOUBLE_PI / N;
        bq.emplace_back(std::complex<T>(cos(tmp), sin(tmp)));

        exp = (exp * g) % N;
        expInverse = (expInverse * expInverseBase) % N;
    }

    // 补零
    auto M = nextPowerOf2(2 * N - 3);
    if (M != N - 1) {
        aq.insert(aq.begin() + 1, M - N + 1, std::complex<T>(0.0, 0.0));
        for (size_t index = 0; index < M - N + 1; index++)
            bq.emplace_back(bq[index]);
    }

    auto faq = radix2FFT(aq);
    auto fbq = radix2FFT(bq);
    for (size_t index = 0; index <= M - 1; index++) {
        product.emplace_back(faq[index] * fbq[index]);
    }
    auto inverseDFT = radix2IFFT(product);
    std::vector<std::complex<T>> result(N, std::complex<T>(0.0, 0.0));
    result[0] = X0 / static_cast<T>(N);

    for (size_t index = 0; index < N - 1; index++)
        result[bqIndex[index]] = (inverseDFT[index] / static_cast<T>(M) + data[0]) / static_cast<T>(N);

    return result;
}

//TODO: 性能优化
template<typename T>
std::vector<std::complex<T>> hybridFFT(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto N = data.size();
    if (N == 1 || N == 2) {
        return radix2FFT(data);
    }

    // 如果N是质数
    auto factors = factor<size_t>(N);
    if (factors.size() == 1) {
        return raderFFT(data);
    }

    // 生成N1和N2，使得 N=N1*N2
    size_t N1 = factors[0], N2 = N / N1;

    std::complex<T> **X;
    X = new std::complex<T> *[N1];
    for (size_t i = 0; i < N1; i++)
        X[i] = new std::complex<T>[N2];
    for (size_t n1 = 0; n1 < N1; n1++)
        for (size_t n2 = 0; n2 < N2; n2++)
            X[n1][n2] = data[N1 * n2 + n1];
    for (size_t n1 = 0; n1 < N1; n1++) {
        std::vector<std::complex<T>> row;
        row.reserve(N2);
        for (size_t i = 0; i < N2; i++)
            row.emplace_back(X[n1][i]);
        auto tmp = fft(row);
        for (size_t n2 = 0; n2 < N2; n2++)
            X[n1][n2] = tmp[n2] * std::complex<T>(cos(DOUBLE_PI * n1 * n2 / N), -sin(DOUBLE_PI * n1 * n2 / N));
    }

    for (size_t n2 = 0; n2 < N2; n2++) {
        std::vector<std::complex<T>> col;
        col.reserve(N1);
        for (size_t n1 = 0; n1 < N1; n1++)
            col.emplace_back(X[n1][n2]);
        auto tmp = fft(col);
        for (size_t n1 = 0; n1 < N1; n1++)
            X[n1][n2] = tmp[n1];
    }

    std::vector<std::complex<T>> result(data.size(), std::complex<T>(0.0, 0.0));
    for (size_t n1 = 0; n1 < N1; n1++)
        for (size_t n2 = 0; n2 < N2; n2++)
            result[N2 * n1 + n2] = X[n1][n2];

    for (size_t i = 0; i < N1; i++)
        delete[] X[i];
    delete[] X;
    return result;
}

template<typename T>
std::vector<std::complex<T>> hybridIFFT(const std::vector<std::complex<T>> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto N = data.size();
    if (N == 1 || N == 2) {
        auto result = radix2IFFT(data);
        for (auto item:result)
            item = item / static_cast<T>(N);
        return result;
    }

    // 如果N是质数
    auto factors = factor<size_t>(N);
    if (factors.size() == 1) {
        return raderIFFT(data);
    }

    // 生成N1和N2，使得 N=N1*N2
    size_t N1 = factors[0], N2 = N / N1;

    std::complex<T> **X;
    X = new std::complex<T> *[N1];
    for (size_t i = 0; i < N1; i++)
        X[i] = new std::complex<T>[N2];
    for (size_t n1 = 0; n1 < N1; n1++)
        for (size_t n2 = 0; n2 < N2; n2++)
            X[n1][n2] = data[N1 * n2 + n1];
    for (size_t n1 = 0; n1 < N1; n1++) {
        std::vector<std::complex<T>> row;
        row.reserve(N2);
        for (size_t i = 0; i < N2; i++)
            row.emplace_back(X[n1][i]);
        auto tmp = ifft(row);
        for (size_t n2 = 0; n2 < N2; n2++)
            X[n1][n2] = tmp[n2] * std::complex<T>(cos(DOUBLE_PI * n1 * n2 / N), sin(DOUBLE_PI * n1 * n2 / N)) *
                        static_cast<T>(N2);
    }

    for (size_t n2 = 0; n2 < N2; n2++) {
        std::vector<std::complex<T>> col;
        col.reserve(N1);
        for (size_t n1 = 0; n1 < N1; n1++)
            col.emplace_back(X[n1][n2]);
        auto tmp = ifft(col);
        for (size_t n1 = 0; n1 < N1; n1++)
            X[n1][n2] = tmp[n1] * static_cast<T>(N1);
    }

    std::vector<std::complex<T>> result(data.size(), std::complex<T>(0.0, 0.0));
    for (size_t n1 = 0; n1 < N1; n1++)
        for (size_t n2 = 0; n2 < N2; n2++)
            result[N2 * n1 + n2] = X[n1][n2] / static_cast<T>(N);

    for (size_t i = 0; i < N1; i++)
        delete[] X[i];
    delete[] X;
    return result;
}

}
}
}

#endif //ENTEREEG_LIBS_FFT_H
