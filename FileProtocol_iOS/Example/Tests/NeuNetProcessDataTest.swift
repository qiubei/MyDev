//
//  NeuNetProcessDataTest.swift
//  NaptimeFileProtocol_Tests
//
//  Created by Anonymous on 2018/9/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble

class NeuNetProcessDataTest: QuickSpec {

    override func spec() {
        let writer = AnalyzedFileWriterV2()
        let reader = AnalyzedFileReaderV2()
        let fileName = "test_\(Date().timeIntervalSince1970)"
        let fileURL = FileManager.default.documentURL.appendingPathComponent(fileName + ".analyzed")
        let example = NeuNetProcessData(mlpDegree: 81,
                                        napDegree: 85,
                                        sleepState: 2,
                                        dataQuality: 2,
                                        soundControl: 1)
        let analyzed = AnalyzedFragment()
        analyzed.write(analyzingData: example)
        analyzed.write(analyzingData: example)
        analyzed.write(analyzingData: example)
        analyzed.write(analyzingData: example)
        analyzed.write(analyzingData: example)
        beforeEach {
            print("this is before each ++++++ ")
        }

        describe("Test write Neural Network Process Data file") {
            print("i'm in the testing, ******")

            context("1 开始测试") {
                it("test") {
                    do {
                        try writer.createFile(fileURL)
                    } catch {
                        assert(false, "create analyzed file failed")
                    }
                }
            }
            context("2 测试写入神经网络的分析后数据文件") {
                it("test") {
                    do {
                        try writer.write(fragment: analyzed)
                        expect(writer.protocolVersion) == "2.0"

                        expect(writer.dataLength) == 56

                        try writer.write(fragment: analyzed)
                        expect(writer.dataLength) == 112
                    } catch {
                        assert(false, "write neural netwrok process data failed")
                    }
                }
            }

            context("3 测试关闭文件") {
                it("test") {
                    try! writer.close()
                    do {
                        try writer.write(fragment: analyzed)
                        expect(writer.dataLength) == 112
                    } catch {
                        assert(true, "writer close testcase pass")
                    }
                }
            }

            context("4 Test read Neural network Process Data file") {
                it("test") {
                    do {
                        try reader.loadFile(fileURL)
                        expect(reader.protocolVersion) == "2.0"
                        let fragments = reader.fragments
                        expect(fragments.count) == 2
                        expect(fragments.first?.analyzedDatas.count) == 5
                    } catch {
                        print("file erro \(error)")
                        assert(false, "read file failed")
                    }
                }
            }

            context("5 结束测试") {
                it("test") {
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                    } catch {
                        assert(false, "关闭文件失败")
                    }
                }
            }


        }

        afterEach {
            print("test is ending----------")
        }
    }
}
