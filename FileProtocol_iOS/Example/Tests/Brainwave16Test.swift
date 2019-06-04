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

class Brainwave16TestSpec: QuickSpec {

    typealias BrainwaveValue = BrainwaveValue16

    override func spec() {
        let fileName = "test_\(Date().timeIntervalSince1970)"
        let rawFileURL = FileManager.default.documentURL.appendingPathComponent(fileName + ".raw")

        beforeSuite {

        }

        afterSuite {
            // 删除测试文件
            try? FileManager.default.removeItem(at: rawFileURL)
        }

        describe("测试写入16位原始脑波文件") {

            let rawFileWriter = BrainwaveFileWriter<BrainwaveValue>()
            rawFileWriter.dataVersion = "2.0.0.0"

            it("1 创建文件") {
                try! rawFileWriter.createFile(rawFileURL)
                expect(rawFileWriter.protocolVersion) == "1.0"
            }

            it("2 writeBrainwave 写入数据") {
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xF0]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x01, 0x07]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0x0D]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xEB]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 8
                expect(rawFileWriter.checksum) == 0x03+0xF0+0x01+0x07+0x03+0x0D+0x03+0xEB
            }

            it("3 关闭文件，writeBrainwave 数据写入无效") {
                try! rawFileWriter.close()

                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xEB]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }

                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 8
                expect(rawFileWriter.checksum) == 0x03+0xF0+0x01+0x07+0x03+0x0D+0x03+0xEB
            }
        }

        describe("测试读取原始脑波文件") {
            let rawFileReader = BrainwaveFileReader<BrainwaveValue>()
            it("读取文件") {
                try! rawFileReader.loadFile(rawFileURL)
                expect(rawFileReader.fileType) == 1
                expect(rawFileReader.dataVersion) == "2.0.0.0"
                expect(rawFileReader.headerLength) == 32
                expect(rawFileReader.dataLength) == 8
                expect(rawFileReader.checksum) == 0x03+0xF0+0x01+0x07+0x03+0x0D+0x03+0xEB
            }
        }

        describe("Bad Case") {
            let invalideURL = FileManager.default.documentURL.appendingPathComponent("TestInvalidateURL.raw")
            let rawReader = BrainwaveFileReader<BrainwaveValue>()

            it ("读取无效文件") {
                expect { try rawReader.loadFile(invalideURL) }.to(throwError())
            }
        }
    }
}
