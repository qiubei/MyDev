//
// Created by 雷京颢 on 2018/5/30.
//

#ifndef ALGORITHMSDK_SDK_NAP_V3_ALGORITHMBOX_H
#define ALGORITHMSDK_SDK_NAP_V3_ALGORITHMBOX_H

#include <cstddef>
#include <vector>
#include <deque>
#include <utility>
#include <iostream>
#include <string>
#include <algorithm>

#include "DataDefine.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace NapV3 {
class AlgorithmBox {
public:
    std::vector<DATA> normalize(const std::vector<DATA> &data) const;

    int sleepPointFind(const std::vector<SOUND_CONTROL> &data) const;
    int alarmPointFind(const std::vector<SOUND_CONTROL> &data) const;
    std::vector<DATA> napCurveCal(const std::vector<SLEEP_STATE> &sleepStateStore,
                                  const std::vector<DATA> &mlpCurveStore,
                                  const std::vector<DATA_QUALITY> &dataQualityStore) const;
    std::vector<NAP_CLASS> napClassCal(const std::vector<SLEEP_STATE> &sleepStateStore,
                                       const std::vector<SOUND_CONTROL> &soundControlStore,
                                       const std::vector<DATA_QUALITY> &dataQualityStore) const;

    std::vector<DATA> napClassRuler(const std::vector<DATA> &napCurve,
                                    const std::vector<NAP_CLASS> &napClass) const;

    DATA napScoreCal(const std::vector<DATA> &napCurve,
                     const std::vector<SOUND_CONTROL> &soundControlStore,
                     const std::vector<DATA_QUALITY> &dataQualityStore,
                     DATA stepSec) const;
};


}
}
}

#endif //ALGORITHMSDK_SDK_NAP_V3_ALGORITHMBOX_H
