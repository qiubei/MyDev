//
//  NapMusic.swift
//  BLESDK-NapMusic
//
//  Created by HyanCat on 2018/6/11.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation

public protocol Command {
    var duration: TimeInterval { get }
}

/// 小睡音乐算法
public class NapMusic {

    /// 小睡过程分析数据
    public struct NapProcessData {
        /// 神经网络数值
        public internal (set) var mlpDegree: Double = 0
        /// 放松度
        public internal (set) var napDegree: UInt8 = 0
        /// 实时睡眠状态
        public internal (set) var sleepState: UInt8 = 0
        /// 实时数据质量
        public internal (set) var dataQuality: UInt8 = 0
        /// 声音控制信号
        public internal (set) var soundControl: UInt8 = 0
        /// 实时曲线数据
        public internal (set) var smoothRawData: Data?
        /// α 波能量
        public internal (set) var alphaEngery: UInt8 = 0
        /// β 波能量
        public internal (set) var betaEngery: UInt8 = 0
        /// θ 波能量
        public internal (set) var thetaEngery: UInt8 = 0
    }

    /// 小睡结束数据
    public struct NapFinishData {
        /// 睡眠度
        public internal (set) var sleepScore: UInt8 = 0
        /// 睡眠时长
        public internal (set) var sleepLatency: Double = 0.0
        /// 清醒时长
        public internal (set) var soberDuration: Double = 0
        /// 迷糊时长
        public internal (set) var blurrDuration: Double = 0
        /// 浅睡时长
        public internal (set) var sleepDuration: Double = 0
        /// 睡眠曲线：入睡点坐标
        public internal (set) var sleepPoint: Int32 = 0
        /// 睡眠曲线：唤醒点坐标
        public internal (set) var alarmPoint: Int32 = 0
        /// 状态曲线：清醒
        public internal (set) var soberLevelPoint: Int32 = 0
        /// 状态曲线：迷糊
        public internal (set) var blurrLevelPoint: Int32 = 0
        /// 状态曲线：浅睡
        public internal (set) var sleepLevelPoint: Int32 = 0
        /// 体验过程中的数据质量
        public internal (set) var wearQuality: UInt8 = 0
        /// 睡眠状态数据
        public internal (set) var sleepStateData: Data?
        /// 绘制睡眠曲线数据
        public internal (set) var sleepCurveData: Data?
    }

    /// 小节指令
    public struct SleepCommand: Command {
        public private (set)  var duration: TimeInterval
    }

    /// 播放音节指令
    public struct NoteCommand: Command {
        public private (set) var duration: TimeInterval
        public let instrument: UInt8
        public let pitch: UInt64
        public let pan: Float
    }

    /// 小睡音乐指令
    public struct NapMusicCommand {
        public let sleepCommand: SleepCommand
        public let noteCommands: [NoteCommand]
        public let status: Status
    }

    /// 状态
    ///
    /// - unwear: 未佩戴
    /// - generating: 正在生成
    /// - playing: 正在播放
    /// - warming: 正在保温
    /// - stopped: 已停止
    public enum Status: UInt8 {
        case unwear = 0
        case generating
        case playing
        case warming
        case stopped
    }

    /// 语言
    ///
    /// - unknown: 未知语言
    /// - chinese: 中文
    /// - english: 英文
    /// - japanese: 日文
    public enum Language: UInt8 {
        case unknown = 0
        case chinese
        case english
        case japanese
    }

    public typealias ProcessBlock = (NapProcessData) -> Void
    public typealias FinishBlock = (NapFinishData) -> Void
    public typealias MusicBlock = (NapMusicCommand) -> Void

    public static var language: Language = .unknown {
        didSet {
            NapMusicHandler.language = AlgorithmLanguage(rawValue: UInt(language.rawValue))!
        }
    }

    public static var enableMusic: Bool = false {
        didSet {
            NapMusicHandler.enableMusic = enableMusic
        }
    }

    public class func start() {
        NapMusicHandler.start()
    }

    public class func push(rawData: Data,
                           processBlock: @escaping ProcessBlock,
                           musicBlock: @escaping MusicBlock) {
//        print("into NapMusic.swift block ")
        NapMusicHandler.pushRawData(rawData, handleProcess: {
            let process = NapProcessData(mlpDegree: $0.mlpDegree,
                                         napDegree: $0.napDegree,
                                         sleepState: $0.sleepState,
                                         dataQuality: $0.dataQuality,
                                         soundControl: $0.soundControl,
                                         smoothRawData: $0.smoothRawData,
                                         alphaEngery: $0.alphaEnergy,
                                         betaEngery: $0.betaEnergy,
                                         thetaEngery: $0.thetaEnergy)
            processBlock(process)
        }) { (commands, status) in
            commands.forEach {
                let status = Status(rawValue: UInt8(status.rawValue))!
                let musicCommand = NapMusicCommand(sleepCommand: SleepCommand(duration: $0.sleepCommand.duration),
                                                   noteCommands: $0.noteCommands.map {
                                                    NoteCommand(duration: $0.duration,
                                                                instrument: $0.instrument,
                                                                pitch: $0.pitch,
                                                                pan: $0.pan)},
                                                   status: status)
                musicBlock(musicCommand)
            }
        }
    }

    public class func wearing(isOK: Bool) {
        NapMusicHandler.wearing(isOK)
    }

    public class func operate(volume: Float) {
        NapMusicHandler.operateVolume(volume)
    }

    public class func finish(block: @escaping FinishBlock) {
        NapMusicHandler.finish {
            let result = NapFinishData(sleepScore: $0.sleepScore,
                                       sleepLatency: $0.sleepLatency,
                                       soberDuration: $0.soberDuration,
                                       blurrDuration: $0.blurrDuration,
                                       sleepDuration: $0.sleepDuration,
                                       sleepPoint: $0.sleepPoint,
                                       alarmPoint: $0.alarmPoint,
                                       soberLevelPoint: $0.soberLevelPoint,
                                       blurrLevelPoint: $0.blurrLevelPoint,
                                       sleepLevelPoint: $0.sleepLevelPoint,
                                       wearQuality: $0.wearQuality.rawValue,
                                       sleepStateData: $0.sleepStateData,
                                       sleepCurveData: $0.sleepCurveData)
            block(result)
        }
    }

    public class func caculateSleepCurve(analyzedData: Data, block: @escaping FinishBlock) {
        NapMusicHandler.calculateSleepCurve(analyzedData) {
            let result = NapFinishData(sleepScore: $0.sleepScore,
                                       sleepLatency: $0.sleepLatency,
                                       soberDuration: $0.soberDuration,
                                       blurrDuration: $0.blurrDuration,
                                       sleepDuration: $0.sleepDuration,
                                       sleepPoint: $0.sleepPoint,
                                       alarmPoint: $0.alarmPoint,
                                       soberLevelPoint: $0.soberLevelPoint,
                                       blurrLevelPoint: $0.blurrLevelPoint,
                                       sleepLevelPoint: $0.sleepLevelPoint,
                                       wearQuality: $0.wearQuality.rawValue,
                                       sleepStateData: $0.sleepStateData,
                                       sleepCurveData: $0.sleepCurveData)
            block(result)
        }
    }
}
