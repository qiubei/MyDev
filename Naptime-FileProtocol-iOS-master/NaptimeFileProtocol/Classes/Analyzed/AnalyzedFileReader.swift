//
//  AnalyzedFileReader.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 16/8/24.
//  Copyright © 2016年 entertech. All rights reserved.
//

import Foundation

/// 分析后文件读取器
open class AnalyzedFileReader: DataFileReader {

    /// 序列化后的数据，AnalyzingData 的数组
    open var serializedData: [AnalyzingData] = []

    open override func loadFile(_ fileURL: URL) throws {
        do {
            try super.loadFile(fileURL)
            self.serializedData = self.serialize(self.data as Data)
        } catch {
            throw error
        }
    }

    /**
     分析后数据序列化

     - parameter data: 分析后文件的数据

     - returns: AnalyzingData 数组
     */
    fileprivate func serialize(_ data: Data) -> [AnalyzingData] {
        var analyzingDataArray: [AnalyzingData] = []
        let buffers = data.allBytes
        let splitedArray = buffers.splitBy(8)
        for item in splitedArray {
            guard item.count == 8 else {
                continue
            }
            let analyzingData = AnalyzingData(dataQuality: item[0],
                                              soundControl: item[1],
                                              awakeStatus: item[2],
                                              sleepStatusMove: item[3],
                                              restStatusMove: item[4],
                                              wearStatus: item[5])
            analyzingDataArray.append(analyzingData)
        }
        return analyzingDataArray
    }
}
