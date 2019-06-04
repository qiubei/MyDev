//
// Created by 雷京颢 on 2018/6/8.
//

#ifndef ENTEREEG_DSP_PROCESSOR_H
#define ENTEREEG_DSP_PROCESSOR_H

#include "../define/Device.h"
#include <vector>
#include <string>

namespace EnterTech {
namespace EnterEEG {

class Processor {
public:

    /**
     *  获得类的单例
     *
     *  @return 指向单例的指针
     */
    static Processor &getInstance() {
        static Processor instance;
        return instance;
    }

    Processor(Processor const &) = delete;
    void operator=(Processor const &)  = delete;

    /**
     * 初始化
     */
    void init(DeviceInfo);

    /**
     * 滤除直流
     * @param inputWave 脑波片段
     * @return 滤除直流后的脑波片段
     */
    std::vector<DATA> dcFilter(const std::vector<DATA> &inputWave) const;

    /**
     * 带通滤波（无汉明窗，保留更多时域信息）
     * @param inputWave 滤除直流的脑波片段
     * @param bandpass  带通滤波器参数
     * @param NFFT      傅里叶变换点数
     * @param Nr        滤波器阶数
     * @return  滤波后的脑波片段
     */
    std::vector<DATA> bandFilterNonHamming(const std::vector<DATA> &inputWave,
                                           const std::vector<DATA> &bandpass, int NFFT=-1, int Nr=178) const;

    /**
     * 计算脑波片段的信噪比
     * @param inputwave  滤除直流后的脑波片段
     * @param NFFT       傅里叶变换点数
     * @return  信噪比
     */
    DATA snrCal(const std::vector<DATA> &inputwave, size_t NFFT=1024) const;

    /**
     * 判断脑波片段的数据有效性
     * @param inputWave      未滤除直流的脑波片段
     * @param snd            信噪比
     * @param ampRms         有效幅值（单位：uV）
     * @param topThreshold   幅值上限（单位：uV）
     * @param floorThreshold 幅值下限（单位：uV）
     * @param snrThreshold   信噪比阈值
     * @return     脑波片段的有效性
     */
    DATA_QUALITY validityJudge(const std::vector<DATA> &inputWave, DATA snr, DATA ampRms = -1,
                               DATA topThreshold = 2.3*100000000, DATA floorThreshold = -2.3*100000000,
                               DATA snrThreshold = 1.2) const;

    /**
     * 分离脑电眼电（小波去噪）
     * @param inputWave    带通滤波后的脑波片段
     * @param waveletName  小波基名称
     * @return  小波去噪得到的脑波片段，小波分解提取的眼电信号
     */
    std::pair<std::vector<DATA>, std::vector<DATA>> eegEogDivider(const std::vector<DATA> &inputWave,
                                                                  const std::string &waveletName="bior3.5") const;

    /**
     * 计算频段能量
     * @param data       滤波后的脑波片段
     * @param freqL      下限截止频率
     * @param freqH      上限截止频率
     * @param powerMode  频段能量计算模式（包括：max/sum/mean）
     * @param NFFT       傅里叶变换点数
     * @return    频段能量
     */
    DATA bandPowerCal(const std::vector<DATA> &data, DATA freqL, DATA freqH,
                      const std::string &powerMode="max", size_t NFFT=1024) const;

    /**
     * 计算脑电波有效幅值（用于判断信号质量）
     * @param eegWave  小波去噪后的脑波片段
     * @return   脑波片段的有效幅值
     */
    DATA ampRmsCal(const std::vector<DATA> &eegWave) const;

    /**
     * 多项式滤波
     * @param data   脑波片段
     * @param order  多项式阶次，默认一阶线性
     * @return   滤波后片段
     */
    std::vector<DATA> polynomialFilter(const std::vector<DATA> &data, size_t order = 1);

private:
    Processor() = default;
    ~Processor() = default;

    DeviceInfo deviceInfo_;
};

}
}

#endif //ENTEREEG_DSP_PROCESSOR_H
