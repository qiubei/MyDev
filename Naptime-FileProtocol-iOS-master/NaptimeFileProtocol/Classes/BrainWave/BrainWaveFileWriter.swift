//
//  BrainWaveFileWriter.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 16/8/24.
//  Copyright © 2016年 entertech. All rights reserved.
//

import Foundation

/// 脑波文件写工具
open class BrainWaveFileWriter: DataFileWriter {

    public override init() {
        super.init()
        fileType = 1
    }

    open func writeBrainWave(_ brainwave: BrainWaveData) throws {
        let bytes: Bytes = [Byte(brainwave.value / 256), Byte(brainwave.value % 256)]
        let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 2)
        do {
            try self.writeData(data)
        } catch {
            throw error
        }
    }
}
