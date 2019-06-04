//
// Created by 雷京颢 on 2018/10/23.
//

#ifndef ENTEREEG_IO_BASIC_H
#define ENTEREEG_IO_BASIC_H

#include <cstdint>
#include <vector>

//TODO 整体使用继承的方式重构
//TODO 增加 iterator 支持
//TODO 增加更详细的输出日志，比如说明出错的值是 fileType,当前读到的值是多少

namespace EnterTech {
namespace EnterEEG {


uint64_t readUInt64(uint8_t *data, unsigned byteCount=8);
uint32_t readUInt32(uint8_t *data, unsigned byteCount=4);
uint16_t readUInt16(uint8_t *data, unsigned byteCount=2);

uint16_t checksum(uint8_t *data, unsigned byteCount);
uint16_t checksum(const std::vector<uint8_t> &data);


}
}

#endif //ENTEREEG_IO_BASIC_H
