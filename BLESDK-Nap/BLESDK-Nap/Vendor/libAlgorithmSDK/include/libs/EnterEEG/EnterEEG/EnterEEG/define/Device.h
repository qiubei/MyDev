//
// Created by 雷京颢 on 2018/6/7.
//

#ifndef ENTEREEG_DEFINE_DEVICE_H
#define ENTEREEG_DEFINE_DEVICE_H

#include "Data.h"

namespace EnterTech {
namespace EnterEEG {

class DeviceInfo {
public:
    DeviceInfo() : device_(DEVICE::UNKNOWN){}
    DeviceInfo(DEVICE device) : device_(device) {}
    DATA fs() const;
    int minVal() const;
    int maxVal() const;
    DATA minUV() const;
    DATA maxUV() const;
    short digits() const;

private:
    DEVICE device_;
};

}
}

#endif //ENTEREEG_DEFINE_DEVICE_H
