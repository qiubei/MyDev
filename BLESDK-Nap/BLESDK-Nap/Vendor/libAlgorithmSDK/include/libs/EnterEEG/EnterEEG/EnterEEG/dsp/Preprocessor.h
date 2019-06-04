//
// Created by 雷京颢 on 2018/6/7.
//

#ifndef ENTEREEG_DSP_PREPROCESSOR_H
#define ENTEREEG_DSP_PREPROCESSOR_H

#include "../define/Device.h"
#include <vector>

namespace EnterTech {
namespace EnterEEG {

class Preprocessor {
public:

    /**
     *  获得类的单例
     *
     *  @return 指向单例的指针
     */
    static Preprocessor &getInstance() {
        static Preprocessor instance;
        return instance;
    }

    Preprocessor(Preprocessor const &) = delete;
    void operator=(Preprocessor const &)  = delete;

    /**
     * 初始化
     */
    void init(DeviceInfo);

    /**
     * 将原始数据归一化到微伏
     * @param  data 待归一化数据
     * @return      归一化后数据
     */
    std::vector<DATA> normalizeToUV(const std::vector<RAW_DATA> &data) const;

    /**
     * 将原始数据归一化
     * @param data    待归一化数据
     * @param maxVal  归一化后最大取值
     * @param minVal  归一化后最小取值
     * @return        归一化后数据
     */
    std::vector<DATA> normalize(const std::vector<RAW_DATA> &data, DATA maxVal = 1024, DATA minVal = 0.) const;

private:
    Preprocessor() = default;
    ~Preprocessor() = default;

    DeviceInfo deviceInfo_;
};

}
}

#endif //ENTEREEG_DSP_PREPROCESSOR_H
