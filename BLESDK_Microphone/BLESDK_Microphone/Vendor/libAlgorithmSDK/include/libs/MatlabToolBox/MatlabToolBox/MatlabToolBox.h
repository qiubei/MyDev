//
//  MatlabToolBox.h
//  MatlabToolBox
//
//  Created by leijinghao on 16/8/9.
//  Copyright © 2016年 EnterTech. All rights reserved.
//
//  部分Matlab函数的C++版本，函数名与std的一些函数存在冲突，务必显示指定命名空间MatlabToolBox
//  命名规则：
//    1. Matlab内置函数使用同名函数
//    2. 用于模拟Maltab中一些语法的函数按其行为命名
//    3. 部分有一定歧义的Matlab函数，在函数名后加Matlab以示区别（max和maxMatlab等）
//

#ifndef MatlabToolBox_MatlabToolBox_MatlabToolBox_H
#define MatlabToolBox_MatlabToolBox_MatlabToolBox_H

#include <string>

#include "Basic.h"
#include "FFT.h"
#include "Wavelet.h"
#include "WindowFunction.h"
#include "Polyfun.h"
#include "Number.h"
#include "Datafun.h"

namespace EnterTech {
namespace MatlabToolBox {
    const std::string version = "0.1.5";
}
}

#endif
