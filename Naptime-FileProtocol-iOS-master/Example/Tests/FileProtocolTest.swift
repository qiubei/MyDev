//
//  FileProtocolTest.swift
//  NaptimeFileProtocol
//
//  Created by HyanCat on 16/8/25.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import NaptimeFileProtocol

class FileProtocolSpec: QuickSpec {
    override func spec() {
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileName = "test_\(Date().timeIntervalSince1970)"
        let rawFileURL = documentURL.appendingPathComponent(fileName + ".raw")
        let analyzedFileURL = documentURL.appendingPathComponent(fileName + ".analyzed")

        describe("测试写入原始脑波文件") {
            let rawFileWriter = BrainWaveFileWriter()
            rawFileWriter.dataVersion = "1.2.0.0"
            it("创建文件") {
                try! rawFileWriter.createFile(rawFileURL)
                expect(rawFileWriter.protocolVersion) == "1.0"
            }
            it("writeBrainWave 写入数据") {
                do {
                    let brainWave = BrainWaveData(value: 888)
                    try! rawFileWriter.writeBrainWave(brainWave)
                }
                do {
                    let brainWave = BrainWaveData(value: 263)
                    try! rawFileWriter.writeBrainWave(brainWave)
                }
                do {
                    let brainWave = BrainWaveData(value: 781)
                    try! rawFileWriter.writeBrainWave(brainWave)
                }
                do {
                    let brainWave = BrainWaveData(value: 1003)
                    try! rawFileWriter.writeBrainWave(brainWave)
                }
                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 8
                expect(rawFileWriter.checksum) == h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003)
            }

            //@qiubei
            it("writeData 写入数据") {
                do {
                    let brainwave = BrainWaveData(value: 888)
                    let bytes: Bytes = [Byte(brainwave.value / 256), Byte(brainwave.value % 256)]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 2)
                    try! rawFileWriter.writeData(data)
                }

                do {
                    let brainwave = BrainWaveData(value: 263)
                    let bytes: Bytes = [Byte(brainwave.value / 256), Byte(brainwave.value % 256)]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 2)
                    try! rawFileWriter.writeData(data)
                }

                do {
                    let brainwave = BrainWaveData(value: 781)
                    let bytes: Bytes = [Byte(brainwave.value / 256), Byte(brainwave.value % 256)]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 2)
                    try! rawFileWriter.writeData(data)
                }

                do {
                    let brainwave = BrainWaveData(value: 1003)
                    let bytes: Bytes = [Byte(brainwave.value / 256), Byte(brainwave.value % 256)]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 2)
                    try! rawFileWriter.writeData(data)
                }
                expect(rawFileWriter.headerLength).to(equal(32))
                expect(rawFileWriter.dataLength).to(equal(16))
                expect(rawFileWriter.checksum) == h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003) + h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003)
            }

            it("关闭文件,writeBrainWave 数据写入无效") {
                try! rawFileWriter.close()

                do {
                    let brainwave = BrainWaveData(value: 1003)
                    let bytes: Bytes = [Byte(brainwave.value / 256), Byte(brainwave.value % 256)]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 2)
                    try! rawFileWriter.writeData(data)
                }

                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 16
                expect(rawFileWriter.checksum) == h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003) + h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003)
            }

            it("关闭文件，writeData 数据写入无效") {
                //TODO： 问需不需要处理
//                try! rawFileWriter.close()

                do {
                    let brainWave = BrainWaveData(value: 1003)
                    try! rawFileWriter.writeBrainWave(brainWave)
                }

                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 16
                expect(rawFileWriter.checksum) == h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003) + h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003)
            }
        }

        describe("测试写入分析数据文件") { 
            let analyzedWriter = AnalyzedFileWriter()
            analyzedWriter.dataVersion = "1.3.0.0"
            it("创建文件") {
                try! analyzedWriter.createFile(analyzedFileURL)
                expect(analyzedWriter.protocolVersion) == "1.0"
            }
            it("writeAnalyzingData 写入数据") {
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

            it("writeData 写入文件") {
                do {
                    let bytes: Bytes = [10, 20, 10, 0, 5, 1, 0, 0]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
                    try! analyzedWriter.writeData(data)
                }
                do {
                    let bytes: Bytes = [20, 20, 10, 1, 0, 0, 0, 0]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
                    try! analyzedWriter.writeData(data)
                }
                do {
                    let bytes: Bytes = [30, 20, 10, 2, 5, 3, 0, 0]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
                    try! analyzedWriter.writeData(data)
                }
                do {
                    let bytes: Bytes = [40, 20, 10, 3, 0, 3, 0, 0]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
                    try! analyzedWriter.writeData(data)
                }
                do {
                    let bytes: Bytes = [50, 20, 10, 4, 0, 0, 0, 0]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
                    try! analyzedWriter.writeData(data)
                }

                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 80
                expect(analyzedWriter.checksum) == 1131
            }

            it("关闭文件 writeAnalyzingData 写入无效") {
                try! analyzedWriter.close()

                do {
                    let analyzingData = AnalyzingData(dataQuality: 2, soundControl: 2, awakeStatus: 0, sleepStatusMove: 99, restStatusMove: 32, wearStatus: 1)
                    try! analyzedWriter.writeAnalyzingData(analyzingData)

                }
                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 80
                expect(analyzedWriter.checksum) == 1131
            }

            it("关闭文件 writeData 写入无效") {
                do {
                    let bytes: Bytes = [50, 20, 10, 4, 0, 0, 0, 0]
                    let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: 8)
                    try! analyzedWriter.writeData(data)
                }

                expect(analyzedWriter.headerLength) == 32
                expect(analyzedWriter.dataLength) == 80
                expect(analyzedWriter.checksum) == 1131
            }
        }

        describe("测试读取原始脑波文件") {
            let rawFileReader = BrainWaveFileReader()
            it("读取文件") {
                try! rawFileReader.loadFile(rawFileURL)
                expect(rawFileReader.fileType) == 1
                expect(rawFileReader.dataVersion) == "1.2.0.0"
                expect(rawFileReader.headerLength) == 32
                expect(rawFileReader.dataLength) == 16
                expect(rawFileReader.checksum) == h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003) + h8(888)+l8(888)+h8(263)+l8(263)+h8(781)+l8(781)+h8(1003)+l8(1003)
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

        describe("Bad Case") {
            let invalideURL = documentURL.appendingPathComponent("TestInvalidateURL" + ".raw")
            let rawReader = BrainWaveFileReader()

            it ("读取无效文件") {
                expect {try rawReader.loadFile(invalideURL)}.to(throwError())
            }

            it("raw 文件没有内容") {
//                expect{ _ = rawReader.protocolVersion }.to(throwError())
            }

            it ("写入不存在的文件") {
                let analyzedWriter = AnalyzedFileWriter()
//                let analyzedURL = documentURL.appendingPathComponent("haha" + ".analyzed")

                do {
                    let data = Data(bytes: [1, 1, 3,1])
                    try! analyzedWriter.writeData(data)
                }
            }

        }

        afterSuite {
            // 删除测试文件
            try! FileManager.default.removeItem(at: rawFileURL)
            try! FileManager.default.removeItem(at: analyzedFileURL)
        }
    }
}

fileprivate func h8(_ num: UInt16) -> UInt16 {
    return num >> 8
}

fileprivate func l8(_ num: UInt16) -> UInt16 {
    return (num << 8) >> 8
}
