//
// Created by 雷京颢 on 2018/10/23.
//

#ifndef ENTEREEG_IO_ANALYZEDDATA_H
#define ENTEREEG_IO_ANALYZEDDATA_H

#include <string>
#include <vector>
#include "FileHeader.h"

namespace EnterTech {
namespace EnterEEG {

//TODO 升级为支持 Fragment 分片的类型
struct NapAnalyzedData {
    FileHeader header;

    std::vector<uint8_t> dataQuality;
    std::vector<uint8_t> soundControl;
    std::vector<uint8_t> awakeStatus;
    std::vector<uint8_t> sleepStatus;
    std::vector<uint8_t> restStatus;
    std::vector<uint8_t> wearStatus;
};

NapAnalyzedData loadNapAnalyzedData(const std::string& filename, bool ignoreChecksum = false);

}
}

#endif //ENTEREEG_IO_ANALYZEDDATA_H
