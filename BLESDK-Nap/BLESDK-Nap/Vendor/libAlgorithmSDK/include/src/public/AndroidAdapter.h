//
// Created by Enter on 2018/8/7.
//

#ifndef ALGORITHMSDK_PUBLIC_ANDROIDADAPTER_H
#define ALGORITHMSDK_PUBLIC_ANDROIDADAPTER_H

#include "../sdk/nap_v3/DataManager.h"
#include "../sdk/napmusic_v3/DataManager.h"
#include "../sdk/napmusic_v3/DataDefine.h"
#include "../sdk/nap_v3/DataDefine.h"

namespace EnterTech {
namespace AlgorithmSDK {

struct NapFinishResultScalarPart {
    DATA sleepPoint;
    DATA alarmPoint;
    DATA napScore;
    DATA napClassSober;
    DATA napClassBlur;
    DATA napClassSleep;
    size_t napCurveSize;
    size_t napClassSize;
};

class AndroidAdapter {
public:
    /**
     *  获得类的单例
     *
     *  @return 单例的引用
     */
    static AndroidAdapter &getInstance() {
        static AndroidAdapter instance;
        return instance;
    }

    AndroidAdapter(AndroidAdapter const &) = delete;
    void operator=(AndroidAdapter const &) = delete;

    void initNapMusic(std::string jsonFile, NapMusicV3::LANGUAGE_MODE mode);
    void initNap(std::string jsonFile);
    void appendEEGRawData(const std::vector<RAW_DATA> &eegRawData);

    NapV3::TriggerState rawDataToNapAndNapMusicManager();
    void setTouchStatus(TOUCH_STATUS touchStatus);
    void setManualOperated(DATA manualoperated);
    NapV3::CommonResult getCommonResult();

    void napFinishAll(const std::vector<NapV3::SOUND_CONTROL> &soundControl,
                      const std::vector<NapV3::SLEEP_STATE> &sleepState,
                      const std::vector<DATA> &mlpDegree,
                      const std::vector<DATA_QUALITY> &dataQuality);

    NapFinishResultScalarPart getNapFinishResultScalarPart();
    std::vector<DATA> getNapFinishNapCurve(size_t start, size_t size);
    std::vector<NapV3::NAP_CLASS> getNapFinishNapClass(size_t start, size_t size);


    void appendAudioData(const std::vector<AUDIO_DATA> &micRawData);
    void clearAudioData();

private:
    AndroidAdapter() = default;
    bool napMusicSwitch_ = false;
    std::vector<RAW_DATA> eegData_;
    std::vector<AUDIO_DATA> audioData_;
    NapV3::FinishResult napFinishResult_;

};
}
}


#endif //ALGORITHMSDK_ANDROIDADAPTER_H
