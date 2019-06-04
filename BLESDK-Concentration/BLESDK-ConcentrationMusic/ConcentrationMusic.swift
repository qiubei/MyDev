//
//  ConcentrationMusic.swift
//  BLESDK-ConcentrationMusic
//
//  Created by HyanCat on 2018/6/11.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation

public protocol Command {
    var duration: TimeInterval { get }
}

public class ConcentrationMusic {

    private init() {}

    open class var language: ConcentrationMusic.Language {
        get {
            return Language(rawValue: UInt8(ConcentrationMusicHandle.language.rawValue))!
        }
        set {
            ConcentrationMusicHandle.language = LanguageMode(rawValue: UInt(newValue.rawValue))!
        }
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

    /// 注意力音乐指令
    public struct MusicProcessData {
        public let sleepCommand: SleepCommand
        public let noteCommands: [NoteCommand]
        public let process: ProcessData
    }

    /// 注意力过程中处理数据
    public struct ProcessData {
        public let state: ProcessState
        public let degree: UInt8
    }

    /// 注意力谱曲结果
    public struct Result {
        public let soundCount: UInt8
        public let avgConcentration: UInt8
        public let rankRate: UInt8
        public let similarRate: UInt8
        public let similarName: ComposerName
        public let maxConcentration: UInt8
        public let minConcentration: UInt8
        public let highPitch: String
        public let lowPitch: String
    }

    /// 过程状态
    public enum ProcessState: UInt8 {
        case initilize = 0
        case ready
        case start
        case end
    }

    /// 作曲家
    public enum ComposerName: UInt8 {
        case none = 0
        case liszt
        case chopin
        case mozart
        case tschakovsky
        case bach
        case brahms
        case haydn
        case beethoven
        case schubert
        case mendelssohn
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

    public typealias MusicBlock = (MusicProcessData) -> Void
    public typealias ResultBlock = (Result) -> Void

    public class func start() {
        ConcentrationMusicHandle.start()
    }

    public class func push(rawData: Data, musicBlock: @escaping MusicBlock) {
        ConcentrationMusicHandle.pushRawData(rawData) { (process, commands) in
            // ugly fix by qiubei：add the processing when commands is empty
            guard !commands.isEmpty else {
                let musicProcess = MusicProcessData(sleepCommand: SleepCommand(duration: 0),
                                                    noteCommands: [],
                                                    process: ProcessData(state: ProcessState(rawValue: UInt8(process.state.rawValue))!,
                                                                         degree: process.degree))
                musicBlock(musicProcess)
                return
            }
            commands.forEach {
                let musicProcess = MusicProcessData(sleepCommand: SleepCommand(duration: $0.sleepCommand.duration),
                                                    noteCommands: $0.noteCommands.map { NoteCommand(duration: $0.duration,
                                                                                                    instrument: $0.instrument,
                                                                                                    pitch: $0.pitch,
                                                                                                    pan: $0.pan) },
                                                    process: ProcessData(state: ProcessState(rawValue: UInt8(process.state.rawValue))!,
                                                                         degree: process.degree))
                musicBlock(musicProcess)
            }
        }
    }

    public class func wearing(isOK: Bool) {
        ConcentrationMusicHandle.wearinng(isOK)
    }

    public class func finish(resultBlock: @escaping ResultBlock) {
        ConcentrationMusicHandle.finish {
            let result = Result(soundCount: $0.soundCount,
                                avgConcentration: $0.avgConcentration,
                                rankRate: $0.rankRate,
                                similarRate: $0.similarRate,
                                similarName: ComposerName(rawValue: UInt8($0.similarName.rawValue))!,
                                maxConcentration: $0.maxConcentration,
                                minConcentration: $0.minConcentration,
                                highPitch: $0.highPitch,
                                lowPitch: $0.lowPitch)
            resultBlock(result)
        }
    }
}
