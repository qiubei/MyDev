//
//  Brainwave24Test.swift
//  NaptimeFileProtocol_Tests
//
//  Created by HyanCat on 14/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import NaptimeFileProtocol

class Brainwave24TestSpec: QuickSpec {

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

        describe("测试写入24位原始脑波文件") {

            let rawFileWriter = BrainwaveFileWriter<BrainwaveValue>()
            rawFileWriter.dataVersion = "3.0.0.0"

            it("1 创建文件") {
                try! rawFileWriter.createFile(rawFileURL)
                expect(rawFileWriter.protocolVersion) == "1.0"
            }

            it("2 writeBrainwave 写入数据") {
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xF0, 0xA3]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x01, 0x07, 0x62]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0x0D, 0x12]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xEB, 0x85]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }
                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 12
                expect(rawFileWriter.checksum) == 0x03+0xF0+0xA3+0x01+0x07+0x62+0x03+0x0D+0x12+0x03+0xEB+0x85
            }

            it("3 关闭文件，writeBrainwave 数据写入无效") {
                try! rawFileWriter.close()

                do {
                    let brainwave = BrainwaveData(value: BrainwaveValue(bytes: [0x03, 0xEB, 0x17]))
                    try! rawFileWriter.writeBrainwave(brainwave)
                }

                expect(rawFileWriter.headerLength) == 32
                expect(rawFileWriter.dataLength) == 12
                expect(rawFileWriter.checksum) == 0x03+0xF0+0xA3+0x01+0x07+0x62+0x03+0x0D+0x12+0x03+0xEB+0x85
            }
        }

        describe("测试读取原始脑波文件") {
            let rawFileReader = BrainwaveFileReader<BrainwaveValue>()
            it("读取文件") {
                try! rawFileReader.loadFile(rawFileURL)
                expect(rawFileReader.fileType) == 1
                expect(rawFileReader.dataVersion) == "3.0.0.0"
                expect(rawFileReader.headerLength) == 32
                expect(rawFileReader.dataLength) == 12
                expect(rawFileReader.checksum) == 0x03+0xF0+0xA3+0x01+0x07+0x62+0x03+0x0D+0x12+0x03+0xEB+0x85
            }
        }
    }

}
