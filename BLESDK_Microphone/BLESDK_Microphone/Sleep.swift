//
//  Sleep.swift
//  BLESDK_Microphone
//
//  Created by Anonymous on 2018/7/26.
//  Copyright © 2018年 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class Sleep {

    public typealias SleepMicProcessDataBlock = (MicAnalyzedProcessData) -> Void
    public typealias SleepFinishBlock = (SleepFinishResult) -> Void

    /// swift 类型： 麦克风算法实时分析结果
    public struct MicAnalyzedProcessData {
        /// 时间戳
        public let timestamp: Int
        /// 环境噪声
        public let noiseLv: Double
        /// 鼾声标记
        public let snoreFlag: Bool
        /// 梦话标记
        public let daydreamFlag: Bool
        public let soundControl: UInt8
        /// 闹钟信号
        public let alarm: Bool
        /// 动作能量变化
        public let movementEn: Double
        /// 动作频次
        public let movementFreq: Double
        /// 鼾声音频数据
        public let snoreRecData: [Int16]
        /// 梦话音频数据
        public let daydreamRecData: [Int16]
    }

    /// swift 类型： 小睡算法实时分析结果
    public struct NapAnalyzedProcessData {
        public let timestamp: Int
        public let sleepState: UInt8
        public let dataQuality: UInt8
        public let soundControl: UInt8

        public init(_ timestamp: Int,
                    _ sleepState: UInt8,
                    _ dataQuality: UInt8,
                    _ soundControl: UInt8){
            self.timestamp = timestamp
            self.sleepState = sleepState
            self.dataQuality = dataQuality
            self.soundControl = soundControl
        }
    }

    /// swift 类型：晚睡算法综合得分结果
    public struct SleepFinishResult {
        /// 综合得分
        public let score: Int
        /// 清醒时长
        public let soberLen: Int
        /// 浅睡时长
        public let lightSleepLen: Int
        /// 深睡时长
        public let deepSleepLen: Int
        /// 入睡时长
        public let latencyLen: Int
        /// 睡眠时长（睡着到清醒）
        public let sleepLen: Int
        /// 入睡点
        public let sleepPoint: Int
        /// 唤醒点
        public let alarmPoint: Int
        /// 体验综合数据质量
        public let detectQuality: Int
        /// 睡眠曲线
        public let sleepCurveData: Data
        /// 环境噪声曲线
        public let sleepNoiseLvData: Data
        /// 鼾声记录曲线
        public let sleepSnoresData: Data
        /// 梦话记录曲线
        public let sleepDaydreamData: Data
    }


    /// 开始开启晚睡算法
    public class func start() {
        SleepHandler.start()
    }

    /// 向麦克风算法实时喂数据，算法 1 min 触发一次，通过 block 回调算法的实时分析结果。
    ///
    /// - Parameters:
    ///   - data: 1 min 内的录音文件数据，麦克风算法输入。
    ///   - block: 算法实时分析结果回调。
    public class func append(audioData data: Data, block: @escaping SleepMicProcessDataBlock) {
        SleepHandler.appendMicData(data) { (processData) in
            let snoreRecData = processData.snoreRecData.map({  return Int16($0.intValue) })
            let daydreamRecData = processData.daydreamRecData.map({ Int16($0.intValue) })
            let tmpData = MicAnalyzedProcessData(timestamp: processData.timestamp,
                                                 noiseLv: processData.noiseLv,
                                                 snoreFlag: processData.snoreFlag,
                                                 daydreamFlag: processData.dayDreamFlag,
                                                 soundControl: processData.soundControl,
                                                 alarm: processData.alarm,
                                                 movementEn: processData.movementEn,
                                                 movementFreq: processData.movementFreq,
                                                 snoreRecData: snoreRecData,
                                                 daydreamRecData: daydreamRecData)
            block(tmpData)
        }
    }

    /// 告诉算法当前是否有音乐播放
    ///
    /// - Parameter flag: 播放状态，正在播放 true
    public class func setMusic(flag: Bool) {
        SleepHandler.setMusic(flag)
    }

    /// 设置麦克风闹钟参数
    ///
    /// - Parameter alarmSet: 结构体闹钟参数（1. 是否在闹钟区间 2. 闹钟区间长度）
    public class func setAlarm(alarmSet: AlarmSet) {
        var alarm = alarmSet
        SleepHandler.setAlarm(&alarm)
    }

    /// 结束晚睡算法：napAnalyzedResults 为小睡算法实时分析的结果列表，如果为默认值说明当前算法只触发麦克风算法；
    /// 否则为触发晚睡算法。
    ///
    /// - Parameters:
    ///   - analyses: 小睡算法实时分析的结果列。
    ///   - finishBlock: 算法结果回调。
    public class func finish(napAnalyzedResults analyses: Array<NapAnalyzedProcessData> = [NapAnalyzedProcessData](),
                             resultBlock finishBlock: @escaping SleepFinishBlock) {
        var napAnalyses = [NPNapAnalyzedProcessData]()
        for item in analyses {
            let value = NPNapAnalyzedProcessData()
            value.timestamp = item.timestamp
            value.dataQuality = item.dataQuality
            value.soundControl = item.soundControl
            value.sleepState = item.sleepState
            napAnalyses.append(value)
        }

        SleepHandler.finish(napAnalyses) {
            let result = SleepFinishResult(score: Int($0.score),
                                           soberLen: Int($0.soberLen),
                                           lightSleepLen: Int($0.lightSleepLen),
                                           deepSleepLen: Int($0.deepSleepLen),
                                           latencyLen: Int($0.latencyLen),
                                           sleepLen: Int($0.sleepLen),
                                           sleepPoint: Int($0.sleepPoint),
                                           alarmPoint: Int($0.alarmPoint),
                                           detectQuality: Int($0.detectQuality),
                                           sleepCurveData: $0.sleepCurveCom,
                                           sleepNoiseLvData: $0.sleepNoiseCom,
                                           sleepSnoresData: $0.sleepSnoreCom,
                                           sleepDaydreamData: $0.sleepDaydreamCom)
            finishBlock(result)
        }
    }
}
