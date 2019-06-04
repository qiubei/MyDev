//
// Created by 雷京颢 on 2017/12/21.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRATION_V3_DATAMANAGER_H
#define ALGORITHMSDK_SDK_CONCENTRATION_V3_DATAMANAGER_H

#include "DataDefine.h"
#include "DataManager.h"
#include "TinyHandler.h"
#include "CommonHandler.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace ConcentrationV3 {

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
    void init();

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
     * 获得 200ms 触发一次的分析后结果
     * @return
     */
    TinyResult getTinyResult();

    /**
     * 获得 400ms 触发一次的分析后结果
     * @return
     */
    CommonResult getCommonResult();

    /**
     * 是否执行过初始化
     * @return 是否执行过初始化
     */
    bool isInited();

    //***************** Android 专用小水管接口 *****************

    /**
     * 得到 CommonResult 的标量部分
     * @return
     */
    CommonResultScalarPart getCommonResultScalarPart();

    std::vector<DATA> getSpectrum(size_t startIndex, size_t size);

    std::vector<RAW_DATA> getSmoothRawData(size_t startIndex, size_t size);

    //********************************************************

private:

    //单例相关
    DataManager() = default;

    ~DataManager();

    //内部持有的变量
    TinyHandler *tinyHandler_ = nullptr;
    CommonHandler *commonHandler_ = nullptr;
    bool isInited_ = false;
};
}
}
}


#endif //ALGORITHMSDK_SDK_CONCENTRATION_V3_DATAMANAGER_H
