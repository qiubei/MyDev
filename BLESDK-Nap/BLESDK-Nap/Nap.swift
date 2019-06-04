//
//  Nap.swift
//  BLESDK-Nap
//
//  Created by HyanCat on 2018/6/5.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation

/// 小睡过程分析数据
public struct NapProcessData {
    /// 实时数据质量
    public internal (set) var dataQuality: UInt8 = 0
    /// 声音控制信号
    public internal (set) var soundControl: UInt8 = 0
    /// 实时清醒状态
    public internal (set) var awakeStatus: UInt8 = 0
    /// 实时睡眠状态
    public internal (set) var sleepStatusMove: UInt8 = 0
    /// 实时放松状态
    public internal (set) var restStatusMove: UInt8 = 0
    /// 实时佩戴状态
    public internal (set) var wearStatus: UInt8 = 0
}

/// 小睡结束数据
public struct NapFinishData {
    /// 睡眠度
    public internal (set) var sleepDegree: UInt8 = 0
    /// 放松度
    public internal (set) var relaxDegree: UInt8 = 0
    /// 综合得分
    public internal (set) var totalScore: UInt8 = 0
    /// 清醒时长
    public internal (set) var soberTime: TimeInterval = 0
    /// 浅睡时长
    public internal (set) var sleepLightTime: TimeInterval = 0
    /// 深睡时长
    public internal (set) var sleepHeavyTime: TimeInterval = 0
    /// 睡眠状态数据
    public internal (set) var sleepStateData: Data?
}

/// 小睡算法
public class Nap {

    public typealias ProcessBlock = (NapProcessData) -> Void
    public typealias FinishBlock = (NapFinishData) -> Void

    public static var language: AlgorithmLanguage = .unknown

    public class func start() {
        AlgorithmHandler.start()
    }

    public class func push(rawData: Data, processBlock: @escaping ProcessBlock) {
//        AlgorithmHandler.pushRawData(rawData) {
//            let process = NapProcessData(dataQuality: $0.dataQuality,
//                                         soundControl: $0.soundControl,
//                                         awakeStatus: $0.awakeStatus,
//                                         sleepStatusMove: $0.sleepStatusMove,
//                                         restStatusMove: $0.restStatusMove,
//                                         wearStatus: $0.wearStatus)
//            processBlock(process)
//        }
    }

    public class func finish(block: @escaping FinishBlock) {
//        AlgorithmHandler.finish {
//            let result = NapFinishData(sleepDegree: $0.sleepDegree,
//                                       relaxDegree: $0.relaxDegree,
//                                       totalScore: $0.totalScore,
//                                       soberTime: $0.soberTime,
//                                       sleepLightTime: $0.sleepLightTime,
//                                       sleepHeavyTime: $0.sleepHeavyTime,
//                                       sleepStateData: $0.sleepStateData)
//            block(result)
//        }
    }
}
