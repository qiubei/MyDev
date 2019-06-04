//
// Created by 雷京颢 on 2018/5/30.
//

#ifndef ALGORITHMSDK_SDK_NAP_V3_DATAMANAGER_H
#define ALGORITHMSDK_SDK_NAP_V3_DATAMANAGER_H


#include "CommonHandler.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace NapV3 {

class DataManager {
public:

    /**
     *  获得类的单例
     *
     *  @return 单例的引用
     */
    static DataManager &getInstance() {
        static DataManager instance;
        return instance;
    }

    DataManager(DataManager const &) = delete;

    void operator=(DataManager const &) = delete;

    /**
     * Manager初始化
     */
    void init(const std::string &mlpJsonFileName);

    /**
     * 输入原始脑波
     * @param rawData vector封装的原始脑波
     * @return 算法分析触发状态
     */
    TriggerState appendRawData(const std::vector<RAW_DATA> &rawData);

    /**
     * 输入原始脑波
     * @param rawData vector封装的原始脑波
     * @return 算法分析触发状态
     */
    TriggerState appendRawData(RAW_DATA rawData);

    /**
     * 设置音量调节接口
     * @param manualOperated
     */
    void setManualOperated(double manualOperated);

    /**
     * 获得 正常 触发一次的分析后结果
     * @return
     */
    CommonResult getCommonResult() const;

    /**
     * 获得最终审判数据
     * @return
     */
    FinishResult getFinishResult() const;

    /**
     * 触发最终审判
     * @param soundControl  音量控制
     * @param sleepState    判断得到的清醒/睡眠
     * @param mlpDegree     神经网络输出结果
     * @param dataQuality
     */
    void finish(const std::vector<SOUND_CONTROL> &soundControl,
                const std::vector<SLEEP_STATE> &sleepState,
                const std::vector<DATA> &mlpDegree,
                const std::vector<DATA_QUALITY> &dataQuality);

    /**
     * 是否执行过初始化
     * @return 是否执行过初始化
     */
    bool isInited();

private:

    //单例相关
    DataManager() = default;

    ~DataManager();

    //内部持有的变量
    CommonHandler *commonHandler_ = nullptr;
    bool isInited_ = false;

    //为了兼容
    std::vector<DATA> buffer_;
};

}
}
}

#endif //ALGORITHMSDK_SDK_NAP_V3_DATAMANAGER_H
