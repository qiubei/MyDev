//
// Created by 雷京颢 on 2018/5/30.
//

#ifndef ALGORITHMSDK_SDK_NAP_V3_DATADEFINE_H
#define ALGORITHMSDK_SDK_NAP_V3_DATADEFINE_H


#include "MatlabToolBox.h"
#include "EnterEEG.h"

//定义了各种数据类型
namespace EnterTech {
namespace AlgorithmSDK {
namespace NapV3 {

const std::string NAP_V3_VERSION = "4.1.3";

enum class SOUND_CONTROL{NORMAL = 0, DECREASE = 1, STOP = 2, ALARM = 3};
enum class SLEEP_STATE{AWAKE = 1, UNCERTAIN = 0, SLEEP = -1};
enum class NAP_PHASE{INIT = 0, SOBER = 1, BLUR = 2, SLEEP = 3, ALARM = 4};
enum class NAP_CLASS{SOBER = 0, BLUR = 1, SLEEP = 2};
enum class WEAR_QUALITY{INVALID = 0, POOR_WEAR = 1, MEDIUM_WEAR = 2, GOOD_WEAR = 3};

const unsigned COMMON_TRIGGER_LEN   = 250*10;
const unsigned COMMON_TRIGGER_SHIFT = 250*8;
const unsigned MUSIC_TRIGGER_LEN    = 250*2;

//每次trigger后的分析后数据
struct CommonResult{
    DATA mlpDegree = 0.;                                             //神经网络预测值【输出】
    DATA napDegree = 0.;                                             //小睡程度（用于生成脑波音乐）【输出】
    SLEEP_STATE sleepState = SLEEP_STATE::UNCERTAIN;                 //睡眠状态预测【输出】
    DATA_QUALITY dataQuality = DATA_QUALITY::INVALID;                //信号质量【输出】
    SOUND_CONTROL soundControl = SOUND_CONTROL::NORMAL;              //音量控制【输出】
    std::vector<DATA> smoothRawData;                                 //预处理后的脑波【输出】
    DATA alphaEnergy = 0.;                                           //α波段能量
    DATA betaEnergy = 0.;                                            //β波段能量
    DATA thetaEnergy = 0.;                                           //θ波段能量
};

//最终审判得到的数据
struct FinishResult{
    int sleepPoint;
    int alarmPoint;
    int napScore;
    int napClassSober;
    int napClassBlur;
    int napClassSleep;
    int soberDuration;
    int blurDuration;
    int sleepDuration;
    int sleepLatency;
    WEAR_QUALITY wearQuality;
    std::vector<int> napCurve;
    std::vector<NAP_CLASS> napClass;
};

//小睡算法触发状态
struct TriggerState{
    bool commonTriggered = false;
    bool musicTriggered = false;  //是否需要触发脑波音乐算法
};

std::vector<DATA> getBandpassFilter();

const std::vector<DATA> BANDPASS_FILTER_250 = getBandpassFilter();


}
}
}



#endif //ALGORITHMSDK_DATADEFINE_H
