//
// Created by 雷京颢 on 2018/5/31.
//

#ifndef ALGORITHMSDK_SDK_NAPMUSIC_V3_NAPMUSICHANDLER_H
#define ALGORITHMSDK_SDK_NAPMUSIC_V3_NAPMUSICHANDLER_H

#include "command/command.h"
#include "DataDefine.h"
#include "AlgorithmBox.h"
#include "EnterEEG.h"

namespace EnterTech {
namespace AlgorithmSDK{
namespace NapMusicV3{

class NapMusicHandler {
    friend class DataManager;

    std::vector<CommandPack> getCommandPack() const;
    void setTouchStatus(TOUCH_STATUS status);
    void init(LANGUAGE_MODE);
    void trigger(NapMusicInput input);
    NapMusicAnalyzedDataPack getAnalyzedDataPack() const;

    //内部数据
    std::vector<CommandPack> commandPacks_;
    NapMusicAnalyzedDataPack currentResult_;
    TOUCH_STATUS touchStatus_ = TOUCH_STATUS::BAD;
    size_t totalDataCount_ = 0;

    struct MusicData {
        LANGUAGE_MODE languageMode = LANGUAGE_MODE::UNKNOWN;
        unsigned initialStatus = 1;
        unsigned firstBarCount = 1;
        std::vector<DATA> preRhythm = std::vector<DATA>(1, 0.0);
        DATA phraseTimeFlag = 0.;
        DATA barTimeFlag = 0.;
        DATA sleepCurveSum = 0.;
        DATA eegComplexitySum = 0.;
        DATA sleepCurveCount = 0.;
        unsigned eegComplexityCount = 0;
        unsigned phraseStartPoint = 0;
        unsigned barStartPoint = 0;
        unsigned chordStartPoint = 0;
        int preChord = 0;
        unsigned barNum = 1;
        DATA realTime = 0.;
        bool wearCheckFlag = true;     //佩戴验证标志
        bool leadWordsPlayFlag = true; //引导语播放标志
        int  leadWordsStatus = 0;  //引导语播放状态
        int leadWordsFileNum = 0;     //引导语文件序号
        int leadWordsRemindCount = 1;  //引导语提示次数
        DATA leadWordsStartPoint = 0; //导语播放时间节点
        bool stopCheckFlag = true;
        bool musicStopFlag = false;    //音乐停止标志
        bool musicPlayFlag = false;    //音乐播放标志
        DATA volumeFactor = 1.;
        DATA awakenVolumeFactor = 0.;

        std::vector<int> chordList;
        std::vector<std::vector<DATA>> rhythmMat;

        std::vector<std::vector<DATA>> figureListPiano;
        std::vector<std::vector<DATA>> figureListStrings;
        std::vector<int> curMelodyPiano;
        std::vector<int> curMelodyStrings;
        bool isFirstBar = false;

        DATA lastSleepStatusMove = 0.;

    }musicData_;

    //内部算法类
    AlgorithmBox algorithmBox_;
};

}
}
}



#endif //ALGORITHMSDK_SDK_NAPMUSIC_V3_NAPMUSICHANDLER_H
