//
// Created by 雷京颢 on 2018/6/5.
//

#ifndef ALGORITHMSDK_SDK_SLEEP_V3_MICHANDLER_H
#define ALGORITHMSDK_SDK_SLEEP_V3_MICHANDLER_H

#include "DataDefine.h"
#include "AlgorithmBox.h"

namespace EnterTech{
namespace AlgorithmSDK {
namespace SleepV3{

class MicHandler {
public:
    friend class DataManager;

    /**
     * 构造方法
     */
    MicHandler() = default;

private:
    /**
     * 输入麦克风数据
     * @param data 麦克风数据vector
     * @return 是否触发了算法分析
     */
    bool appendAudioData(const std::vector<AUDIO_DATA> &data);

    /**
     * 输入麦克风数据
     * @param data 麦克风数据vector
     * @return 是否触发了算法分析
     */
    bool appendAudioData(AUDIO_DATA data);

    /**
     * 设置
     * @param clockSet 闹钟设置
     */
    void setClockSet(const ClockSet &clockSet);

    /**
     * 设置音乐标志
     * @param
     */
    void setMusicFlagSet(const bool &musicFlag);


    /**
     * 初始化
     */
    void init();

    /**
     * 设置timestampmic
     */
    void getTimeStampMic(std::vector<DATA> &timeMic, long readLen);

    /**
     *  获得 TinyResult
     *  @return 分析后数据包
     */
    MicResult getMicResult() const;

    //内部数据
    std::deque<AUDIO_DATA> audioData_;

    struct MicData {
        std::vector<AUDIO_DATA> audioDataRemain; //上一留存数据
        DATA noiseSIL;                      //底噪水平
        bool snoreRecFlag;                  //鼾声录音标志（用于判断是否记录鼾声数据，滤除连续鼾声）
        unsigned snoreRecCount;             //鼾声录音计数（用于限制鼾声数据输出数量）
        std::deque<DATA> movementThrWinSeq; //滑动窗内用于判断动作事件的阈值序列
        std::deque<DATA> movementEnWinSeq;  //滑动窗内的动作能量序列
        std::deque<DATA> movementEnRec;     //动作能量记录（用于计算麦克风监测睡眠曲线）
        DATA movementEnThdsPre;             //动作能量短罫线前一值
        DATA movementEnThdlPre;             //动作能量长罫线前一值
        unsigned movementSum;               //动作次数累计值
        DATA alarmCount;                    //智能闹钟范围累计时长
        bool alarmCheckFlag;                //智能闹钟触发标志
        unsigned dataCount;                 //数据计数（用于计算动作频次）
        DATA movementEnergyMax;              //动作能量最大值（用于音量控制）
        DATA soundCountrolReadyCount;        //音量控制准备计数
    }micData_;

    MicResult micResult_;
    ClockSet clockSet_;
    size_t totalDataCount_ = 0;
    bool musicFlag_;
    //算法 Box
    AlgorithmBox algorithmBox_;

    /**
     * 判断是否需要触发算法分析，并触发之
     * @return 是否触发了算法分析
     */
    bool triggerCheck();

    /**
     * 触发算法分析
     * @param audioData      麦克风数据
     * @param clockset       闹钟设置
     * @param totalDataCount 目前处理过的数据计数
     */
    void trigger(const std::vector<AUDIO_DATA> &audioData, const ClockSet &clockSet,
            size_t totalDataCount);

    /**
    * Nap最终审判
    * @param soundControl 音量控制
    * @param sleepState   睡眠状态
    * @param mlpDegree    神经网络输出值
    * @param dataQuality  信号质量
    */
    FinishResult napFinish(const std::vector<SOUND_CONTROL_RAW> &soundControl,
                const std::vector<SLEEP_STATE> &sleepState,
                const std::vector<DATA> &mlpDegree,
                const std::vector<DATA_QUALITY> &dataQuality);

    FinishDataPackPlus finish(const std::vector<EnterTech::AlgorithmSDK::SleepV3::SOUND_CONTROL_RAW> &soundControlRecord,
                          const std::vector<EnterTech::DATA_QUALITY> &dataQualityRecord,
                          const std::vector<EnterTech::DATA> &sleepStatusRecord,
                          const std::vector<EnterTech::DATA> &movementEnRecord,
                          const std::vector<EnterTech::DATA> &movementFreqRecord,
                          const std::vector<bool> &snoreFlagRecord,
                          const std::vector<bool> &daydreamFlagRecord,
                          const std::vector<EnterTech::DATA> &timeStampMic,
                          const std::vector<EnterTech::DATA> &timeStampEEG,
                          const std::vector<EnterTech::DATA> &noiseLevelStore);
};

}
}
}



#endif //ALGORITHMSDK_SDK_SLEEP_V3_MICHANDLER_H
