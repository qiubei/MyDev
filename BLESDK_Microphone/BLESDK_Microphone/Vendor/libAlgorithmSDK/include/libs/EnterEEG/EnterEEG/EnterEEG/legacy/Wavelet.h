//
//  Wavelet.h
//  MatlabToolBox
//
//  Created by leijinghao on 16/8/9.
//  Copyright © 2016年 EnterTech. All rights reserved.
//
//  该文件提供了小波相关函数
//


#ifndef ENTEREEG_LIBS_WAVELET_H
#define ENTEREEG_LIBS_WAVELET_H

#define UNUSED(x) (void)(x)

#include <vector>
#include <deque>

#include "Basic.h"


//函数声明
namespace EnterTech{
namespace EnterEEG{

/**
 *  有关小波的算法均参考matlab实现重构,参考wavedec.m
 *
 *  @param x         输入一维信号
 *  @param wname     小波名
 *  @param level     层数
 *
 *  @return 结果vector<vector<T>> = {cA3, cD3, cD2, cD1}
 *
 *  @see wfilters(const std::string &wname,const std::string &o)
 */
template <typename T> std::vector<std::vector<T>> wavedec(const std::vector<T> &x, const std::string &wname, size_t level);

/**
 *  有关小波的算法均参考matlab实现重构,参考waverec.m
 *
 *  @param c     c
 *  @param wname wname
 *
 *  @return     返回结果
 */
template <typename T> std::vector<T> waverec(const std::vector<std::vector<T>> &c, const std::string &wname);

/**
 *  有关小波的算法均参考matlab实现重构,参考wrcoef.m
 *
 *  @param o     o
 *  @param c     c
 *  @param l     l
 *  @param wname wname
 *  @param n     n
 *
 *  @return     返回结果
 */
template <typename T> std::vector<T> wrcoef(const std::string &o, const std::vector<T> &c, const std::vector<size_t> &l,
                                            const std::string &wname, size_t n);

namespace WaveletInner{

/**
 *  目前只支持bior3.5,并且是硬编码，采样来自于matlab.有关小波的算法均参考matlab实现重构
 *
 *  @param wname wname
 *  @param o     o
 *
 *  @return pair<Lo_D, Hi_D>
 */
template <typename T> std::pair<std::vector<T>, std::vector<T>> wfilters(const std::string &wname,const std::string &o);

/**
 *  参见matlab内appcoef.m
 *
 *  @param c    c
 *  @param l    l
 *  @param Lo_R Lo_R
 *  @param Hi_R Hi_R
 *  @param n    n
 *
 *  @return 返回结果
 */
template <typename T> std::vector<T> appcoef(const std::vector<T> &c, const std::vector<size_t> &l,
                                             const std::vector<T> &Lo_R, const std::vector<T> &Hi_R, size_t n);

/**
 *  参见matlab内appcoef.m
 *
 *  @param c     c
 *  @param l     l
 *  @param wname wname
 *  @param n     n
 *
 *  @return     返回结果
 */
template <typename T> std::vector<T> appcoef(const std::vector<T> &c, const std::vector<size_t> &l, const std::string &wname, size_t n);

/**
 *  有关小波的算法均参考matlab实现重构,参考idwt.m
 *
 *  @param a    a
 *  @param d    d
 *  @param Lo_D Lo_D
 *  @param Hi_D Hi_d
 *  @param L    L
 *
 *  @return     返回结果
 */
template <typename T> std::vector<T> idwt(const std::vector<T> &a, const std::vector<T> &d, const std::vector<T> &Lo_D,
                                          const std::vector<T> &Hi_D, size_t L);

/**
 *  参见matlab内dwt.m
 *
 *  @param x    x
 *  @param Lo_D Lo_D
 *  @param Hi_D Hi_D
 *
 *  @return pair<a,d>
 */
template <typename T> std::pair<std::vector<T>, std::vector<T>> dwt(const std::vector<T> &x, const std::vector<T> &Lo_D,
                                                                    const std::vector<T> &Hi_D);

/**
 *  参见matlab内cumsum.m
 *
 *  @param x x
 *
 *  @return 返回结果
 */
template <typename T> std::vector<T> cumsum(const std::vector<T> &x);

/**
 *  参见matlab内detcoef.m
 *
 *  @param coefs  coefs
 *  @param longs  longs
 *  @param levels levels
 *
 *  @return 返回结果
 */
template <typename T> std::vector<T> detcoef(std::vector<T> &coefs, std::vector<size_t> &longs, size_t levels);

/**
 *  参见matlab内wextend.m
 *
 *  @param type   type
 *  @param mode   mode
 *  @param x      x
 *  @param lf     lf
 *
 *  @return 返回结果
 */
template <typename T> std::vector<T> wextend(const std::string &type, const std::string &mode, const std::vector<T> &x, int lf);

/**
 *  参见matlab内wconv1.m
 *
 *  @param x     x
 *  @param f     f
 *  @param shape shape
 *  @return      返回结果
 *
 *  @see wconv1(const std::vector<T> &x,const std::vector<T> &f)
 */
template <typename T> std::vector<T> wconv1(const std::vector<T> &x,const std::vector<T> &f,const std::string &shape);

/**
 *  参见matlab内wconv1.m
 *
 *  @param x x
 *  @param f f
 *
 *  @return 返回结果
 *
 *  @see wconv1(const std::vector<T> &x,const std::vector<T> &f,const std::string &shape)
 */
template <typename T> std::vector<T> wconv1(const std::vector<T> &x,const std::vector<T> &f);

/**
 *  matlab取余
 *
 *  @param x x
 *  @param y y
 *
 *  @return 结果
 */
template <typename T> T rem(T x,T y);

/**
 *  参见matlab内conv2.m
 *
 *  @param x     x
 *  @param f     f
 *  @param shape shape
 *
 *  @return     返回结果y
 */
template <typename T> std::vector<T> conv2(const std::vector<T> &x,const std::vector<T> &f,const std::string &shape);

/**
 *  参见matlab内dyadup.m
 *
 *  @param x          x
 *  @param varargin_1 varargin_1
 *  @param y          返回结果y
 */
template <typename T> std::vector<T> dyadup(const std::vector<T> &x, size_t varargin_1,
                                            std::vector<T> &y);

/**
 *  参见matlab内upsconv1.m
 *
 *  @param x       x
 *  @param f       f
 *  @param s       s
 *  @param dwtARG1 dwtARG1
 *
 *  @return        返回结果
 */
template <typename T> std::vector<T> upsconv1(const std::vector<T> &x,const std::vector<T> &f, size_t s,
                                              const std::string &dwtARG1);


/**
 *  参见matlab内upsconv1.m
 *
 *  @param x       x
 *  @param f       f
 *  @param s       s
 *  @param dwtARG1 dwtARG1
 *  @param dwtARG2 dwtARG2
 *
 *  @return       返回结果
 */
template <typename T> std::vector<T> upsconv1(const std::vector<T> &x,const std::vector<T> &f, size_t s,
                                              const std::string &dwtARG1, size_t dwtARG2);

/**
 *  参见matlab内wkeep1.m
 *
 *  @param x          x
 *  @param len        len
 *  @param varargin_1 varargin_1
 *  @param varargin_2 varargin_2
 *
 *  @return          返回结果
 */
template <typename T> std::vector<T> wkeep1(const std::vector<T> &x, size_t len, const std::string &varargin_1,
                                            size_t varargin_2);

}
}
}

//函数定义
namespace EnterTech{
namespace EnterEEG{

template <typename T> std::vector<T> waverec(const std::vector<std::vector<T>> &cc,
                                             const std::string &wname){
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    std::vector<T> c;
    std::vector<size_t> l;
    for (const auto &item : cc) {
        c.insert(c.end(), item.cbegin(), item.cend());
        l.emplace_back(item.size());
    }
    if ("bior3.5" != wname)
        throw std::invalid_argument("waverec only support bior3.5");

    auto lastSize = (cc.cend()-1)->size();
    l.emplace_back(lastSize*2-12+2);

    return WaveletInner::appcoef(c,l,wname,0);
}

template <typename T> std::vector<std::vector<T>> wavedec(const std::vector<T> &x,
                                                          const std::string &wname, size_t n){
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    std::vector<std::vector<T>> res;

    auto tmp = WaveletInner::wfilters<T>(wname, "d");
    const auto &Lo_D = tmp.first;
    const auto &Hi_D = tmp.second;
    auto s=x.size();

    std::vector<T> cc;
    std::vector<size_t> l;

    l.assign(n+2,0);
    if(x.empty())
        return res;

    l[n+1]=s;

    std::deque<T> c;
    std::vector<T> xx = x;
    for(size_t k=1;k<=n;++k){
        auto pairTmp = WaveletInner::dwt(xx, Lo_D, Hi_D);//decomposition
        xx = pairTmp.first;
        auto &d = pairTmp.second;
        c.insert(c.begin(), d.begin(), d.end());//store detail
        l[n+1-k]=d.size();//store length
    }

    //Last approximation
    c.insert(c.begin(), xx.begin(), xx.end());
    cc.assign(c.begin(), c.end());
    l[0] = xx.size();

    //为了兼容pywavelet，组织方式为 cA3,cD3,cD2,cD1
    size_t startIndex = 0;
    for (size_t i=0; i < l.size()-1; i++) {
        std::vector<T> tmp;
        tmp.assign(cc.begin()+startIndex, cc.begin()+startIndex+l[i]);
        res.emplace_back(tmp);
        startIndex += l[i];
    }

    return res;
}

template <typename T> std::vector<T> wrcoef(const std::string &o,const std::vector<T> &c,const std::vector<size_t> &l,const std::string &wname, size_t n){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if (o != "a" || wname != "bior3.5")
        throw std::invalid_argument(R"(wrcoef only support o="a" wname="bior3.5".)");

    //Check arguments
    auto rmax=l.size();
    auto nmax=rmax-2;
    auto nmin=0;

    if (static_cast<int>(n)<nmin |n>nmax)
        throw std::invalid_argument("Wavelet:FunctionArgVal:Invalid_ArgVal");

    auto tmp = WaveletInner::wfilters<T>(wname, "r");
    const auto &Lo_R = tmp.first;
    const auto &Hi_R = tmp.second;
    auto x = WaveletInner::appcoef<T>(c, l, Lo_R, Hi_R, n);
    if(0==n)
        return x;
    const std::vector<T> &F1=Lo_R;
    auto imin=rmax-n;
    auto swapTmp = WaveletInner::upsconv1(x, F1, l[imin], "");
    x.swap(swapTmp);
    for(size_t k=2;k<=n;++k){
        auto swapTmp = WaveletInner::upsconv1(x, Lo_R, l[imin+k-1], "");
        x.swap(swapTmp);
    }
    return x;
}

namespace WaveletInner{

template <typename T> std::pair<std::vector<T>, std::vector<T>> wfilters(const std::string &wname, const std::string &o) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if (wname =="bior3.5" && o == "d") {
        std::vector<T> Lo_D = { -0.013810679320050,
                                0.041432037960149,
                                0.052480581416189,
                                -0.267927178808965,
                                -0.071815532464259,
                                0.966747552403483,
                                0.966747552403483,
                                -0.071815532464259,
                                -0.267927178808965,
                                0.052480581416189,
                                0.041432037960149,
                                -0.013810679320050 };
        std::vector<T> Hi_D = {  0.0,
                                 0.0,
                                 0.0,
                                 0.0,
                                 -0.176776695296637,
                                 0.530330085889911,
                                 -0.530330085889911,
                                 0.176776695296637,
                                 0.0,
                                 0.0,
                                 0.0,
                                 0.0 };
        return std::make_pair(Lo_D, Hi_D);
    }
    if (wname == "bior3.5" && o == "r") {
        std::vector<T> Lo_D = { 0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.176776695296637,
                                0.530330085889911,
                                0.530330085889911,
                                0.176776695296637,
                                0.0,
                                0.0,
                                0.0,
                                0.0 };

        std::vector<T> Hi_D = { -0.013810679320050,
                                -0.041432037960149,
                                0.052480581416189,
                                0.267927178808965,
                                -0.071815532464259,
                                -0.966747552403483,
                                0.966747552403483,
                                0.071815532464259,
                                -0.267927178808965,
                                -0.052480581416189,
                                0.041432037960149,
                                0.013810679320050 };
        return std::make_pair(Lo_D, Hi_D);
    }
    throw std::invalid_argument("wfilters only support bior3.5");
}

template <typename T> std::vector<T> appcoef(const std::vector<T> &c, const std::vector<size_t> &l, const std::vector<T> &Lo_R, const std::vector<T> &Hi_R, size_t n) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    UNUSED(Hi_R);
    UNUSED(Lo_R);
    UNUSED(n);

    std::vector<T> a;
    //Check  arguments
    //        auto rmax=l.size();
    //        auto nmax=rmax-2;

    //Initialization
    a.reserve(l[0]);
    for (size_t i = 1; i <= l[0]; ++i)
        a.emplace_back(c[i - 1]);

    //Iterated reconstruction
    //Not need yet
    return a;
}

template <typename T> std::vector<T> cumsum(const std::vector<T> &x) {
    std::vector<T> y;
    if (!x.empty()) {
        T tmp = *x.begin();
        for (auto it = x.begin() + 1; it != x.end(); it++) {
            y.emplace_back(tmp);
            tmp += (*it);
        }
        y.emplace_back(tmp);
    }
    return y;
}

template <typename T> std::vector<T> detcoef(const std::vector<T> &coefs, const std::vector<size_t> &longs, size_t levels) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    //auto nmax = longs.size()-2;
    //bool cellFLAG = false;
    typename std::vector<size_t> last;

    auto tmp = cumsum(longs);
    for (auto&& item : tmp)
        ++item;
    auto first = truncateMatlab(tmp, tmp.size() - 2, -1, 1);

    auto longsM = truncateMatlab(longs, longs.size() - 1, -1, 2);

    last.reserve(first.size());
    for (auto itFirst = first.cbegin(), itLongs = longsM.cbegin(); itFirst != first.cend(); itFirst++, itLongs++) {
        last.emplace_back(*itFirst + *itLongs - 1);
    }

    auto k = levels;
    return truncate(coefs, first[k - 1]-1, last[k - 1]);
}


template <typename T> std::vector<T> appcoef(const std::vector<T> &c, const std::vector<size_t> &l, const std::string &wname, size_t n) {
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    UNUSED(wname);

    auto rmax = l.size();
    auto nmax = rmax - 2;

    auto tmp = wfilters<T>("bior3.5", "r");
    auto &Lo_R = tmp.first;
    auto &Hi_R = tmp.second;

    //Initialization
    std::vector<T> a;
    for (size_t i = 1; i <= l[0]; ++i)
        a.emplace_back(c[i - 1]);

    auto imax = rmax + 1;
    for (size_t p = nmax; p >= n + 1; p--) {
        auto d = detcoef(c, l, p);
        auto aTmp = idwt(a, d, Lo_R, Hi_R, l[imax - p - 1]);
        a.swap(aTmp);
    }
    return a;
}

template <typename T> std::pair<std::vector<T>, std::vector<T>> dwt(const std::vector<T> &x,const std::vector<T> &Lo_D,const std::vector<T> &Hi_D){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    auto shift=0;
    std::vector<T> a, d;

    //compute sizes and shape
    auto lf=Lo_D.size();
    //        auto lx=x.size();

    //Extend, Decompose & Extract coefficients.
    auto first=2-shift;
    auto lenEXT=lf-1;//auto last=lx+lf-1;

    auto y = wextend("1D", "sym", x, static_cast<int>(lenEXT));

    //Compute coefficients of approximation
    auto z = wconv1(y, Lo_D, "valid");
    auto it = z.begin()+first-1;
    while(it != z.end()){
        a.emplace_back((*it));
        ++it;
        if(it == z.end())
            break;
        ++it;
    }

    //compute coefficients of detail
    z = wconv1(y, Hi_D, "valid");
    it = z.begin() + first - 1;
    while(it != z.end()){
        d.emplace_back((*it));
        ++it;
        if(it == z.end())
            break;
        ++it;
    }

    return std::make_pair(a, d);
}

template <typename T> std::vector<T> idwt(const std::vector<T> &a, const std::vector<T> &d, const std::vector<T> &Lo_R,
                                          const std::vector<T> &Hi_R, size_t L){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<T> x;
    std::string dwtEXTM = "sym";
    size_t shift = 0;
    size_t lx=L;
    auto tmp1 = upsconv1(a, Lo_R, lx, dwtEXTM, shift);
    auto tmp2 = upsconv1(d, Hi_R, lx, dwtEXTM, shift);
    x.reserve(tmp1.size());
    for(auto it1 = tmp1.cbegin(), it2 = tmp2.cbegin();it1!=tmp1.cend();it1++,it2++){
        x.emplace_back(*it1 + *it2);
    }

    return x;
}

template <typename T> std::vector<T> wextend(const std::string &type, const std::string &mode,
                                             const std::vector<T> &x, int lf){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<T> result;
    if((type=="1D" || type=="1d") && mode == "sym"){

        //展开后的getSymIndices方法
        auto sx = static_cast<int>(x.size());
        auto &lx = sx;
        std::vector<int> I;
        for(int i=lf;i>=1;--i) I.emplace_back(i);
        for(int i=1;i<=lx;++i) I.emplace_back(i);
        for(int i=lx;i>= lx-lf+1;--i) I.emplace_back(i);

        if (lx < lf) {
            for (auto&& item : I)
                if (item < 1) item = 1 - item;
            auto J = findMatlab<int>(I, [&](int input){ return input > lx;});
            while(anyMatlab(J)) {
                for (auto index : J)
                    I[index] = 2*lx+1-I[index];

                for (auto&& item : I)
                    if (item < 1) item = 1 - item;

                J = findMatlab<int>(I, [&](int input){ return input > lx;});
            }
        }

        result.reserve(I.size());
        for (const auto& item : I)
            result.emplace_back(x[item-1]);
        return result;
    }
    throw std::invalid_argument("wextend only support 1D sym");
}


template <typename T> std::vector<T> wconv1(const std::vector<T> &x,const std::vector<T> &f,const std::string &shape){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    if(shape == "valid" || shape == "full"){
        return conv2(x, f, shape);
    }
    throw std::invalid_argument("wconv1 only support valid or full");
}

template <typename T> std::vector<T> wconv1(const std::vector<T> &x,const std::vector<T> &f){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    return wconv1(x, f, "full");
}

template <typename T> T rem(T x,T y){
    return x-(static_cast<int>(x/y))*y;
}

template <typename T> std::vector<T> conv2(const std::vector<T> &x,const std::vector<T> &f,const std::string &shape){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<T> y;
    if(shape == "valid"){
        if(x.size()>=f.size()){
            for(size_t i=0;i<=x.size()-f.size();++i){
                T sum=0.;
                auto xIt=x.begin()+i, fIt=f.end()-1;
                while(fIt!=f.begin()){
                    sum+=(*xIt)*(*fIt);
                    ++xIt;
                    --fIt;
                }
                sum += (*xIt)*(*fIt);
                y.emplace_back(sum);
            }
            return y;
        }else
            throw std::out_of_range("x's size should >= f's size");
    }

    if(shape == "full"){
        for(long int n2 = 0;n2 < static_cast<long int>(x.size() + f.size())-1;++n2){
            T sum=0.;
            for(int k2 = 0;n2 - k2 >= 0;++k2){
                if(k2 >= static_cast<long int>(x.size()))
                    break;
                if(n2-k2 >= static_cast<long int>(f.size()))
                    continue;
                sum += (x[k2]*f[n2-k2]);
            }
            y.emplace_back(sum);
        }
        return y;
    }
    throw std::invalid_argument("conv2 only support valid or full shape");
}

template <typename T> std::vector<T> dyadup(const std::vector<T> &x, size_t varargin_1){
    static_assert(std::is_floating_point<T>::value, "T must float type!");

    std::vector<T> y;
    if(x.empty())
        return y;

    //        auto def_evenodd = 1;
    auto nbInVar=1;
    //        auto r=1;
    //        auto c=x.size();
    auto evenLEN=0;

    auto p=varargin_1;
    if(2 == nbInVar)
        evenLEN = 1;
    auto rem2 = rem<size_t>(p,2);
    int addLEN;
    if(0 != evenLEN)
        addLEN = 0;
    else
        addLEN = 2 * rem2 - 1;
    auto l=2*x.size()+addLEN;
    size_t index = static_cast<size_t>(1 + rem2);
    int xIndex = 0;
    if(1 == rem2)
        y.emplace_back(0);
    while(index<l){
        y.emplace_back(x[xIndex]);
        ++xIndex;
        y.emplace_back(0);
        index+=2;
    }
    if(0==rem2)
        y.emplace_back(x[xIndex]);
    return y;
}

template <typename T> std::vector<T> upsconv1(const std::vector<T> &x, const std::vector<T> &f, size_t s,
                                              const std::string &dwtARG1){
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    UNUSED(dwtARG1);

    std::vector<T> y;
    if(x.empty()){
        y.emplace_back(0);
        return y;
    }

    //Define length
    //        auto lx=2*x.size();
    //        auto lf=f.size();
    size_t dwtSHIFT=0;

    y = wconv1(dyadup(x,0), f, "full");
    return wkeep1(y, s, "c", dwtSHIFT);
}

template <typename T> std::vector<T> upsconv1(const std::vector<T> &x, const std::vector<T> &f, size_t s,
                                              const std::string &dwtARG1, const size_t dwtARG2){
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    UNUSED(dwtARG1);

    std::vector<T> y;
    if(x.empty()){
        y.emplace_back(0);
        return y ;
    }
    auto dwtSHIFT = dwtARG2%2;

    //auto lx = 2 * x.size();
    //auto lf = f.size();

    y = wconv1(dyadup(x,0), f, "full");
    return wkeep1(y, s, "c", dwtSHIFT);
}

template <typename T> std::vector<T> wkeep1(const std::vector<T> &x, size_t len, const std::string &varargin_1,
                                            size_t varargin_2){
    static_assert(std::is_floating_point<T>::value, "T must float type!");
    UNUSED(varargin_2);

    std::vector<T> y;
    auto sx=x.size();
    if(len<0 || len>=sx)
        throw std::out_of_range("len is < 0 or len>=sx.");
    if(0!=varargin_1.compare("c" ))
        throw std::invalid_argument("varargin_1 should be \"c\"");
    //     auto side=varargin_2;
    double d=(sx-len)/2.;
    size_t first=1+(size_t)floor(d);
    size_t last=sx-(size_t)ceil(d);
    for(auto index=first-1;index<last;++index)
        y.emplace_back(x[index]);

    return y;
}

}
}
}

#endif //ENTEREEG_LIBS_WAVELET_H
