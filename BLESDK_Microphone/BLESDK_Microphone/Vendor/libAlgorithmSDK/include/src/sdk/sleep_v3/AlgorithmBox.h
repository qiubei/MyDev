//
// Created by 雷京颢 on 2018/6/5.
//

#ifndef ALGORITHMSDK_SDK_SLEEP_V3_ALGORITHMBOX_H
#define ALGORITHMSDK_SDK_SLEEP_V3_ALGORITHMBOX_H

#include <cstddef>
#include <vector>
#include <utility>
#include <iostream>
#include <string>
#include <algorithm>

#include "DataDefine.h"
//#include "../../sdk/nap_v3/DataDefine.h"
#include "../../public/SmoothHandler.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace SleepV3 {

class AlgorithmBox {
public:


    /*
    * @param audioData 音频数据
    * @param eventKey  录音数据边界
    *
    * @return:   录音数据
 * */
    std::vector<AUDIO_DATA> audioRacDataCut(const std::vector<AUDIO_DATA> &audioData,
                                                      const std::vector<std::vector<size_t>> &eventKey);


    /**
     * 本函数用于分离原始音频中的事件与底噪
     * @param audioData为原始音频
     * @return eventMark为事件判别结果（向量中每个元素表示该帧是否为事件，1为事件，0为底噪），eventKey为事件边界，noiseSIL为底噪声强级，varSeq为音频变化率序列
     */
    std::tuple<std::vector<bool>, std::vector<std::vector<size_t>>, DATA, std::vector<DATA>> audioEventSeparate(const std::vector<AUDIO_DATA> &audioData);

    /**
     * 本函数用于计算每个事件的音频特征参数
     * @param audioData  原始音频
     * @param eventKey   事件边界
     * @param varSeq     音频变化率序列
     * @return featureMatMc为机器识别特征矩阵，featureMatAf为人工过滤特征矩阵（矩阵每行保存一个事件的多个特征），eventSIL为事件声强级
     */
    std::tuple<std::vector<std::vector<DATA>>, std::vector<std::vector<DATA>>, std::vector<DATA>> audioFeatureCal(const std::vector<AUDIO_DATA> &audioData,
                                                                                                                  const std::vector<std::vector<size_t>> &eventKey,
                                                                                                                  const std::vector<DATA> &varSeq);

    std::tuple<std::vector<DATA>, std::vector<DATA>> audioSpecCal(const std::vector<AUDIO_DATA> &audioData);

    /**
     * 本函数用于计算频谱中几个特征频段的能量比例
     * @param specMag   频谱能量
     * @param specFreq  频率坐标
     * @return 保存的各频段能量比例
     */
    std::vector<DATA> audioSpecDivide(const std::vector<DATA> &specMag, const std::vector<DATA> &specFreq);

    /**
     * 本函数用于对音频中的事件进行分类（模式识别）
     * @param eventKey      事件边界
     * @param featureMatMc  机器识别特征矩阵
     * @param featureMatAf  人工过滤特征矩阵
     * @param eventSIL      事件声强级
     * @param snoreClassifierStump  分类器
     * @param voiceClassifierStump  分类器
     * @param movementClassifierThr  分类阈值
     * @return eventClass为事件分类结果向量（动作/鼾声/梦话/环境），snoreKey为鼾声边界
     */
    std::tuple<std::vector<EVENT_CLASS>, std::vector<std::vector<size_t>>, std::vector<std::vector<size_t>>> audioEventClassify(const std::vector<std::vector<size_t>> &eventKey,
                                                                                            const std::vector<std::vector<DATA>> &featureMatMc,
                                                                                            const std::vector<std::vector<DATA>> &featureMatAf,
                                                                                              const std::vector<DATA> &eventSIL,
                                                                                            const std::vector<ClassifierStump> &snoreClassifierStump,
                                                                                            const std::vector<ClassifierStump> &voiceClassifierStump,
                                                                                            DATA movementClassifierThr);

    /**
     * 本函数用于【Adaboost】分类
     * @param featureMat      特征矩阵
     * @param classifierStump 训练得到的决策树组
     * @param classNum        类别数
     * @return 分类结果标签向量
     */
    std::vector<size_t> adaClassify(const std::vector<std::vector<DATA>> &featureMat,
                                    const std::vector<ClassifierStump> &classifierStump,
                                    size_t classNum);

    /**
     * 本函数用于单层决策树分类（只区分是否属于该类）
     * @param featureMat   特征矩阵
     * @param featInd      特征编号
     * @param threshVal    阈值
     * @param classInd     判别不等式（0为<=,1为>）
     * @param classNum
     * @return
     */
    std::vector<std::vector<DATA>> stumpClassify(const std::vector<std::vector<DATA>> &featureMat,
                                                 size_t featInd, DATA threshVal, DATA threshIneq,
                                                 size_t classInd, size_t classNum);

    /**
     * sleepClassCalEEG用于重新计算晚睡脑电波监测得到的睡眠分期（时间尺度转换为与麦克风睡眠分期一致）
     * @param sleepStatusRecord  小睡算法得到的睡眠曲线
     * @param dataQualityRecord  数据质量
     * @param soundControlRecord 音量控制信号
     * @param timeStampEEG       脑电波监测数据时间戳
     * @return sleepClassEEG为脑电波监测睡眠分期，dataQualityEEG为脑电波数据质量，asleepRecord为入睡点，timeStampAdjEEG为校正后的脑电波数据时间戳
     */
    std::tuple<std::vector<SLEEP_STATUS>,
               std::vector<DATA_QUALITY>,
               std::vector<bool>,
               std::vector<DATA>> sleepClassCalEEG(const std::vector<DATA> &sleepStatusRecord,
                                                   const std::vector<DATA_QUALITY> &dataQualityRecord,
                                                   const std::vector<EnterTech::AlgorithmSDK::SleepV3::SOUND_CONTROL_RAW> &soundControlRecord,
                                                   const std::vector<DATA> &timeStampEEG);

    /**
     * 用于计算晚睡麦克风监测得到的睡眠分期
     * @param movementEnRecord  动作能量记录
     * @param snoreFlagRecord   鼾声标志
     * @param timeStampMic      麦克风监测数据时间戳
     * @return sleepClassMic为麦克风监测睡眠分期，timeStampAdjMic为校正后的麦克风数据时间戳
     */
    std::tuple<std::vector<SLEEP_STATUS>, std::vector<DATA>> sleepClassCalMic(const std::vector<DATA> &movementEnRecord,
                                                                              const std::vector<DATA> &movementFreqRecord,
                                                                              const std::vector<bool> &snoreFlagRecord,
                                                                              const std::vector<DATA> &timeStampMic);

    std::tuple<std::vector<DATA>, std::vector<SleepV3::SLEEP_STATUS>, std::vector<DATA>> sleepCurveCal(const std::vector<SleepV3::SLEEP_STATUS> &sleepClassMic,
                               const std::vector<SleepV3::SLEEP_STATUS> &sleepClassEEG,
                  const std::vector<DATA_QUALITY> &dataQualityEEG,
                  const std::vector<DATA> &timeStampAdjMic,
                  const std::vector<DATA> &timeStampAdjEEG);

    FinishDataPackPlus sleepReport(const std::vector<EnterTech::DATA> &sleepCurveCom,
                               const std::vector<EnterTech::AlgorithmSDK::SleepV3::SLEEP_STATUS> &sleepClassCom,
                               const std::vector<bool> &asleepRecord,
                               DATA movementFreqResult,
                               const std::vector<bool> &snoreFlagRecord,
                               const std::vector<bool> &daydreamFlagRecord,
                               const DETECT_QUALITY detectQuality,
                               const std::vector<DATA> &timeStampCom);

    std::vector<DATA> static timeStampSimGen(DATA dataLen, int dataIntv, DATA gapLen,  DATA gapLocRate);

    /*
     *
     *监测质量评价
     *param movement_energy_store:   动作能量暂存序列
     *param noise_level_store:       噪声水平暂存序列
     *return:                        监测质量评价分级
     */
    DETECT_QUALITY sleepDetectQualityEvaluate(std::vector<DATA>movementEnStore,
            std::vector<DATA> noisLvStore,
            std::vector<EnterTech::AlgorithmSDK::SleepV3::SLEEP_STATUS> sleepClassCom);


    int alarmPointFind(const std::vector<SOUND_CONTROL_RAW> &soundControlStore) const;

    std::vector<NAP_CLASS> napClassCal(
            const std::vector<SLEEP_STATE> &sleepStateStore,
            const std::vector<SOUND_CONTROL_RAW> &soundControlStore,
            const std::vector<DATA_QUALITY> &dataQualityStore) const;

    std::vector<int> napClassRuler(const std::vector<int> &napCurve,
                                            const std::vector<NAP_CLASS> &napClass) const;

    std::vector<int> napCurveCal(
            const std::vector<SLEEP_STATE> &sleepStateStore,
            const std::vector<DATA> &mlpCurveStore,
            const std::vector<DATA_QUALITY> &dataQualityStore) const;

    int napScoreCal(const std::vector<int> &napCurve,
                                  const std::vector<SOUND_CONTROL_RAW> &soundControlStore,
                                  const std::vector<DATA_QUALITY> &dataQualityStore,
                                  DATA stepSec) const;

    int sleepPointFind(const std::vector<SOUND_CONTROL_RAW> &soundControlStore) const;

    WEAR_QUALITY wearQualityEvaluate(
            const std::vector<DATA_QUALITY> &dataQualityStore) const;
};


}
}
}


#endif //ALGORITHMSDK_SDK_SLEEP_V3_ALGORITHMBOX_ALGORITHMBOX_H
