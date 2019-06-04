//
// Created by 雷京颢 on 2018/6/7.
//

#ifndef ENTEREEG_DEFINE_DATA_H
#define ENTEREEG_DEFINE_DATA_H

namespace EnterTech {

typedef double DATA;      //默认浮点精度为 double
typedef double RAW_DATA;  //原始脑波在内部为 double 类型
typedef float AUDIO_DATA; //音频在内部为 float 类型

/**
 * 设备版本
 */
enum DEVICE{UNKNOWN, V3, NONE};

/**
 * 来自硬件的电极接触信号
 */
enum TOUCH_STATUS{BAD = 0, GOOD = 1};

/**
 * 分析得到的信号质量
 */
enum DATA_QUALITY{INVALID = 0, POOR = 1, VALID = 2};

}

#endif //ENTEREEG_DEFINE_DATA_H
