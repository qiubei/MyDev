//
//  AlgorithmWrapper.swift
//  BLESDK
//
//  Created by HyanCat on 2018/6/5.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation
import BLESDK_Concentration
import BLESDK_NapMusic
import BLESDK_ConcentrationMusic

/// 算法选项
public struct AlgorithmOptions: OptionSet {

    public typealias RawValue = UInt

    public var rawValue: UInt

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    /// 注意力算法
    public static let concentration = AlgorithmOptions(rawValue: 1 << 0)
    /// 注意力谱曲算法
    public static let concentrationMusic = AlgorithmOptions(rawValue: 1 << 1)
    /// 小睡算法
    public static let nap = AlgorithmOptions(rawValue: 1 << 2)
    /// 小睡脑波音乐算法
    public static let napMusic = AlgorithmOptions(rawValue: 1 << 3)
}

/// 算法包装适配
class AlgorithmWrapper {

    private var algorithmOptions: AlgorithmOptions = []

    /// 注册算法
    ///
    /// - Parameter options: 算法
    func register(algorithm options: AlgorithmOptions) {
        algorithmOptions.insert(options)
    }

    /// 开启算法
    func start() {
        if algorithmOptions.contains(.concentration) {
            Concentration.start()
        }
        if algorithmOptions.contains(.concentrationMusic) {
            ConcentrationMusic.start()
        }
        if algorithmOptions.contains(.nap) {
            NapMusic.start()
            NapMusic.enableMusic = false
        }
        if algorithmOptions.contains(.napMusic) {
            NapMusic.start()
            NapMusic.enableMusic = true
        }
    }

    /// 处理脑电数据
    ///
    /// - Parameter data: Data 包装的原始脑电数据
    func handleBrainData(_ data: Data) {
        if algorithmOptions.contains(.concentration) {
            Concentration.push(rawData: data, blinkBlock: { isBlink in
                DLog("concentration blink: \(isBlink)")
                NotificationName.concentrationBlink.emit([.concentrationBlinkKey: isBlink])
            }) { concentrationData in
                DLog("concentration data: \(concentrationData)")
                NotificationName.concentrationData.emit([.concentrationDataKey: concentrationData])
            }
        }
        if algorithmOptions.contains(.concentrationMusic) {
            ConcentrationMusic.push(rawData: data) { concentrationMusicData in
                DLog("concentration music data: \(concentrationMusicData.process), commands: \(concentrationMusicData.noteCommands)")
                NotificationName.concentrationMusicData.emit([.concentrationMusicKey: concentrationMusicData])
            }
        }

        if algorithmOptions.containsAny(of: [.napMusic, .nap]) {
            NapMusic.push(rawData: data, processBlock: { processData in
                DLog("nap process data: \(processData)")
                NotificationName.napProcessData.emit([.napProcessDataKey: processData])
            }) { musicCommand in
                DLog("nap music commands: \(musicCommand.noteCommands), status: \(musicCommand.status)")
                NotificationName.napMusicData.emit([.napMusicCommandKey: musicCommand])
            }
        }

//        if algorithmOptions.containsAny(of: [.sleep]) {
//            Sleep.append(data: data) { (processData) in
//                DLog("sleep process data: \(processData)")
//                NotificationName.sleepProcessData.emit([.sleepProcessDataKey: processData])
//            }
//        }
    }

    func wearing(isOK: Bool) {
        if algorithmOptions.contains(.concentrationMusic) {
            ConcentrationMusic.wearing(isOK: isOK)
        }
        if algorithmOptions.contains(.napMusic) {
            NapMusic.wearing(isOK: isOK)
        }
    }

    /// 结束算法
    func end() {
        if algorithmOptions.contains(.concentrationMusic) {
            ConcentrationMusic.finish { result in
                DLog("concentration music finish data: \(result)")
                NotificationName.concentrationMusicFinishData.emit([.concentrationFinishDataKey: result])
            }
            algorithmOptions.remove(.concentrationMusic)
        }
        if algorithmOptions.containsAny(of: [.napMusic, .nap]) {
            NapMusic.finish { finishData in
                DLog("nap finish data: \(finishData)")
                NotificationName.napFinishData.emit([.napFinishDataKey: finishData])
            }
            if algorithmOptions.contains(.napMusic) {
                algorithmOptions.remove(.napMusic)
            }
            
            if algorithmOptions.contains(.nap) {
                algorithmOptions.remove(.nap)
            }
        }
    }
}

extension OptionSet where Self == Self.Element {
    internal func containsAny(of elements: [Element]) -> Bool {
        for e in elements {
            if self.contains(e) {
                return true
            }
        }
        return false
    }
}
