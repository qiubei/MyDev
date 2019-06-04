//
//  AnalyzedFileWriter.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 16/8/24.
//  Copyright © 2016年 entertech. All rights reserved.
//

import Foundation

/// 分析后文件写工具
open class AnalyzedFileWriter: DataFileWriter {

    public override init() {
        super.init()
        fileType = 2
    }

    open func writeAnalyzingData(_ analyzingData: AnalyzingData) throws {
        let bytes: Bytes = [analyzingData.dataQuality,
                            analyzingData.soundControl,
                            analyzingData.awakeStatus,
                            analyzingData.sleepStatusMove,
                            analyzingData.restStatusMove,
                            analyzingData.wearStatus,
                            0,
                            0]
        let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
        do {
            try self.writeData(data)
        } catch {
            throw error
        }
    }
}
