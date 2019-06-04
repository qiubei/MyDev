//
// Created by 雷京颢 on 2018/5/30.
//

#ifndef ALGORITHMSDK_SDK_NAP_V3_COMMONHANDLER_H
#define ALGORITHMSDK_SDK_NAP_V3_COMMONHANDLER_H

#include "DataDefine.h"
#include "AlgorithmBox.h"
#include "../../../libs/EnterEEG/EnterEEG/EnterEEG/EnterEEG.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace NapV3 {

class CommonHandler {
    friend class DataManager;

private:

    /**
     * 构造方法
     */
    CommonHandler() = default;

    ~CommonHandler();

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
     * 得到最终审判数据
     * @return
     */
    FinishResult getFinishResult() const;

    /**
     * 最终审判
     * @param soundControl 音量控制
     * @param sleepState   睡眠状态
     * @param mlpDegree    神经网络输出值
     * @param dataQuality  信号质量
     */
    void finish(const std::vector<SOUND_CONTROL> &soundControl,
                const std::vector<SLEEP_STATE> &sleepState,
                const std::vector<DATA> &mlpDegree,
                const std::vector<DATA_QUALITY> &dataQuality);

    /**
     * 初始化方法
     */
    void init(const std::string &jsonFile);

    /**
     * 判断是否需要触发算法分析，并触发之
     * @return 是否触发了算法分析
     */
    bool triggerCheck();

    /**
     * 触发算法分析
     * @param rawData  原始脑波数据
     * @param timeSec  当前时刻
     */
    void trigger(const std::vector<DATA> &rawData, DATA timeSec);

    //内部数据
    std::deque<RAW_DATA> rawData_;
    CommonResult commonResult_;
    FinishResult finishResult_;
    DATA currentTimePoint_ = 0;

    //算法内部持有的历史中间变量
    struct DataPack {
        EnterEEG::KerasModel *kerasModel = nullptr;

        NAP_PHASE napPhase = NAP_PHASE::INIT;
        std::deque<int> memory;
        std::vector<DATA> mlpStore;
        DATA decreaseTimePoint = -1.;
        DATA stopTimePoint = -1.;
        DATA fixTimePoint = -1.;
        std::deque<DATA> sleepNapDegree;

    }currentData_;

    //算法
    AlgorithmBox algorithmBox_;
};

}
}
}


#endif //ALGORITHMSDK_COMMONHANDLER_H
