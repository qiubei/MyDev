//
// Created by 雷京颢 on 2018/10/23.
//

#ifndef ENTEREEG_IO_REPORTDATA_H
#define ENTEREEG_IO_REPORTDATA_H

#include "FileHeader.h"
#include <vector>


namespace EnterTech {
namespace EnterEEG {

//TODO 升级为支持 Fragment 分片的类型
struct NapReportData {
    FileHeader header;

    uint32_t napScore = 0;
    uint32_t sleepPoint = 0;
    uint32_t alarmPoint = 0;

    uint32_t napClassSober = 0;
    uint32_t napClassBlur = 0;
    uint32_t napClassSleep = 0;

    uint32_t curveDataGap = 0;

    std::vector<uint8_t> napCurve;
    std::vector<uint8_t> napClass;
};

const uint8_t NAP_REPORT_NAP_SCORE       = 0x01;
const uint8_t NAP_REPORT_SLEEP_POINT     = 0x02;
const uint8_t NAP_REPORT_ALARM_POINT     = 0x03;
const uint8_t NAP_REPORT_NAP_CLASS_SOBER = 0x04;
const uint8_t NAP_REPORT_NAP_CLASS_BLUR  = 0x05;
const uint8_t NAP_REPORT_NAP_CLASS_SLEEP = 0x06;
const uint8_t NAP_REPORT_CURVE_DATA_GAP  = 0x07; //单位 ms
const uint8_t NAP_REPORT_NAP_CURVE       = 0xf1;
const uint8_t NAP_REPORT_NAP_CLASS       = 0xf2;

void saveNapReportData(NapReportData napReportData, const std::string &filename);

NapReportData loadNapReportData(const std::string &filename);

}
}


#endif //ENTEREEG_IO_REPORTDATA_H
