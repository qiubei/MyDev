//
//  BrainwaveV2ProtocolTest.swift
//  NaptimeFileProtocol_Tests
//
//  Created by HyanCat on 25/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import NaptimeFileProtocol

class BrainwaveV2ProtocolTest: QuickSpec {

    typealias BrainwaveValue = BrainwaveValue24

    override func spec() {
        let fileName = "test_\(Date().timeIntervalSince1970)"
        let rawFileURL = FileManager.default.documentURL.appendingPathComponent(fileName + ".raw")

        beforeSuite {

        }

        afterSuite {
            // 删除测试文件
            try? FileManager.default.removeItem(at: rawFileURL)
        }

        describe("测试写入分片数据") {
            let rawFileWriter = BrainwaveFileWriterV2<BrainwaveValue>()
            rawFileWriter.dataVersion = "3.0.0.0"

            it("1 创建文件") {
                try! rawFileWriter.createFile(rawFileURL)
                expect(rawFileWriter.protocolVersion) == "2.0"
            }

            it("2 writeBrainwave 写入数据") {
                do {
                    do {
                        let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xF0, 0xA3]))
                        let pieceData = BrainwaveFragment<BrainwaveValue24>()
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        try! rawFileWriter.write(fragment: pieceData)
                    }

                    do {
                        let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x11, 0x23, 0x41]))
                        let pieceData = BrainwaveFragment<BrainwaveValue24>()
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        try! rawFileWriter.write(fragment: pieceData)
                    }

                    do {
                        let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x11, 0x23, 0x41]))
                        let pieceData = BrainwaveFragment<BrainwaveValue24>()
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        pieceData.write(brainwave: brainwave)
                        try! rawFileWriter.write(fragment: pieceData)
                    }
                }
            }

            it("3 关闭文件") {
                // 关闭文件
                try! rawFileWriter.close()
            }

            it("4 readBrainwave 读取数据") {
                do {
                    let rawFileReader = BrainwaveFileReaderV2<BrainwaveValue>()
                    try! rawFileReader.loadFile(rawFileURL)
                    expect(rawFileReader.protocolVersion) == "2.0"
                    expect(rawFileReader.dataVersion) == "3.0.0.0"
                    expect(rawFileReader.dataLength) == 120
                }
            }
        }
    }

}
