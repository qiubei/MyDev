//
//  AnalyzedDataTest.swift
//  NaptimeFileProtocol_Tests
//
//  Created by HyanCat on 14/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import NaptimeFileProtocol

class AnalyzedDataTestSpec: QuickSpec {

    override func spec() {

        let fileName = "test_\(Date().timeIntervalSince1970)"
        let analyzedFileURL = FileManager.default.documentURL.appendingPathComponent(fileName + ".analyzed")

        afterSuite {
            // 删除测试文件
            try? FileManager.default.removeItem(at: analyzedFileURL)
        }

        describe("测试写入分析数据文件") {
            let analyzedWriter = AnalyzedFileWriter()
            analyzedWriter.dataVersion = "1.3.0.0"
            it("1 创建文件") {
                try! analyzedWriter.createFile(analyzedFileURL)
                expect(analyzedWriter.protocolVersion) == "1.0"
            }
            it("2 writeAnalyzingData 写入数据") {
                do {
                    let analyzingData = AnalyzingData(dataQuality: 0, soundControl: 0, awakeStatus: 0, sleepStatusMove: 80, restStatusMove: 73, wearStatus: 0)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)
                }
                do {
                    let analyzingData = AnalyzingData(dataQuality: 1, soundControl: 0, awakeStatus: 0, sleepStatusMove: 78, restStatusMove: 81, wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)
                }
                do {
                    let analyzingData = AnalyzingData(dataQuality: 1, soundControl: 1, awakeStatus: 0, sleepStatusMove: 68, restStatusMove: 95, wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)
                }
                do {
                    let analyzingData = AnalyzingData(dataQuality: 2, soundControl: 1, awakeStatus: 0, sleepStatusMove: 96, restStatusMove: 88, wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)
                }
                do {
                    let analyzingData = AnalyzingData(dataQuality: 2, soundControl: 2, awakeStatus: 0, sleepStatusMove: 99, restStatusMove: 32, wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)
                }
                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 40
                expect(analyzedWriter.checksum) == 804
            }

            it("3 writeData 写入文件") {
                do {
                    let data = AnalyzingData(dataQuality: 10,
                                             soundControl: 20,
                                             awakeStatus: 10,
                                             sleepStatusMove: 0,
                                             restStatusMove: 5,
                                             wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(data)
                }
                do {
                    let data = AnalyzingData(dataQuality: 20,
                                             soundControl: 20,
                                             awakeStatus: 10,
                                             sleepStatusMove: 1,
                                             restStatusMove: 0,
                                             wearStatus: 0)
                    try! analyzedWriter.writeAnalyzingData(data)
                }
                do {
                    let data = AnalyzingData(dataQuality: 30,
                                             soundControl: 20,
                                             awakeStatus: 10,
                                             sleepStatusMove: 2,
                                             restStatusMove: 5,
                                             wearStatus: 3)
                    try! analyzedWriter.writeAnalyzingData(data)
                }
                do {
                    let data = AnalyzingData(dataQuality: 40,
                                             soundControl: 20,
                                             awakeStatus: 10,
                                             sleepStatusMove: 3,
                                             restStatusMove: 0,
                                             wearStatus: 3)
                    try! analyzedWriter.writeAnalyzingData(data)
                }
                do {
                    let data = AnalyzingData(dataQuality: 50,
                                             soundControl: 20,
                                             awakeStatus: 10,
                                             sleepStatusMove: 4,
                                             restStatusMove: 0,
                                             wearStatus: 0)
                    try! analyzedWriter.writeAnalyzingData(data)
                }

                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 80
                expect(analyzedWriter.checksum) == 1131
            }

            it("4 关闭文件 writeAnalyzingData 写入无效") {
                try! analyzedWriter.close()

                do {
                    let analyzingData = AnalyzingData(dataQuality: 2, soundControl: 2, awakeStatus: 0, sleepStatusMove: 99, restStatusMove: 32, wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)

                }
                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 80
                expect(analyzedWriter.checksum) == 1131
            }

            it("5 关闭文件 writeData 写入无效") {
                do {
                    let data = AnalyzingData(dataQuality: 50,
                                             soundControl: 20,
                                             awakeStatus: 10,
                                             sleepStatusMove: 4,
                                             restStatusMove: 0,
                                             wearStatus: 0)
                    try! analyzedWriter.writeAnalyzingData(data)
                }

                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 80
                expect(analyzedWriter.checksum) == 1131
            }
        }

        describe("测试读取分析数据文件") {
            let analyzedReader = AnalyzedFileReader()
            it("读取文件") {
                try! analyzedReader.loadFile(analyzedFileURL)
                expect(analyzedReader.fileType) == 2
                expect(analyzedReader.dataVersion) == "1.3.0.0"
                expect(analyzedReader.headerLength) == 32
                expect(analyzedReader.dataLength) == 80
                expect(analyzedReader.checksum) == 1131
            }
        }
    }
    
}
