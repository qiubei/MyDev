//
// Created by 雷京颢 on 2018/6/5.
//

#ifndef ALGORITHMSDK_SDK_NAPMUISIC_V3_ALGORITHMBOX_H
#define ALGORITHMSDK_SDK_NAPMUISIC_V3_ALGORITHMBOX_H


#define PIANO_RHYTHM_MAT std::vector<std::vector<std::vector<std::vector<std::vector<DATA>>>>>
#define FIGURE_LIB_MAT std::vector<std::vector<std::vector<DATA>>>

#include "DataDefine.h"
#include "command/command.h"
#include "../../public/RandHandler.h"

namespace EnterTech{
namespace AlgorithmSDK{
namespace NapMusicV3{

class AlgorithmBox {
public:
    std::vector<int> sortLibChoose(unsigned PHRASE_LENGTH);
    std::vector<int> chordListGen(int preChord, int PHRASE_LENGTH, bool IS_MAJOR);
    std::vector<std::vector<DATA>> rhythmMatGenByPopPiano(std::vector<int> chordList,
                                                          std::vector<int> figureSort,
                                                          const PIANO_RHYTHM_MAT &pianoRhythmMatLib,
    DATA sleepCurveValue,
            DATA phraseStartPoint,
    unsigned PHRASE_LENGTH,
    unsigned BAR_LENGTH,
            DATA TEMPO_SPEED,
    unsigned NOTE_TRACK);

    std::vector<std::vector<DATA>> rhythmMatGenByStrings(std::vector<int> chordList,
                                                         DATA phraseStartPoint,
                                                         std::vector<DATA> preRhythm,
                                                         unsigned PHRASE_LENGTH,
                                                         unsigned BAR_LENGTH,
                                                         DATA TEMPO_SPEED,
                                                         unsigned NOTE_TRACK
    );

    std::vector<std::vector<DATA>> figureListGenPiano(std::vector<int> figureSort,
                                                      DATA sleepCurve,
                                                      const FIGURE_LIB_MAT &figureLib,
    unsigned PHRASE_LENGTH);

    std::vector<std::vector<DATA>> figureListGenStrings(std::vector<int> figureSort,
                                                        DATA sleepCurve,
                                                        const FIGURE_LIB_MAT &figureLib,
    unsigned PHRASE_LENGTH);

    std::pair<std::vector<int>, std::vector<int>> melodyGenPiano(int curChord,
                                                                 const std::vector<DATA> &curFigure,
                                                                 const std::vector<int> &preMelody,
                                                                 DATA eegComplexity,
                                                                 bool isFirstBar);

    std::pair<std::vector<int>, std::vector<int>> melodyGenStrings(int curChord,
                                                                   const std::vector<DATA> &curFigure,
                                                                   const std::vector<int> &preMelody,
                                                                   DATA eegComplexity,
                                                                   bool isFirstBar);

    std::vector<std::vector<DATA>> melodyMatGen(const std::vector<int> &curMelody,
                                                const std::vector<int> &curHarmony,
                                                int curChord,
                                                const std::vector<DATA> &curFigure,
                                                int barStartPoint,
                                                DATA TEMPO_SPEED,
                                                int NOTE_TRACK);
    std::vector<CommandPack> playCommandGen(const std::vector<std::vector<DATA>> &curMusicMat,
                                            unsigned barStartPoint,
                                            unsigned totalDataCount,
                                            unsigned BAR_LENGTH,
                                            DATA TEMPO_SPEED);

    std::pair<std::vector<CommandPack>, DATA> leadWordsCommandGen(LANGUAGE_MODE languageMode,
                                                                  int leadWordsStatus,
                                                                  int leadWordsFileNum,
                                                                  int totalDataCount);

    std::vector<std::vector<DATA>> endingMusicMatGenPiano(const std::vector<int> &preMelody,
                                                          int barStartPoint,
                                                          bool IS_MAJOR,
                                                          unsigned BAR_LENGTH,
                                                          DATA TEMPO_SPEED,
                                                          unsigned NOTE_TRACK);
private:

    /**
     * chordTrans用于随机产生当前和弦
     * @param preChord   上一小节和弦
     * @param barNum     当前小节在乐句中的序号
     * @param IS_MAJOR   是否为大调
     * @return 当前小节和弦
     */
    int chordTrans(int preChord, int barNum, bool IS_MAJOR);

    /**
     * 用于对和弦进行变异处理，用一些固定的和弦序列替换当前和弦序列
     * @param chordList  和弦序列
     * @param IS_MAJOR   是否为大调
     * @return 变异后的和弦序列
     */
    std::vector<int> chordsMut(const std::vector<int> &chordList, bool IS_MAJOR);

    std::vector<DATA> noteVolumeCal(const std::vector<int> &curMelody,
                                    const std::vector<int> &curHarmony,
                                    int curChord,
                                    const std::vector<DATA> &curFigure,
                                    const std::vector<DATA> &notePoint,
                                    unsigned melodyNoteNum);

    unsigned commandIndex = 0;
};


}
}
}


#endif //ALGORITHMSDK_SDK_NAPMUISIC_V3_ALGORITHMBOX_H
