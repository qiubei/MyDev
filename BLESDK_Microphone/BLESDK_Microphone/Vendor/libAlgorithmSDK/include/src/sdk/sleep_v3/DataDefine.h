//
// Created by 雷京颢 on 2018/6/4.
//

#ifndef ALGORITHMSDK_SDK_SLEEP_V3_DATADEFINE_H
#define ALGORITHMSDK_SDK_SLEEP_V3_DATADEFINE_H

#include "MatlabToolBox.h"
#include "EnterEEG.h"

//定义了各种数据类型
namespace EnterTech {
namespace AlgorithmSDK {
namespace SleepV3 {

const std::string SLEEP_VERSION = "1.0.8";

const double FS_AUDIO = 11025;    //音频采样率
const unsigned NFFT_AUDIO = 1024; //音频FFT点数
const unsigned AUDIO_SEG_LEN = 60;//音频分段输入长度，单位秒
const unsigned AUDIO_TRIGGER_LEN = AUDIO_SEG_LEN * FS_AUDIO;//trigger length
const double FRAME = 0.1;         //每一帧时长
const unsigned FRAME_LEN = floor(FRAME*FS_AUDIO); //每一帧对应的采样点数
const double DATA_REMAIN_LEN = 4*FS_AUDIO;        //每次触发后内部留存的音频长度
const double AUDIO_AMP_BASE = 32767;              //音频振幅基底（用于计算分贝数）

enum class SOUND_CONTROL_RAW{NORMAL = 0, DECREASE = 1, STOP = 2, ALARM = 3};
enum class SLEEP_STATE{AWAKE = 1, UNCERTAIN = 0, SLEEP = -1};
enum class NAP_CLASS{SOBER = 0, BLUR = 1, SLEEP = 2};
enum class WEAR_QUALITY{INVALID = 0, POOR_WEAR = 1, MEDIUM_WEAR = 2, GOOD_WEAR = 3};
enum SLEEP_STATUS {UNKNOWN = 0, DEEP_SLEEP = 1, MIDDLE_SLEEP = 2,  LIGHT_SLEEP = 3, SHALLOW_SLEEP = 4, SOBER_AWAKE = 5};
enum EVENT_CLASS{INIT = 0, SNORE = 1, DAYDREAM = 2, MOVEMENT = 3, ENVIRONMENT = 4};
enum SNORE_CLASS{NONE = 0, LIGHT = 1, HEAVY = 2};
enum DETECT_QUALITY{INVALID = 0, STATIC = 1, DROWN = 2, NORMAL = 3};        //监测质量
enum class SOUND_CONTROL{NORMAL = 0, READY = 1, STOP = 2};

struct ClassifierStump {
    std::vector<size_t> feat;
    std::vector<DATA> thr;
    std::vector<DATA> ineq;
    std::vector<DATA> alpha;
};
//
std::vector<ClassifierStump> getSnoreClassifierStump();
std::vector<ClassifierStump> getVoiceClassifierStump();
const std::vector<ClassifierStump> snoreClassifierStump = getSnoreClassifierStump();
const std::vector<ClassifierStump> voiceClassifierStump = getVoiceClassifierStump();

//每次trigger后的分析后数据
struct MicResult{
    int noiseLv = 0.;                      //底噪水平
    int snoreFlag = false;                 //鼾声标志
    int daydreamFlag = false;              //梦话标志
    int alarm = false;                     //智能闹钟触发
    DATA movementEn = 0.0;                  //动作能量
    DATA movementFreq = 0.0;                //动作频次
    std::vector<AUDIO_DATA> snoreRecData;   //鼾声录音数据
    std::vector<AUDIO_DATA> daydreamRecData;//梦话录音数据
    SleepV3::SOUND_CONTROL soundControl = SOUND_CONTROL::NORMAL;
};

struct FinishDataPack{
    int score = 0;
    int soberLen = 0;
    int lightSleepLen = 0;
    int deepSleepLen = 0;
    int latencyLen = 0;
    int sleepLen = 0;
};


struct FinishDataPackPlus {
    FinishDataPack  finishDataPack;
    int sleepPoint;
    int alarmPoint;
    DETECT_QUALITY detectQuality ;
    std::vector<int> sleepCurveCom;
    std::vector<int> timestampCom;
};

//Nap最终审判得到的数据
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

struct ClockSet {
    bool alarmPeriodFlag = false; //闹钟参数设置：是否在闹钟范围内
    double alarmPeriodLen = 30;   // 闹钟参数设置：闹钟范围长度（单位：分钟）
};

}
}
}

#endif //ALGORITHMSDK_SDK_SLEEP_V3_DATADEFINE_H
