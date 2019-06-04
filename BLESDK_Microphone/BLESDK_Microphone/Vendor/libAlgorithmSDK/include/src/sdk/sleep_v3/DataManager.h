//
// Created by 雷京颢 on 2018/5/31.
//

#ifndef ALGORITHMSDK_SDK_SLEEP_V3_DATAMANAGER_H
#define ALGORITHMSDK_SDK_SLEEP_V3_DATAMANAGER_H

#include "EnterEEG.h"

#include "DataDefine.h"
#include "MicHandler.h"
//#include "../../sdk/nap_v3/DataDefine.h"

namespace EnterTech{
namespace AlgorithmSDK{
namespace SleepV3{

class DataManager {
public:
    /**
     *  获得类的单例
     *
     *  @return 单例的引用
     */
    static DataManager &getInstance() {
        static DataManager instance;
        return instance;
    }

    DataManager(DataManager const &) = delete;
    void operator=(DataManager const &) = delete;

    /**
     * Manager初始化
     */
    void init();
    void setClock(const ClockSet &clockSet);
    void setMusicFlag(const bool &musicFlag);
    bool appendMicData(AUDIO_DATA data);
    bool appendMicData(const std::vector<AUDIO_DATA> &data);
    void appendtimeStampMic(std::vector<DATA> &data, const long readLen);
    MicResult getMicResult() const;
    FinishDataPackPlus finish(const std::vector<EnterTech::AlgorithmSDK::SleepV3::SOUND_CONTROL_RAW> &soundControlRecord,
                          const std::vector<EnterTech::DATA_QUALITY> &dataQualityRecord,
                          const std::vector<EnterTech::DATA> &sleepStatusRecord,
                          const std::vector<EnterTech::DATA> &movementEnRecord,
                          const std::vector<EnterTech::DATA> &movementFreqRecord,
                          const std::vector<bool> &snoreFlagRecord,
                          const std::vector<bool> &daydreamFlagRecord,
                          const std::vector<EnterTech::DATA> &timeStampMic,
                          const std::vector<EnterTech::DATA> &timeStampEEG,
                          const std::vector<EnterTech::DATA> &noiseLevelStore
                          ) const;

    FinishResult napFinish(const std::vector<SOUND_CONTROL_RAW> &soundControl,
                                const std::vector<SLEEP_STATE> &sleepState,
                                const std::vector<DATA> &mlpDegree,
                                const std::vector<DATA_QUALITY> &dataQuality);

private:

    //单例相关
    DataManager() = default;
    ~DataManager();

    bool isInited_ = false;
    MicHandler *micHandler_ = nullptr;
};

}
}
}

#endif //ALGORITHMSDK_SDK_SLEEP_V3_DATAMANAGER_H
