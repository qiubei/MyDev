//
// Created by 雷京颢 on 2018/6/6.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRATIONMUSIC_V3_DATADEFINE_H
#define ALGORITHMSDK_SDK_CONCENTRATIONMUSIC_V3_DATADEFINE_H

#include "../../../libs/MatlabToolBox/MatlabToolBox/MatlabToolBox.h"
#include "../../../libs/EnterEEG/EnterEEG/EnterEEG/EnterEEG.h"
#include "command/command.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace ConcentrationMusicV3 {

const std::string NAP_V3_VERSION = "0.0.14";

/**
 * 外部需要输入给注意力音乐的注意力数据
 */
struct ConcentrationCommonResultInput {
    DATA concentrationData;
    size_t totalDataCount;
};

enum class LANGUAGE_MODE {
    UNKNOWN = 0, CHN = 1, ENG = 2, JPN = 3
}; // 语言模式

/**
* 相似的音乐家姓名
*/
enum class MUSICIAN_NAME {NONE, LISZT, CHOPIN, MOZART, TSCHAIKOVSKY, BACH, BRAHMS, HAYDN, BEETHOVEN, SHUBERT, MENDELSOHN};

/**
 * 最终审判得到的数据
 */
struct FinishDataPack {
    size_t soundSum = 0;        //音效出现次数
    DATA concentrationLow = 0.; //专注度最低值
    DATA concentrationHigh = 0.;//专注度最高值
    DATA concentrationAvg = 0;  //专注度平均值
    DATA rankRate = 0.;         //专注度最高值超过的人数百分比
    std::string pitchNameLow;   //最低音音名
    std::string pitchNameHigh;  //最高音音名
    MUSICIAN_NAME musicianName; //风格相似的音乐家名字
    DATA simRate;               //风格相似的音乐家相似度

#ifdef RAND_BOX
    Pitch pitchLow=0;
    Pitch pitchHigh=0;
#endif
};

/**
 * 初始化游戏状态（0初始，1准备放松，2游戏开始，3游戏结束）
 */
enum class GAME_STATE { NONE = -1, INIT = 0, READY = 1, START = 2, END = 3};

/**
 * 当前输出结果（包括音高水平、游戏状态）
 */
struct CurrentResult {
    DATA concentrationDegree = 0.; //初始化专注度输出值
    GAME_STATE processState = GAME_STATE::NONE;  //初始化游戏状态
    unsigned soundSum = 0;           //初始化音效出现次数
    Pitch pitchHigher = 0;         //初始化最高音
    Pitch pitchLower = 0;          //初始化最低音
    DATA notesPerBar = 0.;         //初始化音符密度
    int chordFlow = -1;            //初始化和弦流
};


struct FinishDataTmp {
    unsigned maxSoundSumRecord = 0;
    DATA maxConcentration = 0.;
    DATA minConcentration = 100.;
    DATA concentrationSum = 0.;
    Pitch pitchLowest = 108;
    Pitch pitchHighest = 21;
    DATA pitchRangeSum = 0.;
    DATA notesPerBarSum = 0.;
    DATA pitchHighSum = 0.;
    unsigned dataInGameCount = 0;
    unsigned pitchRangeCount = 0;
    unsigned notesPerBarCount = 0;
    unsigned emotionHighCount = 0;
    unsigned emotionLowCount = 0;
    unsigned chordFlowCount = 0;
};


const unsigned NFFT = 1024;          //FFT 点数
const unsigned Nr = 178;             //带通滤波器阶数
const unsigned N_LENGTH = 1024;      //每段数据长度
const unsigned N_LENGTH_NEW = 1000;  //每4秒数据长度
const double FS = 250.;              //采样率
const unsigned WINDOW_LENGTH = 10;   //滑动平均窗长度，取值为偶数
const unsigned VALID_START = 5;     //控制判断有效开始时刻

//音乐基本参数设置
const double SAMPLING_INTERVAL = 2.;//采样时间间隔（单位：s）
const double LEAD_WORDS_LENGTH = 60.; //引导语长度（单位：s）
const unsigned PHRASE_LENGTH = 4;     //乐句长度（小节个数）
const unsigned CHORD_LIST_LENGTH = 8; //和弦序列长度（小节个数)
const bool IS_MAJOR = true;      //调性（1为大调，0为小调）
const double TEMPO_SPEED = 120.;     // 速度
const unsigned BAR_LENGTH = 4; // 每小节拍长
const double BAR_TIME = BAR_LENGTH / (TEMPO_SPEED / 60); // 计算每小节时长（单位：s）
const double PHRASE_TIME = PHRASE_LENGTH * BAR_TIME; // 计算每个乐句时长
const unsigned INITIAL_POINTS = 3; // 初始化所需数据量（与初始化用时相关）
const DATA GAME_TIME = 40.;        //游戏时长
const unsigned RHYTHM_TRACK_PIANO = 1; // 钢琴伴奏音轨
const unsigned RHYTHM_TRACK_STRINGS = 2; // 弦乐伴奏音轨
const unsigned MELODY_TRACK_PIANO = 1; // 钢琴旋律音轨
const unsigned MELODY_TRACK_STRINGS = 2; // 弦乐旋律音轨
const unsigned SOUND_TRACK = 4;       // 打击乐音轨

std::vector<DATA> getAngleWindow();

std::vector<DATA> getBandpassFilter();

std::vector<std::vector<std::vector<DATA>>> getFigureLib();

std::vector<std::vector<std::vector<std::vector<std::vector<DATA>>>>> getPianoRhythmLib();

const auto BANDPASS_FILTER_250 = getBandpassFilter();
const auto HAMMING_WINDOW_VALUE = MatlabToolBox::hamming<DATA>(N_LENGTH);
const auto ANGLE_WINDOW = getAngleWindow();
const auto FIGURE_LIB = getFigureLib();
const auto PIANO_RHYTHMLIB = getPianoRhythmLib();

}
}
}

#endif //ALGORITHMSDK_SDK_CONCENTRATIONMUSIC_V3_DATADEFINE_H
