//
// Created by 雷京颢 on 2018/5/30.
//

#ifndef ALGORITHMSDK_SDK_NAP_V3_DATADEFINE_H
#define ALGORITHMSDK_SDK_NAP_V3_DATADEFINE_H


#include "../../../libs/MatlabToolBox/MatlabToolBox/MatlabToolBox.h"
#include "../../../libs/EnterEEG/EnterEEG/EnterEEG/EnterEEG.h"

//定义了各种数据类型
namespace EnterTech {
namespace AlgorithmSDK {
namespace NapV3 {

const std::string NAP_V3_VERSION = "4.0.5";

enum class SOUND_CONTROL{NORMAL = 0, DECREASE = 1, STOP = 2, ALARM = 3};
enum class SLEEP_STATE{AWAKE = 1, UNCERTAIN = 0, SLEEP = -1};
enum class NAP_PHASE{INIT = 0, SOBER = 1, BLUR = 2, SLEEP = 3, ALARM = 4};
enum class NAP_CLASS{SOBER = 0, BLUR = 1, SLEEP = 2};
enum class WEAR_STATUS{BAD_WEAR = 0, POOR_WEAR = 1, GOOD_WEAR = 2};

const unsigned COMMON_TRIGGER_LEN   = 250*10;
const unsigned COMMON_TRIGGER_SHIFT = 250*8;
const unsigned MUSIC_TRIGGER_LEN    = 250*2;

//每次trigger后的分析后数据
struct CommonResult{
    DATA mlpDegree = 0.;
    DATA napDegree = 0.;
    SLEEP_STATE sleepState = SLEEP_STATE::UNCERTAIN;
    DATA_QUALITY dataQuality = DATA_QUALITY::INVALID;
    SOUND_CONTROL soundControl = SOUND_CONTROL::NORMAL;
    std::vector<DATA> smoothRawData;
};

//最终审判得到的数据
struct FinishResult{
    DATA sleepPoint;
    DATA alarmPoint;
    DATA napScore;
    DATA napClassSober;
    DATA napClassBlur;
    DATA napClassSleep;
    DATA soberDuration;
    DATA blurDuration;
    DATA sleepDuration;
    DATA sleepLatency;
    std::vector<DATA> napCurve;
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
