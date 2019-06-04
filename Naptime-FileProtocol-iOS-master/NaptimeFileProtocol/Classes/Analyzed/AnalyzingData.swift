//
//  AnalyzingData.swift
//  Pods
//
//  Created by HyanCat on 16/8/25.
//
//

import Foundation

/**
 * 分析中数据结构
 */
public struct AnalyzingData: CustomStringConvertible {
    /// 数据质量
    public let dataQuality: Byte
    /// 音量控制
    public let soundControl: Byte
    /// 唤醒信号
    public let awakeStatus: Byte
    /// 睡眠状态
    public let sleepStatusMove: Byte
    /// 实时放松度
    public let restStatusMove: Byte
    /// 佩戴状态
    public let wearStatus: Byte

    public init(dataQuality: Byte, soundControl: Byte, awakeStatus: Byte, sleepStatusMove: Byte, restStatusMove: Byte, wearStatus: Byte) {
        self.dataQuality = dataQuality
        self.soundControl = soundControl
        self.awakeStatus = awakeStatus
        self.sleepStatusMove = sleepStatusMove
        self.restStatusMove = restStatusMove
        self.wearStatus = wearStatus
    }

    public var description: String {
        return "[\(dataQuality), \(soundControl), \(awakeStatus), \(sleepStatusMove), \(restStatusMove), \(wearStatus)]"
    }
}
