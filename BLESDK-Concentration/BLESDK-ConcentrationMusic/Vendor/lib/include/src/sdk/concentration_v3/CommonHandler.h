//
// Created by 雷京颢 on 2018/5/2.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRATION_V3_COMMONHANDLER_H
#define ALGORITHMSDK_SDK_CONCENTRATION_V3_COMMONHANDLER_H

#include "DataDefine.h"
#include "AlgorithmBox.h"


namespace EnterTech {
namespace AlgorithmSDK {
namespace ConcentrationV3 {

class CommonHandler {
    friend class DataManager;
private:

    /**
     * 构造方法
     */
    CommonHandler();

    /**
     * 输入原始脑波数据
     * @param data 原始脑波vector
     * @return 是否触发了算法分析
     */
    bool appendRawData(const std::vector<RAW_DATA> &data);

    /**
     * 输入原始脑波数据
     * @param data 原始脑波
     * @return 是否触发了算法分析
     */
    bool appendRawData(RAW_DATA data);

    /**
     * 得到分析结果
     * @return
     */
    CommonResult getCommonResult() const;

    /**
     * 判断是否需要触发算法分析，并触发之
     * @return 是否触发了算法分析
     */
    bool triggerCheck();

    /**
     * 触发算法分析
     * @param rawData        原始脑波数据
     * @param totalDataCount 目前处理过的数据计数
     */
    void trigger(const std::vector<DATA> &rawData);

    //内部数据
    std::deque<RAW_DATA> rawData_;
    CommonResult commonResult_;

    //算法内部持有的历史中间变量
    struct DataPack{
        size_t num = 0;
        std::deque<DATA> quaStore;  //信号质量暂存序列，用于判断是否计算注意力与放松度，并判断设备是否在使用中摘下或脱落
        std::deque<DATA> concentrationStore; //注意力值暂存序列，用于计算最终输出的注意力值，-1为无效值
        std::deque<DATA> relaxationStore;    //放松度值暂存序列，用于计算最终输出的放松度值，-1为无效值
        std::vector<DATA> concentrationComb; //衡量注意力值的梳子标尺
        std::vector<DATA> relaxationComb;    //衡量放松度值的梳子标尺
        std::vector<DATA> concentrationAdjustStore; //注意力自适应暂存序列，用于修正标尺
        std::vector<DATA> relaxationAdjustStore;    //放松度自适应暂存序列，用于修正标尺
    }currentData_;

    //算法
    AlgorithmBox algorithmBox_;
};

}
}
}


#endif //ALGORITHMSDK_SDK_CONCENTRATION_V3_COMMONHANDLER_H
