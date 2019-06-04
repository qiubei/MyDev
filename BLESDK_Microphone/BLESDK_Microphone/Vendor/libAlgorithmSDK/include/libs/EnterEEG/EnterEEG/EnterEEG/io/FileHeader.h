//
// Created by 雷京颢 on 2018/10/23.
//

#ifndef ENTEREEG_IO_FILEHEADER_H
#define ENTEREEG_IO_FILEHEADER_H

#include <string>
#include <cstdint>
#include <iostream>
#include <vector>

namespace EnterTech {
namespace EnterEEG {

enum FileType {UNKNOWN=0, RAW, NAP_ANALYZED, NAP_REPORT, SLEEP_ANALYZED, SLEEP_REPORT};

struct FileHeader {
    std::string protocolVersion = "0.0";
    uint8_t headerLength = 0; //in bytes
    FileType fileType = FileType::UNKNOWN;
    std::string dataVersion = "0.0.0.0";
    uint64_t dataLength = 0;//in bytes
    uint16_t checksum = 0;
    uint32_t unixTimeStamp = 0;
};

FileHeader loadFileHeader(std::ifstream& s);
std::vector<uint8_t> genFileHeaderBinary(const FileHeader &header);

}
}
#endif //ENTEREEG_IO_FILEHEADER_H
