//
// Created by 雷京颢 on 2017/12/21.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRATION_V3_ALGORITHMBOX_H
#define ALGORITHMSDK_SDK_CONCENTRATION_V3_ALGORITHMBOX_H

#include <tuple>

#include "DataDefine.h"


//函数声明
namespace EnterTech {
namespace AlgorithmSDK {
namespace ConcentrationV3 {

class AlgorithmBox {
public:

    DATA concentrationCal(DATA bertaEn, DATA thetaEn);
    DATA relaxationCal(DATA alphaEn);
    bool blinkDetect(const std::vector<DATA> &eogWave, size_t stepLen, DATA floorThreshold=1000, DATA topThreshold=20000);
    std::pair<DATA, std::vector<DATA>> moveingAvgCal(const std::vector<DATA> &winData, DATA newData, size_t winLen);
    std::vector<DATA> sdwCal(const std::vector<DATA> &wave, const std::vector<DATA> &preWave, size_t winLen);
    std::vector<DATA> eogSdwCal(const std::vector<DATA> &eogWave, size_t stepLen);
    std::vector<DATA> specCal(const std::vector<DATA> &wave, size_t specLen, int NFFT=1024);

};

}
}
}
#endif //ALGORITHMSDK_SDK_V3_ALGORITHMBOX_H
