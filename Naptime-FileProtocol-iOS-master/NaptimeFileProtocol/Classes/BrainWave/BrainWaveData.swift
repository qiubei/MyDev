//
//  BrainWaveData.swift
//  Pods
//
//  Created by HyanCat on 16/8/25.
//
//

import Foundation

/**
 * 脑波数据结构
 */
public struct BrainWaveData {
    public let value: UInt16

    public init(value: UInt16) {
        self.value = value
    }
}
