//
// Created by 雷京颢 on 2018/6/5.
//

#ifndef ALGORITHMSDK_SDK_NAPMUSIC_V3_NAPMUSICDEFINE_H
#define ALGORITHMSDK_SDK_NAPMUSIC_V3_NAPMUSICDEFINE_H

//#define COUNT_DISP

#include <string>
#include <vector>
#include <random>
#include <iostream>
#include "MatlabToolBox.h"
#include "EnterEEG.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace NapMusicV3 {

const std::string NAPMUSIC_V3_VERSION = "0.1.0";

enum class MUSIC_STATUS {
    UNWEAR = 0, GENERATING = 1, PLAYING = 2, WARMING = 3, STOPPED = 4
};

enum class LANGUAGE_MODE {
    UNKNOWN = 0, CHN = 1, ENG = 2, JPN = 3
}; // 语言模式

enum class SOUND_CONTROL_INPUT {
    NORMAL = 0, DECREASE = 1, STOP = 2, ALARM
};

struct NapMusicInput {
    DATA napDegree;
    SOUND_CONTROL_INPUT soundControl;
};

//每次trigger后的分析后数据
struct NapMusicAnalyzedDataPack {
    MUSIC_STATUS musicStatus = MUSIC_STATUS::UNWEAR;
};

const unsigned NFFT = 1024;          //FFT 点数
const unsigned Nr = 178;             //带通滤波器阶数
const unsigned N_LENGTH = 1024;      //每段数据长度
const unsigned N_LENGTH_NEW = 1000;  //每4秒数据长度
const double FS = 250.;              //采样率
const unsigned WINDOW_LENGTH = 10;   //滑动平均窗长度，取值为偶数
const unsigned VALID_START = 10;     //控制判断有效开始时刻
const unsigned VALID_START_TIME_POINT = 30; //控制判断有效开始时刻，单位秒。即通过极化之后VALID_START_TIME_POINT秒后进入SOBER_NORMAL

//音乐基本参数设置
const double SAMPLING_INTERVAL = 2.;//采样时间间隔（单位：s）
const double LEAD_WORDS_LENGTH = 60.; //引导语长度（单位：s）
const unsigned PHRASE_LENGTH = 8;     //乐句长度（小节个数）
const unsigned CHORD_LIST_LENGTH = 8; //和弦序列长度（小节个数)
const bool IS_MAJOR = false;      //调性（1为大调，0为小调）
const double TEMPO_SPEED = 60.;     // 速度
const unsigned BAR_LENGTH = 4; // 每小节拍长
const double BAR_TIME = BAR_LENGTH / (TEMPO_SPEED / 60); // 计算每小节时长（单位：s）
const double PHRASE_TIME = PHRASE_LENGTH * BAR_TIME; // 计算每个乐句时长
const unsigned INITIAL_POINTS = 3; // 初始化所需数据量（与初始化用时相关）
const unsigned RHYTHM_TRACK_PIANO = 1; // 钢琴伴奏音轨
const unsigned RHYTHM_TRACK_STRINGS = 2; // 弦乐伴奏音轨
const unsigned MELODY_TRACK_PIANO = 1; // 钢琴旋律音轨
const unsigned MELODY_TRACK_STRINGS = 2; // 弦乐旋律音轨

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


#endif //ALGORITHMSDK_SDK_NAPMUSIC_V3_NAPMUSICDEFINE_H
