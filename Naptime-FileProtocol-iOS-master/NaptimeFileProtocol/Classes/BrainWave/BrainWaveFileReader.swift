//
//  BrainWaveFileReader.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 16/8/24.
//  Copyright © 2016年 entertech. All rights reserved.
//

import Foundation

/// 脑波文件读取器
open class BrainWaveFileReader: DataFileReader {

    /// 序列化后的数据，BrainWaveData 的数组
    open var serializedData: [BrainWaveData] = []

    open override func loadFile(_ fileURL: URL) throws {
        do {
            try super.loadFile(fileURL)
            self.serializedData = self.serialize(self.data as Data)
        } catch {
            throw error
        }
    }

    /**
     脑波数据序列化

     - parameter data: 脑波文件的数据

     - returns: BrainWaveData 数组
     */
    fileprivate func serialize(_ data: Data) -> [BrainWaveData] {
        var brainwaveDataArray: [BrainWaveData] = []
        let buffers = data.allBytes
        let splitedArray = buffers.splitBy(2)
        for item in splitedArray {
            guard item.count == 2 else {
                continue
            }
            let value = UInt16(item[0]) << 8 + UInt16(item[1])
            let brainwaveData = BrainWaveData(value: value)
            brainwaveDataArray.append(brainwaveData)
        }
        return brainwaveDataArray
    }
}
