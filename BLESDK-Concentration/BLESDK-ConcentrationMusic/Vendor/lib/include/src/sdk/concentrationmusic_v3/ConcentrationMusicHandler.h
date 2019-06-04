//
// Created by 雷京颢 on 2018/6/6.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRATIONMUSIC_V3_CONCENTRATIONMUSICHANDLER_H
#define ALGORITHMSDK_SDK_CONCENTRATIONMUSIC_V3_CONCENTRATIONMUSICHANDLER_H

#include "../concentration_v3/DataDefine.h"
#include "DataDefine.h"
#include "AlgorithmBox.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace ConcentrationMusicV3 {

class ConcentrationMusicHandler {
    friend class DataManager;
    std::vector<CommandPack> getCommandPack() const;
    FinishDataPack getFinishDataPack() const;
    CurrentResult getCurrentResult() const;
    bool hasNewCommands() const;
    void setTouchStatus(TOUCH_STATUS status);
    void init(LANGUAGE_MODE);
    void finish();
    void innerTrigger(DATA);
    void trigger();

    bool hasNewCommands_;
    LANGUAGE_MODE languageMode_;
    size_t totalDataCount_;
    FinishDataTmp finishDataTmp_;
    std::vector<CommandPack> commandPacks_;
    FinishDataPack finishDataPack_;
    CurrentResult currentResult_;
    TOUCH_STATUS touchStatus_ = TOUCH_STATUS::BAD;

    struct MusicData {
        unsigned initialStatus = 1;
        unsigned firstBarCount = 1;
        std::vector<DATA> preRhythm = std::vector<DATA>(1, 0.0);
        DATA phraseTimeFlag = 0.;
        DATA barTimeFlag = 0.;
        unsigned phraseStartPoint = 0;
        unsigned barStartPoint = 0;
        unsigned chordStartPoint = 0;
        int preChord = 0;
        unsigned barNum = 1;
        DATA realTime = 0.;
        bool wearCheckFlag = true; //佩戴验证标志
        int preWearStatus = 0; //上一次的佩戴状态
        bool leadWordsPlayFlag = true; //引导语播放标志
        int  leadWordsStatus = 0;  //引导语播放状态
        int leadWordsFileNum = 0;     //引导语文件序号
        int leadWordsWaiteCount = 0; // 引导语等待状态计数
        int leadWordsWaiteStatus = 0; // 引导语等待状态（0为不播放等待引导语，1为播放等待引导语，2为播放提示语）
        int againWaitAddCount = 0; // 再次等待的附加计数（避免调整佩戴后很快进入提示语状态）

        DATA leadWordsStartPoint = 0; //导语播放时间节点
        GAME_STATE processStateTemp = GAME_STATE::NONE; //过程状态缓存
        bool gameStartFlag = false;//游戏开始标志
        DATA gameTime = 0.;        //游戏时间
        int soundNoteSum = 0;      //游戏中音效累计次数
        bool stopCheckFlag = true;   //结束验证标志
        bool musicStopFlag = false;    //音乐停止标志
        DATA volumeFactor = 1.;     //音乐音量因
        DATA pitchLevel = 0.;       //音高水平
        bool validCheckFlag = true;

        std::vector<int> chordList;
        std::vector<int> curMelodyPiano;

        std::vector<std::vector<DATA>> rhythmMat;
        std::vector<std::vector<DATA>> figureListPiano;
        bool isFirstBar = false;

        std::vector<ConcentrationV3::CommonResult> concentrationBuffer;
    }musicData_;

    //内部算法类
    AlgorithmBox algorithmBox_;
};

}
}
}


#endif //ALGORITHMSDK_SDK_CONCENTRATIONMUSIC_V3_CONCENTRATIONMUSICHANDLER_H
