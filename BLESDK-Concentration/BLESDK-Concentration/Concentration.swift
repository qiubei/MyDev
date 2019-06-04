//
//  Something.swift
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/25.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation

/// 注意力数据结构
public struct ConcentrationData {
    /// 数据质量
    public internal (set) var dataQuality: DataQuality = .invalid
    /// 注意力值（0-100）
    public internal (set) var concentration: UInt8 = 0
    /// 放松度（0-100）
    public internal (set) var relax: UInt8 = 0
    /// 滤波后的原始数据
    public internal (set) var smoothData: [Int] = []
    /// 1-40Hz 各频段能量谱数据
    public internal (set) var spectrum: [Int] = []
}

public class Concentration {

    public class func start() {
        ConcentrationHandler.start()
    }

    public class func push(rawData: Data, blinkBlock:((Bool) -> Void)?, dataBlock:((ConcentrationData) -> ())?) {
        ConcentrationHandler.pushRawData(rawData, handleBlink: {
            blinkBlock?($0)
        }) {
            let smoothPointer = UnsafeBufferPointer(start: $0.smoothData.point, count: Int($0.smoothData.length))
            let smoothData = Swift.Array(smoothPointer)
            let spectrumPointer = UnsafeBufferPointer(start: $0.spectrum.point, count: Int($0.spectrum.length))
            let spectrum = Swift.Array(spectrumPointer)
            let data = ConcentrationData(dataQuality: $0.dataQuality, concentration: $0.concentration, relax: $0.relax, smoothData: smoothData, spectrum: spectrum)
            dataBlock?(data)
        }
    }
}
