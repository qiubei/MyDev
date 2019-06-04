//
//  Basic.h
//  MatlabToolBox
//
//  Created by leijinghao on 16/8/9.
//  Copyright © 2016年 EnterTech. All rights reserved.
//
//  该文件提供Matlab的基础函数
//

#ifndef MatlabToolBox_MatlabToolBox_Basic_H
#define MatlabToolBox_MatlabToolBox_Basic_H


#include <cstddef>
#include <functional>
#include <vector>
#include <deque>
#include <numeric>
#include <utility>
#include <complex>
#include <cmath>
#include <string>
#include <stdexcept>
#include <algorithm>


#ifndef M_PI
#define M_PI 3.141592653589793238462643
#endif

#ifndef DOUBLE_PI
#define DOUBLE_PI 6.283185307179586476925287
#endif

#define UNUSED(x) (void)(x)

//函数声明
namespace EnterTech {
namespace MatlabToolBox {

/**
 *  用于实数类型的求平均，参数必须包含一个以上的数据！注意内部会将T类型转换成long double累加！因此需要保证从T类型到long double转换的存在
 *
 *  @param data 待求数据的vector
 *  @see mean(const std::deque<T> &data)
 *  @see F mean(const std::vector<T> &data)
 *  @see F mean(const std::deque<T> &data)
 *
 *  @return 数据平均值
 */
template <typename T> T mean(const std::vector<T> &data);

/**
 *  用于实数类型的求平均，参数必须包含一个以上的数据！注意内部会将T类型转换成long double累加！因此需要保证从T类型到long double转换的存在
 *
 *  @param data 待求数据的deque
 *  @see mean(const std::vector<T> &data)
 *  @see F mean(const std::vector<T> &data)
 *  @see F mean(const std::deque<T> &data)
 *
 *  @return 数据平均值
 */
template <typename T> T mean(const std::deque<T> &data);

/**
 * 用于任意类型的求平均
 * @tparam T    输入类型
 * @tparam F    输出类型
 * @param data  待求量
 * @see mean(const std::deque<T> &data)
 * @see mean(const std::vector<T> &data)
 * @see F mean(const std::deque<T> &data)
 *
 * @return 数据平均值
 */
template <typename T, typename F> F mean(const std::vector<T> &data);

/**
 * 用于任意类型的求平均
 * @tparam T    输入类型
 * @tparam F    输出类型
 * @param data  待求量
 * @see mean(const std::deque<T> &data)
 * @see mean(const std::vector<T> &data)
 * @see F mean(const std::vector<T> &data)
 *
 * @return 数据平均值
 */
template <typename T, typename F> F mean(const std::deque<T> &data);

/**
 *  用于各种数据类型的求最大值
 *
 *  @param data 待求数据的vector
 *  @see max(const std::deque<T> &data)
 *  @see max(T a,T b)
 *  @see max(T a,T b,T c)
 *  @see max(T a,T b,T c,T d)
 *
 *  @return 数据最大值
 */
template <typename T> T max(const std::vector<T> &data);

/**
 *  用于各种数据类型的求最大值
 *
 *  @param data 待求数据的deque
 *  @see max(const std::vector<T> &data)
 *  @see max(T a,T b)
 *  @see max(T a,T b,T c)
 *  @see max(T a,T b,T c,T d)
 *
 *  @return 数据最大值
 */
template <typename T> T max(const std::deque<T> &data);

/**
 *  用于各种数据类型的求最小值
 *
 *  @param data 待求数据的vector
 *  @see min(const std::deque<T> &data)
 *
 *  @return 数据最小值
 */
template <typename T> T min(const std::vector<T> &data);

/**
 *  用于各种数据类型的求最小值
 *
 *  @param data 待求数据的deque
 *  @see min(const std::vector<T> &data)
 *
 *  @return 数据最小值
 */
template <typename T> T min(const std::deque<T> &data);

/**
 * 用于各种数据类型的求最大值
 * @tparam T
 * @param a a
 * @param b b
 * @return 数据最小值
 */
template <typename T> T min(const T &a, const T &b);

/**
 *  用于各种数据类型的求最大值
 *
 *  @param a a
 *  @param b b
 *  @see max(const std::vector<T> &data)
 *  @see max(const std::deque<T> &data)
 *  @see max(T a,T b,T c)
 *  @see max(T a,T b,T c,T d)
 *
 *  @return 最大值
 */
template <typename T> T max(T a, T b);

/**
 *  用于各种数据类型的求最大值
 *
 *  @param a a
 *  @param b b
 *  @param c c
 *  @see max(const std::vector<T> &data)
 *  @see max(const std::deque<T> &data)
 *  @see max(T a,T b)
 *  @see max(T a,T b,T c,T d)
 *
 *  @return 最大值
 */
template <typename T> T max(T a, T b, T c);

/**
 *  用于各种数据类型的求最大值
 *
 *  @param a a
 *  @param b b
 *  @param c c
 *  @param d d
 *  @see max(const std::vector<T> &data)
 *  @see max(const std::deque<T> &data)
 *  @see max(T a,T b)
 *  @see max(T a,T b,T c)
 *
 *  @return 最大值
 */
template <typename T> T max(T a, T b, T c, T d);

/**
 *  求和。
 *
 *  @param data 待求数据的deque
 *  @see sum(const std::vector<T> &data)
 *  @see sum(const std::vector<T> &data, const size_t& start, const size_t& end)
 *  @see sum(const std::deque<T> &data, const size_t& start, const size_t& end)
 *
 *  @return 数据和
 */
template <typename T> T sum(const std::deque<T> &data);

/**
 *  求和。注意start和end的index和matlab保持一致从1开始计数！
 *
 *  @param data 待求数据的vector
 *  @see sum(const std::deque<T> &data)
 *  @see sum(const std::vector<T> &data, const size_t& start, const size_t& end)
 *  @see sum(const std::deque<T> &data, const size_t& start, const size_t& end)
 *
 *  @return 数据和
 */
template <typename T> T sum(const std::vector<T> &data);

/**
 *  求和。注意start和end的index和matlab保持一致从1开始计数！
 *
 *  @param data  待求数据的vector
 *  @param start 开始求和的index
 *  @param end   截止求和的index
 *  @see sum(const std::deque<T> &data)
 *  @see sum(const std::vector<T> &data)
 *  @see sum(const std::deque<T> &data, const size_t& start, const size_t& end)
 *
 *  @return 数据和
 */
template <typename T> T sum(const std::vector<T> &data, const size_t& start, const size_t& end);

/**
 *  求和。注意start和end的index和matlab保持一致从1开始计数！
 *
 *  @param data  待求数据的deque
 *  @param start 开始求和的index
 *  @param end   截止求和的index
 *  @see sum(const std::deque<T> &data)
 *  @see sum(const std::vector<T> &data)
 *  @see sum(const std::vector<T> &data, const size_t& start, const size_t& end)
 *
 *  @return 数据和
 */
template <typename T> T sum(const std::deque<T> &data, const size_t& start, const size_t& end);

/**
 *  计算数据的标准差
 *
 *  @param data 待计算数据vector
 *  @see std(const std::deque<T> &data)
 *
 *  @return 标准差
 */
template <typename T> T std(const std::vector<T> &data);

/**
 *  计算数据的标准差
 *
 *  @param data 待计算数据deque
 *  @see std(const std::vector<T> &data)
 *
 *  @return 标准差
 */
template <typename T> T std(const std::deque<T> &data);

/**
 *  将各类实数（浮点数和整数）转换为复数
 *
 *  @param data   实数
 *
 *  @return  复数
 */
template <typename T> std::vector<std::complex<T>> toComplex(const std::vector<T> &data);

/**
 * 将deque转为vector
 *
 * @tparam T    任意量
 * @param data  待转换
 *
 * @return vector容器
 */
template <typename T> std::vector<T> toVector(const std::deque<T> &data);

/**
 * 将vector转为deque
 *
 * @tparam T    任意量
 * @param data  待转换
 *
 * @return deque容器
 */
template <typename T> std::deque<T> toDeque(const std::vector<T> &data);

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
 *  复数求绝对值
 *
 *  @param data   待求数据vector
 *
 *  @return  求值结果
 */
template <typename T> std::vector<T> abs(const std::vector<std::complex<T> > &data);

/**
 *  实数求绝对值
 *
 *  @param data   待求数据vector
 *
 *  @return  求值结果
 */
template <typename T> std::vector<T> abs(const std::vector<T> &data);

/**
 *  模拟matlab内截取数组内一段数据的操作。注意！这里为了和matlab保持一致，start和end的index从1开始计数
 *
 *  @param data   原始数组vector
 *  @param start  与MATLAB一致的截取开始下标（含）
 *  @param end    与MATLAB一致的截取截取下标（含）
 *
 *  @return  截取结果vector
 */
template <typename T> std::vector<T> truncate(const std::vector<T> &data, size_t start, size_t end);

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
template <typename T> std::vector<T> truncate(const std::vector<T> &data, size_t start, typename std::vector<T>::difference_type step, size_t end);


/**
 * 模拟matlab中形如a[index] 的截取
 * @tparam T
 * @param data         原始数组vector
 * @param index        需要截取的下标
 * @param matlabIndex  下标是否从1开始计数
 * @return             截取结果vector
 */
template <typename T> std::vector<T> truncate(const std::vector<T> &data, const std::vector<size_t> &index, bool matlabIndex = true);

/**
 *  模拟matlab内截取数组内一段数据的操作。注意！这里为了和matlab保持一致，start和end的index从1开始计数
 *
 *  @param data   原始数组deque
 *  @param start  与MATLAB一致的截取开始下标（含）
 *  @param end    与MATLAB一致的截取截取下标（含）
 *
 *  @return 截取结果deque
 */
template <typename T> std::deque<T> truncate(const std::deque<T> &data, size_t start, size_t end);

/**
 *  模拟matlab内截取数组内一段数据的操作,带步进参数。注意！这里为了和matlab保持一致，start和end的index从1开始计数
 *
 *  @param data   原始数组deque
 *  @param start  与MATLAB一致的截取开始下标（含）
 *  @param step   步进
 *  @param end    与MATLAB一致的截取截取下标（含）
 *
 *  @return 截取结果deque
 */
template <typename T> std::deque<T> truncate(const std::deque<T> &data, size_t start, typename std::deque<T>::difference_type step, size_t end);

/**
 * 模拟matlab中形如a[index] 的截取
 * @tparam T
 * @param data         原始数组deque
 * @param index        需要截取的下标
 * @param matlabIndex  下标是否从1开始计数
 * @return             截取结果deque
 */
template <typename T> std::deque<T> truncate(const std::deque<T> &data, const std::deque<size_t> &index, bool matlabIndex = true);

/**
 *  模拟matlab的max函数，返回了最大值和最大值下标。注意！这里返回的index为0开始计数
 *
 *  @param data 原始数组vector
 *
 *  @return 最大值和最大值下标
 */
template <typename T> std::pair<T, size_t> maxMatlab(const std::vector<T> &data);

/**
 *  模拟matlab的min函数，返回了最小值和最小值下标。注意！这里返回的index为0开始计数
 *
 *  @param data 原始数组vector
 *
 *  @return 最小值和最小值下标
 */
template <typename T> std::pair<T, size_t> minMatlab(const std::vector<T> &data);

/**
 *  模拟matlab的min函数，返回了最小值和最小值下标。注意！这里返回的index为0开始计数
 *
 *  @param data 原始数组deque
 *  @see std::pair<T,size_t> minMatlab(const std::vector<T> &data)
 *
 *  @return 最小值和最小值下标
 */
template <typename T> std::pair<T, size_t> minMatlab(const std::deque<T> &data);

/**
 *  模拟matlab的max函数，返回了最大值和最大值下标。注意！这里返回的index为0开始计数
 *
 *  @param data 原始数组deque
 *  @see std::pair<T,size_t> maxMatlab(const std::vector<T> &data)
 *
 *  @return 最大值和最大值下标
 */
template <typename T> std::pair<T, size_t> maxMatlab(const std::deque<T> &data);

/**
 *  模拟matlab的赋值，会自动扩展数组并置零
 *
 *  @param data 原始数组vector
 *  @param index          插入位置
 *  @param element        插入元素
 *  @param defaultElement 默认填充元素
 */
template <typename T> void assign(std::vector<T> &data, size_t index, T element, T defaultElement);

/**
 *  模拟matlab的赋值，会自动扩展数组并置零
 *
 *  @param data           原始数组vector
 *  @param index          插入位置
 *  @param element        插入元素
 *  @param defaultElement 默认填充元素
 */
template <typename T> void assign(std::deque<T> &data, size_t index, T element, T defaultElement);

/**
 * 模拟matlab中形如 data(startIndex:endIndex) = elements 的赋值
 * @tparam T         任意类型
 * @param data       待赋值数组
 * @param startIndex 开始下标
 * @param endIndex   结束下标志
 * @param elements   待插入数组
 */
template <typename T> void assign(std::vector<T> &data, size_t startIndex, size_t endIndex, const std::vector<T> &elements);

/**
 * 模拟matlab中形如 data(startIndex:endIndex) = element 的赋值
 * @tparam T         任意类型
 * @param data       待赋值数组
 * @param startIndex 开始下标
 * @param endIndex   结束下标志
 * @param elements   待插入数组
 */
template <typename T> void assign(std::vector<T> &data, size_t startIndex, size_t endIndex, const T &element);

/**
 *  求复数的共轭
 *
 *  @param data   输入
 *
 *  @return 返回结果result
 */
template <typename T> std::vector<std::complex<T> > conj(const std::vector<std::complex<T> > &data);

/**
 *  计算数据平方和
 *
 *  @param data 待计算的数据
 *
 *  @return 平方和
 */
template <typename T> T colMultiplication(const std::vector<T> &data);

/**
 *  对一个deque队列进行emplace_back操作，并移除队列头部元素
 *
 *  @param deque     需要操作的队列
 *  @param data      需要压入队列末尾
 */
template <typename T> void dequePushBack(std::deque<T> &deque,T data);

/**
 *  对一个deque队列进行emplace_back操作，并将队列的大小限制在sizeLimit
 *
 *  @param deque     需要操作的队列
 *  @param data      需要压入队列末尾
 *  @param sizeLimit 队列大小限制
 *
 *  @return 是否进行了popfront操作
 */
template <typename T> bool dequePushBack(std::deque<T> &deque,T data,size_t sizeLimit);

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
 *  模拟matlab中形如a[start:end] = val的赋值，注意这里的下标默认从1开始计算
 *
 *  @param data  待处理的数组
 *  @param start 开始下标
 *  @param end   结束下标
 *  @param val   需要的赋值
 *  @param matlabIndex 是否从1开始计算下标
 */
template <typename T> void set(std::vector<T> &data, size_t start, size_t end, const T &val, bool matlabIndex = true);

/**
 * 模拟matlab中形如a[index] = val的赋值，注意这里的下标从0开始计算
 * @tparam T
 * @param data        待处理的数组
 * @param index       index数组
 * @param val         需要的赋值
 * @param matlabIndex 是否从1开始计算下标
 */
template <typename T> void set(std::vector<T> &data, const std::vector<size_t> &index, const T &val, bool matlabIndex = true);

/**
 *  取复数的实数部分
 *
 *  @param data 需要操作的数据
 *
 *  @return 实数结果
 */
template <typename T> std::vector<T> real(const std::vector<std::complex<T>> &data);

/**
 *  模拟matlab中的数组相减 res=data1-data2
 *
 * @param data1  被减数
 * @param data2  减数
 *
 * @return 数组相减结果
 */
template <typename T> std::vector<T> minus(const std::vector<T> &data1, const std::vector<T> &data2);


/**
 *  模拟matlab中的数组标量相减 res=data1-data2
 *
 * @param data1  被减数数组
 * @param data2  减数标量
 *
 * @return 相减结果
 */
template <typename T> std::vector<T> minus(const std::vector<T> &data1, const T &data2);

/**
 *  模拟matlab中的数组相加 res=data1+data2
 *
 * @param data1  被加数
 * @param data2  加数
 *
 * @return 相加结果
 */
template <typename T> std::vector<T> add(const std::vector<T> &data1, const std::vector<T> &data2);

/**
 *  模拟matlab中的数组标量相加 res=data1+data2
 *
 * @param data1  被加数数组
 * @param data2  加数标量
 *
 * @return 相加结果
 */
template <typename T> std::vector<T> add(const std::vector<T> &data1, const T &data2);

/**
 * 模拟matlab中的点乘 res = data1.*data2
 * @tparam T 任意支持乘法的量
 * @param data1 data1
 * @param data2 data2
 * @return 点乘结果
 */
template <typename T> std::vector<T> dotMultiply(const std::vector<T> &data1, const std::vector<T> &data2);

/**
 * 模拟matlab中的点乘 res = data.*data
 * @tparam T    任意支持乘法的量
 * @param data  待处理 data
 * @return 点乘结果
 */
template <typename T> std::vector<T> dotMultiply(const std::vector<T> &data);

/**
 * 模拟matlab中的点除 res = data1 ./ data2
 * @tparam T    任意支持除法法的量
 * @tparam F    一般应该为实数类型
 * @param data1 被除向量
 * @param data2 除数
 * @return 点除结果
 */
template <typename T, typename F> std::vector<T> dotDivide(const std::vector<T> &data1, const F &data2);

/**
 * 模拟matlab中的点乘 res = data1.*data2, 这里指定了各格式
 * @tparam T    返回格式
 * @tparam F    data1 格式
 * @tparam G    data2 格式
 * @param data1 data1
 * @param data2 data2
 * @return 点乘结果
 */
template <typename T, typename F, typename G> std::vector<T> dotMultiply(const std::vector<F> &data1, const std::vector<G> &data2);

/**
 * 模拟matlab中的数组标量相乘 res=data1*data2
 * @tparam T     任意支持乘法的量
 * @param data1  数组
 * @param data2  标量
 * @return 相乘结果
 */
template <typename T> std::vector<T> multiply(const std::vector<T> &data1, const T &data2);

/**
 * 模拟matlab中的数组标量相除 res=data1/data2
 * @tparam T     任意支持乘法的量
 * @param data1  数组
 * @param data2  标量
 * @return 除法结果
 */
template <typename T> std::vector<T> divide(const std::vector<T> &data1, const T &data2);

/**
 *  模拟matlab中的diff函数，注意res的长度会比data短1
 * @tparam T 可以是任意类型
 * @param data 输入
 *
 * @return diff结果
 */
template <typename T> std::vector<T> diff(const std::vector<T> &data);

/**
 * 模拟Matlab中的any函数，判断数组中是否有非零元素
 * @tparam T  可以是整型或者浮点
 * @param data 输入
 * @return 是否有非零元素
 */
template <typename T> bool any(const std::vector<T> &data);

/**
 * 将int类型转换为枚举类型
 *
 * @tparam T 枚举类型
 * @param intData  待转换vector<int>
 *
 * @return 结果
 */
template <typename T> std::vector<T> intToEnum(const std::vector<int> &intData);

/**
 * 将枚举类型转换为int类型
 *
 * @tparam T 枚举类型
 * @param enumData  待转换vector<Enum>
 *
 * @return 结果
 */
template <typename T> std::vector<int> enumToInt(const std::vector<T> &enumData);

/**
 * 从小到大排序
 * @tparam T    需要支持大小比较
 * @param data  待排序 vector
 * @return 排序结果
 */
template <typename T> std::vector<T> sort(const std::vector<T> &data);

/**
 * 从小到大排序
 * @tparam T    需要支持大小比较
 * @param data  待排序 deque
 * @return 排序结果
 */
template <typename T> std::deque<T> sort(const std::deque<T> &data);

/**
 * 从小到大排序
 * @tparam T   需要支持大小比较
 * @param data 待排序 vector
 * @return 排序结果，排序index
 */
template <typename T> std::pair<std::vector<T>, std::vector<size_t>> sortMatlab(const std::vector<T> &data, bool matlabIndex = true);

/**
 * 从小到大排序
 * @tparam T   需要支持大小比较
 * @param data 待排序 deque
 * @return 排序结果，排序index
 */
template <typename T> std::pair<std::vector<T>, std::vector<size_t>> sortMatlab(const std::deque<T> &data, bool matlabIndex = true);

/**
 * 从 vector<vector<DATA>> 表示的二维数组中抽取列向量
 * @tparam T          任意类型
 * @param data        带抽取的二维数组
 * @param colIndex    需要抽取的列
 * @param matlabIndex 是否采用 matlab 下标
 * @return 抽取结果
 */
template <typename T> std::vector<T> extract(const std::vector<std::vector<T>> &data, size_t colIndex, bool matlabIndex = false);

/**
 * 判断一个数组内是否包含某元素
 * @tparam T     任意可以用 == 比较相等的类型
 * @param member 判断元素
 * @param data   数组
 * @return       是否包含
 */
template <typename T> bool ismember(const T &member, const std::vector<T> &data);

/**
 * 判断两个数组是否相等
 * @tparam T     任意可以用 == 比较相等的类型
 * @param data1  data1
 * @param data2  data2
 * @return       是否相等
 */
template <typename T> bool isequal(const std::vector<T> &data1, const std::vector<T> &data2);

/**
 * 将 vector 内的元素进行 static_cast
 * @tparam T   目标类型
 * @tparam F   原类型
 * @param data 待转换的vector
 * @return     转换结果
 */
template <typename T, typename F> std::vector<T> cast(const std::vector<F> &data);

/**
 * 将数组内的元素进行取模运算
 *
 * @tparam T    任意整型
 * @param data  待计算数组
 * @param m     模数
 * @return      结果
 */
template <typename T> std::vector<T> mod(const std::vector<T> &data, T m);

/**
 * 获得数组内的数值范围，
 * @tparam T    任意支持比较的类型
 * @param data  待计算数组
 * @return      max(data) - min(data)
 */
template <typename T> T range(const std::vector<T> &data);

/**
 * 求转置
 * @tparam T    任意类型
 * @param data  待转置数组
 * @return      结果
 */
template <typename T> std::vector<std::vector<T>> transpose(const std::vector<std::vector<T>> &data);

/**
 * 生成vector<vector<T>> 的矩阵
 * @tparam T   矩阵内含类型
 * @param row  行数
 * @param col  列数
 * @return 矩阵
 */
template <typename T> std::vector<std::vector<T>> vectorMatrix(const size_t &row, const size_t &col, const T &val);

/**
 * 得到vector<vector<DATA>> 表示的某一列矩阵
 * @tparam T          矩阵内含类型
 * @param data        矩阵
 * @param col         列
 * @param matlabIndex 是否使用matlab下标（从1开始）
 * @return 提取的向量
 */
template <typename T> std::vector<T> getCol(const std::vector<std::vector<T>> &data, size_t col, bool matlabIndex = true);

namespace BasicInner {

/**
 *  计算比n大的最小的2的幂
 *
 *  @param n n
 *
 *  @return 最小的2的幂
 */
template <typename T> T nextPowerOf2(T n);

}
}
}

//函数定义
namespace EnterTech {
namespace MatlabToolBox {

template <typename T> T mean(const std::vector<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    long double total = *data.begin();
    for (auto it = data.cbegin() + 1; it != data.cend(); ++it)
        total += (*it);
    return static_cast<T>(total / data.size());
}

template <typename T> T mean(const std::deque<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    long double total = *data.cbegin();
    for (auto it = data.cbegin() + 1; it != data.cend(); ++it)
        total += (*it);
    return static_cast<T>(total / data.size());
}

template <typename T, typename F> F mean(const std::deque<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    F total = *data.cbegin();
    for (auto it = data.cbegin() + 1; it != data.cend(); ++it)
        total += (*it);
    return static_cast<F>(total / data.size());
};

template <typename T, typename F> F mean(const std::vector<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    F total = *data.cbegin();
    for (auto it = data.cbegin() + 1; it != data.cend(); ++it)
        total += (*it);
    return static_cast<F>(total / data.size());
};

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

template <typename T> T max(const std::deque<T> &data) {
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

template <typename T> T min(const std::deque<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T min = data[0];
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) < min)
            min = *it;
    }
    return min;
}

template <typename T> T min(const T &a, const T &b) {
    return a < b ? a : b;
}

template <typename T> T max(T a, T b) {
    return a > b ? a : b;
}

template <typename T> T max(T a, T b, T c) {
    T res = a;
    if (res < b)
        res = b;
    if (res < c)
        res = c;
    return res;
}

template <typename T> T max(T a, T b, T c, T d) {
    T res = a;
    if (res < b)
        res = b;
    if (res < c)
        res = c;
    if (res < d)
        res = d;
    return res;
}

template <typename T> T sum(const std::deque<T> &data) {
    if (data.empty())
        return 0;
    return std::accumulate(data.cbegin() + 1, data.cend(), data[0]);
}

template <typename T> T sum(const std::vector<T> &data) {
    if (data.empty())
        return 0;
    return std::accumulate(data.cbegin() + 1, data.cend(), data[0]);
}

template <typename T> T sum(const std::vector<T> &data, size_t start, size_t end) {
    if (start == end+1)
        return 0.;

    if (start <= 0)
        throw std::out_of_range("start index<=0");
    if (start > data.size())
        throw std::out_of_range("start index>data size");

    if (end <= 0)
        throw std::out_of_range("end index<=0");
    if (end > data.size())
        throw std::out_of_range("end index>data size");

    return std::accumulate(data.cbegin() + start, data.cbegin() + end - 1, data[start-1]);
}

template <typename T> T sum(const std::deque<T> &data, size_t start, size_t end) {
    if (start <= 0)
        throw std::out_of_range("start index<=0");
    if (start > data.size())
        throw std::out_of_range("start index>data size");

    if (end <= 0)
        throw std::out_of_range("end index<=0");
    if (end > data.size())
        throw std::out_of_range("end index>data size");

    return std::accumulate(data.cbegin() + start, data.cbegin() + end - 1, data[start-1]);
}

template <typename T> T std(const std::vector<T> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    if (data.size() <= 1)
        return 0.0;
    T varmean = mean(data);
    T varSum = 0.0;
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        T tmp = (*it) - varmean;
        varSum += (tmp*tmp);
    }
    return sqrt(varSum / (data.size() - 1));
}

template <typename T> T std(const std::deque<T> &data) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    if (data.size() <= 1)
        return 0.0;
    T varmean = mean(data);
    T varSum = 0.0;
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        T tmp = (*it) - varmean;
        varSum += (tmp*tmp);
    }
    return sqrt(varSum / (data.size() - 1));
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

template <typename T> std::vector<T> toVector(const std::deque<T> &data) {
    std::vector<T> res;
    res.assign(data.cbegin(), data.cend());
    return res;
}

template <typename T> std::deque<T> toDeque(const std::vector<T> &data) {
    std::deque<T> res;
    res.assign(data.cbegin(), data.cend());
    return res;
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

template <typename T> std::vector<T> truncate(const std::vector<T> &data, size_t start, size_t end) {
    std::vector<T> result;
    if (start <= 0)
        throw std::out_of_range("start index <= 0");
    if (end > data.size())
        throw std::out_of_range("end index > data size");
    if (start > end+1)
        throw std::out_of_range("end index+1 < start index");
    auto startIt = data.cbegin() + (start - 1), endIt = data.cbegin() + end;

    result.assign(startIt, endIt);
    return result;
}

template <typename T> std::vector<T> truncate(const std::vector<T> &data, size_t start, typename std::vector<T>::difference_type step, size_t end) {
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

template <typename T> std::vector<T> truncate(const std::vector<T> &data, const std::vector<size_t> &index, bool matlabIndex) {
    std::vector<T> res;
    res.reserve(index.size());
    size_t offset = matlabIndex?1:0;
    for (auto && i : index) res.emplace_back(data[i-offset]);
    return res;
}

template <typename T> std::deque<T> truncate(const std::deque<T> &data, size_t start, size_t end) {
    std::deque<T> result;
    if (start <= 0)
        throw std::out_of_range("start index<=0");
    if (end > data.size())
        throw std::out_of_range("end index>=data size");
    if (start > end)
        throw std::out_of_range("end index>start index");

    auto startIt = data.cbegin() + (start - 1), endIt = data.cbegin() + end;
    result.assign(startIt, endIt);
    return result;
}

template <typename T> std::deque<T> truncate(const std::deque<T> &data, size_t start, typename std::deque<T>::difference_type step, size_t end) {
    std::deque<T> result;
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

template <typename T> std::deque<T> truncate(const std::deque<T> &data, const std::vector<size_t> &index, bool matlabIndex) {
    std::deque<T> res;
    size_t offset = matlabIndex?1:0;
    for (auto && i : index) res.emplace_back(data[i-offset]);
    return res;
}

template <typename T> std::pair<T, size_t> maxMatlab(const std::vector<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T max = data[0];
    size_t maxIndex = 0;
    size_t tmp = 0;
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) > max) {
            max = (*it);
            maxIndex = tmp;
        }
        ++tmp;
    }
    return std::make_pair(max, maxIndex);
}

template <typename T> std::pair<T, size_t> minMatlab(const std::vector<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T min = data[0];
    size_t minIndex = 0;
    size_t tmp = 0;
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) < min) {
            min = (*it);
            minIndex = tmp;
        }
        ++tmp;
    }
    return std::make_pair(min, minIndex);
}

template <typename T> std::pair<T, size_t> maxMatlab(const std::deque<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T max = data[0];
    size_t maxIndex = 0;
    size_t tmp = 0;
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) > max) {
            max = (*it);
            maxIndex = tmp;
        }
        ++tmp;
    }
    return std::make_pair(max, maxIndex);
}

template <typename T> std::pair<T, size_t> minMatlab(const std::deque<T> &data) {
    if (data.empty())
        throw std::invalid_argument("data must be not empty.");
    T min = data[0];
    size_t minIndex = 0, tmp = 0;
    for (auto it = data.cbegin(); it != data.cend(); ++it) {
        if ((*it) < min) {
            min = (*it);
            minIndex = tmp;
        }
        ++tmp;
    }
    return std::make_pair(min, minIndex);
}

template <typename T> void assign(std::vector<T> &data, size_t index, T element, T defaultElement) {
    if (index > data.size()) {
        data.resize(index, defaultElement);
    }
    data[index - 1] = element;
}

template <typename T> void assign(std::deque<T> &data, size_t index, T element, T defaultElement) {
    if (index > data.size()) {
        data.resize(index, defaultElement);
    }
    data[index - 1] = element;
}

template <typename T> void assign(std::vector<T> &data, size_t startIndex, size_t endIndex, const std::vector<T> &elements) {
    if (startIndex == 0) throw std::invalid_argument("startIndex should not be 0");
    if (endIndex < startIndex) throw std::invalid_argument("startIndex should >= endIndex");
    if (endIndex > data.size()) throw std::out_of_range("endIndex should <= data.size()");
    auto latterPart = truncate(data, endIndex+1, data.size());
    data.resize(startIndex-1);
    data.insert(data.end(), elements.begin(), elements.end());
    data.insert(data.end(), latterPart.begin(), latterPart.end());
}

template <typename T> void assign(std::vector<T> &data, size_t startIndex, size_t endIndex, const T &element) {
    if (startIndex == 0) throw std::invalid_argument("startIndex should not be 0");
    if (endIndex < startIndex) throw std::invalid_argument("startIndex should >= endIndex");
    if (endIndex > data.size()) throw std::out_of_range("endIndex should <= data.size()");
    for (size_t index = startIndex-1; index < endIndex; index++) {
        data[index] = element;
    }
}

template <typename T> std::vector<std::complex<T>> conj(const std::vector<std::complex<T> > &data) {
    std::vector<std::complex<T>> result;
    result.reserve(data.size());
    for (auto it = data.cbegin(); it != data.cend(); ++it)
        result.emplace_back(std::complex<T>((*it).real(), -(*it).imag()));
    return result;
}

template <typename T> T colMultiplication(const std::vector<T> &data) {
    T result = 0;
    for (auto it = data.begin(); it != data.end(); ++it) {
        result += ((*it)*(*it));
    }
    return result;
}

template <typename T> void dequePushBack(std::deque<T> &deque,T data){
    deque.emplace_back(data);
    deque.pop_front();
}

template <typename T> bool dequePushBack(std::deque<T> &deque,T data,size_t sizeLimit){
    deque.emplace_back(data);
    bool popFlag = false;
    while(deque.size()>sizeLimit){
        deque.pop_front();
        popFlag = true;
    }
    return popFlag;
}

template <typename T> std::vector<size_t> find(const std::vector<T> &data, std::function<bool(T)> func){
    std::vector<size_t> res;
    for (size_t index = 0; index < data.size(); index++){
        if(func(data[index])) res.emplace_back(index);
    }
    return res;
}

template <typename T> void set(std::vector<T> &data, size_t start, size_t end, const T &val, bool matlabIndex) {
    if (!matlabIndex) {
        ++start;
        ++end;
    }
    if (start < 1)
        throw std::out_of_range("start index out of bound.");
    auto currentSize = data.size();

    for (auto index = start -1; index < (end > currentSize ? currentSize : end); index ++) {
        data[index] = val;
    }
    while (currentSize < end) {
        data.emplace_back(val);
        ++currentSize;
    }
}

template <typename T> void set(std::vector<T> &data, const std::vector<size_t> &index, const T &val, bool matlabIndex) {
    if (matlabIndex) {
        for (auto i : index) {
            if (i == 0 || i >= data.size())
                throw std::out_of_range("index out of bound.");
            data[i-1] = val;
        }
    }
    else {
        for (auto i : index) {
            if (i >= data.size())
                throw std::out_of_range("index out of bound.");
            data[i] = val;
        }
    }
}

template <typename T> std::vector<T> real(const std::vector<std::complex<T>> &data) {
    std::vector<T> res;
    res.reserve(data.size());
    for (auto it = data.cbegin(); it != data.cend(); it++)
        res.emplace_back((*it).real());
    return res;
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

template <typename T> std::vector<T> dotMultiply(const std::vector<T> &data) {
    std::vector<T> res;
    res.reserve(data.size());
    for (auto&& item : data)
        res.emplace_back(item*item);
    return res;
}

template <typename T, typename F, typename G> std::vector<T> dotMultiply(const std::vector<F> &data1, const std::vector<G> &data2) {
    std::vector<T> res;
    if (data1.size() != data2.size())
        throw std::out_of_range("data1 data2 size not equal.");
    res.reserve(data1.size());
    auto it1 = data1.cbegin();
    auto it2 = data2.cbegin();
    for(;it1 != data1.cend(); it1++, it2++) {
        res.emplace_back((*it1)*(*it2));
    }
    return res;
}

template <typename T, typename F> std::vector<T> dotDivide(const std::vector<T> &data1, const F &data2){
    std::vector<T> res;
    for (auto&& item : data1)
        res.emplace_back(item/data2);
    return res;
}

template <typename T> std::vector<T> multiply(const std::vector<T> &data1, const T &data2) {
    std::vector<T> res;
    res.reserve(data1.size());
    std::for_each(data1.cbegin(), data1.cend(), [&](const T &input){res.emplace_back(input * data2);});
    return res;
}

template <typename T> std::vector<T> divide(const std::vector<T> &data1, const T &data2) {
    std::vector<T> res;
    res.reserve(data1.size());
    std::for_each(data1.cbegin(), data1.cend(), [&](const T &input){res.emplace_back(input / data2);});
    return res;
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

template <typename T> bool any(const std::vector<T> &data) {
    for (auto &&item : data)
        if (item != 0) return true;
    return false;
}

template <typename T> std::vector<T> intToEnum(const std::vector<int> &intData) {
    static_assert(std::is_enum<T>::value, "output data must be enum type!");
    std::vector<T> res;
    for (auto& item : intData) {
        res.emplace_back(static_cast<T>(item));
    }
    return res;
}

template <typename T> std::vector<int> enumToInt(const std::vector<T> &enumData) {
    static_assert(std::is_enum<T>::value, "input data must be enum type!");
    std::vector<int> res;
    for (auto &item :enumData) {
        res.emplace_back(static_cast<int>(item));
    }
    return res;
}

template <typename T> std::vector<T> sort(const std::vector<T> &data) {
    auto res = data;
    std::sort(res.begin(), res.end());
    return res;
}

template <typename T> std::deque<T> sort(const std::deque<T> &data) {
    auto res = data;
    std::sort(res.begin(), res.end());
    return res;
}

template <typename T> std::pair<std::vector<T>, std::vector<size_t>> sortMatlab(const std::vector<T> &data, bool matlabIndex) {
    struct Pack {
        T data;
        size_t index;
    };
    size_t begin = matlabIndex ? 1 : 0;
    std::vector<Pack> res;
    res.reserve(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const T &in){res.emplace_back(Pack{in, begin++});});

    std::sort(res.begin(), res.end(),
         [&](const Pack& a, const Pack& b) {return a.data < b.data;});

    std::vector<T> resData;
    std::vector<size_t> resIndex;
    resData.reserve(data.size());
    resIndex.reserve(data.size());
    std::for_each(res.cbegin(), res.cend(), [&](const Pack& in){resData.emplace_back(in.data);resIndex.emplace_back(in.index);});
    return std::make_pair(resData, resIndex);
}

template <typename T> std::pair<std::vector<T>, std::vector<size_t>> sortMatlab(const std::deque<T> &data, bool matlabIndex) {
    struct Pack {
        T data;
        size_t index;
    };
    size_t begin = matlabIndex ? 1 : 0;
    std::vector<Pack> res(data.size());
    std::for_each(data.cbegin(), data.cend(), [&](const T &in){res.emplace_back(Pack{in, begin++});});

    std::sort(res.begin(), res.end(),
              [&](const Pack& a, const Pack& b) {return a.data < b.data;});

    std::vector<T> resData(data.size());
    std::vector<size_t> resIndex(data.size());
    std::for_each(res.cbegin(), res.cend(), [&](const Pack& in){resData.emplace_back(in.data);resIndex.emplace_back(in.index);});
    return std::make_pair(resData, resIndex);
}

template <typename T> std::vector<T> extract(const std::vector<std::vector<T>> &data, size_t colIndex, bool matlabIndex) {
    std::vector<T> res;
    res.reserve(data.size());
    if (matlabIndex && 0 == colIndex) throw std::out_of_range("index should not be 0!");
    if (matlabIndex) colIndex--;
    for (const auto & row : data)
        res.emplace_back(row[colIndex]);
    return res;
}

template <typename T> bool ismember(const T &member, const std::vector<T> &data) {
    for (auto && item : data) if (item == member) return true;
    return false;
}

template <typename T> bool isequal(const std::vector<T> &data1, const std::vector<T> &data2) {
    return data1==data2;
}

template <typename T, typename F> std::vector<T> cast(const std::vector<F> &data) {
    std::vector<T> res;
    res.reserve(data.size());
    for (auto && item : data) res.emplace_back(static_cast<T>(item));
    return res;
}

template <typename T> std::vector<T> mod(const std::vector<T> &data, T m) {
    static_assert(std::is_integral<T>::value, "input data should be integral");
    std::vector<T> res = data;
    for (auto && item : res) item %= m;
    return res;
}

template <typename T> T range(const std::vector<T> &data) {
    if (data.empty()) throw std::invalid_argument("input data should not be empty.");
    T max = data[0];
    T min = data[0];
    for (auto it = data.begin()+1; it != data.cend(); it++) {
        if (*it < min) min = *it;
        if (*it > max) max = *it;
    }
    return max-min;
}

template <typename T> std::vector<std::vector<T>> transpose(const std::vector<std::vector<T>> &data) {
    std::vector<std::vector<T>> res;
    if (data.empty()) return res;

    auto rowLength = data[0].size();
    for (auto && row : data) {
        if (row.size() != rowLength) throw std::invalid_argument("input matrix row should be same size");
    }

    res = std::vector<std::vector<T>>(data[0].size(), std::vector<T>());
    for (auto && item : res) item.reserve(data.size());
    for (auto && row : data) {
        for (size_t index = 0; index < row.size(); index++) {
            res[index].emplace_back(row[index]);
        }
    }
    return res;
}

template <typename T> std::vector<std::vector<T>> vectorMatrix(const size_t &row, const size_t &col, const T &val) {
    return std::vector<std::vector<T>>(row, std::vector<T>(col, val));
}

template <typename T> std::vector<T> getCol(const std::vector<std::vector<T>> &data, size_t col, bool matlabIndex){
    std::vector<T> res;
    if (data.empty())
        return res;
    res.reserve(data.size());
    if (!matlabIndex) col--;
    for (auto & row : data) {
        res.emplace_back(row[col]);
    }
    return res;
}

namespace BasicInner {

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

}
}
}
#endif
