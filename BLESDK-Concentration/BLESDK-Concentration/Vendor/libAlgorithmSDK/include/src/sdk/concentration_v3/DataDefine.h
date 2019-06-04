//
// Created by 雷京颢 on 2017/12/21.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRATION_V3_DATADEFINE_H
#define ALGORITHMSDK_SDK_CONCENTRATION_V3_DATADEFINE_H

#include <vector>

#include "../../../libs/MatlabToolBox/MatlabToolBox/MatlabToolBox.h"
#include "../../../libs/EnterEEG/EnterEEG/EnterEEG.h"


namespace EnterTech{
namespace AlgorithmSDK{
namespace ConcentrationV3{

const std::string CONCENTRATION_V3_VERSION = "2.0.0";


std::vector<DATA> getBandpassFilter();
std::vector<DATA> getAngleWindow();

/**
 * 眨眼状态
 */
enum BLINK_STATUS{UNBLINK = 0, BLINK = 1};

/**
 * 200 ms/1000 ms 触发一次的分析结果
 */
struct TinyResult {
    BLINK_STATUS blinkStatus = BLINK_STATUS::UNBLINK;
};

/**
 * 400 ms/2000ms 触发一次的分析结果
 */
struct CommonResult {
    DATA concentration = 0.0;
    DATA relax = 0.0;
    DATA_QUALITY dataQuality = DATA_QUALITY::INVALID;
    std::vector<DATA> spectrum;
    std::vector<RAW_DATA> smoothRawData;
};

/**
 * 400 ms 触发一次的分析结果--专门用于 Android 的小水管
 */
struct CommonResultScalarPart {
    DATA concentration = 0.0;
    DATA relax = 0.0;
    DATA_QUALITY dataQuality = DATA_QUALITY::INVALID;
    size_t spectrumSize = 0;
    size_t smoothRawDataSize = 0;
};

const size_t TINY_TRIGGER_LENGTH   = 50;       // 200ms 触发一次，即  50 个原始数据
const size_t COMMON_TRIGGER_LENGTH = 100;      // 400ms 触发一次，即 100 个原始数据

const unsigned NFFT = 1024;
const unsigned Nr = 178;
const unsigned N_LENGTH = 512;
const unsigned N_LENGTH_NEW = 500;
const unsigned M_LENGTH = 256;
const unsigned M_LENGTH_NEW = 250;

const double FS = 250.;
const unsigned WINDOW_LENGTH = 10;

std::vector<DATA> getAngleWindow();
std::vector<DATA> getBandpassFilter();
std::vector<DATA> getConcentrationComb();
std::vector<DATA> getRelaxComb();

const std::vector<DATA> BANDPASS_FILTER = getBandpassFilter();
const std::vector<DATA> HAMMING_WINDOW_VALUE = MatlabToolBox::hamming<DATA>(N_LENGTH);
const std::vector<DATA> ANGLE_WINDOW = getAngleWindow();
const std::vector<DATA> CONCENTRATION_COMB = getConcentrationComb();
const std::vector<DATA> RELAX_COMB = getRelaxComb();

}
}
}

#endif //ALGORITHMSDK_SDK_CONCENTRATION_V3_DATADEFINE_H
