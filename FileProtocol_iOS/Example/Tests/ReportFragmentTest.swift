//
//  ReportFragmentTest.swift
//  NaptimeFileProtocol_Tests
//
//  Created by Anonymous on 2018/11/8.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Nimble
import Quick
import NaptimeFileProtocol


/*warning: Quick 的执行顺序是根据 decribe or it 文本内容中的d首字母的顺序执行的*/
/// 报表页的数据集合：文件内容主要用途是用来协助绘制曲线。
class ReportFragmentTest: QuickSpec {
    private let reportURL = FileManager.default.documentURL.appendingPathComponent("test.report")
    private let fromServerURL = Bundle.main.url(forResource: "2018-11-16-05-06-24", withExtension: "report")
    private let fromAndroidURL = Bundle.main.url(forResource: "2018-11-14-11-11-04", withExtension: "report")
    override func spec() {
        describe("Test Report File Operation") {
            let finishData = self.simulatorFinishData()
            let reportdata = self.simulatorReportData(finishData: finishData)
            let reportFileWriter = ReportFileWriter()
            guard let reportData = reportdata else { return }
            let fragment = ReportDataFragment()
            fragment.write(reportData: reportData)
            let length = reportData.data().count
            it("1 test fragment file") {
                assert(fragment.length == length, "fragment header length \(length)")
                print("fragment checksum is \(fragment.checksum) and timestamp is \(fragment.timestamp)")
                expect(fragment.flag) == .normal
            }

            it("2 Test wirte to report file") {
                do {
                    if FileManager.default.fileExists(atPath: self.reportURL.path) {
                        try! FileManager.default.removeItem(at: self.reportURL)
                    }
                    try reportFileWriter.createFile(self.reportURL)
                    do {
                        try reportFileWriter.writeReportData(fragment)
                        expect(reportFileWriter.protocolVersion) == "2.0"
                        expect(reportFileWriter.headerLength) == 32
                        expect(reportFileWriter.fileType) == 3
                    } catch {
                        assertionFailure("report file write failed")
                    }
                } catch {
                    assertionFailure("create report file error")
                }
            }

            it("3 Close file") {
                do {
                    try reportFileWriter.close()
                } catch {
                    print("-----\(error)")
                }
            }

            it("4 Test read to report file") {
                let reportFileReader = ReportFileReader()
                do {
                    try reportFileReader.loadFile(self.reportURL)
                } catch {
                    assertionFailure("read file failed")
                }
                // "check first fragment length (in this case there is only one fragment)"
                assert(reportFileReader.fragments.first!.length == length, "check first fragment length (in this case there is only one fragment)")
                // "check the Scalar element count in reportData"
                expect(reportFileReader.fragments.first!.reportData!.scalars.count) == 7
                // check the Digital element count in reportData
                expect(reportFileReader.fragments.first!.reportData!.digitals.count) == 2
            }

            it("5 Test read handle with server report file") {
                let reader = ReportFileReader()
                do {
                    guard let url = self.fromServerURL else {
                        assertionFailure("read server failed")
                        return
                    }
                    try reader.loadFile(url)
                    let report = reader.fragments.first!.reportData
                    // "check first fragment length (in this case there is only one fragment)"
                    assert(reader.fragments.first!.length == report!.data().count, "check first fragment length (in this case there is only one fragment)")
                    // "check the Scalar element count in reportData"
                    expect(reader.fragments.first!.reportData!.scalars.count) == 7
                    // check the Digital element count in reportData
                    expect(reader.fragments.first!.reportData!.digitals.count) == 2
                    var i = 0
                    for scalar in reader.fragments.first!.reportData!.scalars {
                        i += 1
                        expect(scalar.type.rawValue == UInt8(i)) == true
                        expect(scalar.value) != 0
                        print("Scalar type is \(scalar.type), and value is \(scalar.value)")
                    }

                    var j = 0
                    for digital in reader.fragments.first!.reportData!.digitals {
                        j += 1
                        expect(digital.type.rawValue == UInt8(240 + j)) == true
                        expect(digital.bodyDatas[10]) > 0
                    }
                } catch {
                    print(error)
                }
            }

            it ("6 Test read handle with Android report file") {
                let reader = ReportFileReader()
                do {
                    guard let url = self.fromAndroidURL else {
                        assertionFailure("read server failed")
                        return
                    }
                    try reader.loadFile(url)
                    let report = reader.fragments.first!.reportData
                    // "check first fragment length (in this case there is only one fragment)"
                    assert(reader.fragments.first!.length == report!.data().count, "check first fragment length (in this case there is only one fragment)")
                    // "check the Scalar element count in reportData"
                    expect(reader.fragments.first!.reportData!.scalars.count) == 8
                    // check the Digital element count in reportData
                    expect(reader.fragments.first!.reportData!.digitals.count) == 2

                    var i = 0
                    for scalar in reader.fragments.first!.reportData!.scalars {
                        i += 1
                        expect(scalar.type.rawValue == UInt8(i)) == true
                        expect(scalar.value) != 0
                        print("Scalar type is \(scalar.type), and value is \(scalar.value)")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    fileprivate func simulatorReportData(finishData: FinishData) -> ReportData? {
        let scoreScalar = Scalar(type: .score, value: UInt32(finishData.sleepScore))
        let sleepedScalar = Scalar(type: .sleeped, value: UInt32(finishData.sleepPoint))
        let wakeupScalar = Scalar(type: .wakeup, value: UInt32(finishData.alarmPoint))
        let soberScalar = Scalar(type: .soberLevel, value: UInt32(finishData.soberLevelPoint))
        let blurryScalar = Scalar(type: .blurryLevel, value: UInt32(finishData.blurrLevelPoint))
        let sleepScalar = Scalar(type: .sleepedLeved, value: UInt32(finishData.sleepLevelPoint))
        let timeInterval = Scalar(type: .intervalTime, value: UInt32(8000))

        guard let data = finishData.sleepCurveData else { assertionFailure("sleep curve data is nil");  return nil}
        guard let sleepStateData = finishData.sleepStateData else { assertionFailure("sleep state data is nil"); return nil}
        let curveDigital = Digital(type: .napCurve, length: UInt32(data.count), data: data)
        let stateDigital = Digital(type: .napState, length: UInt32(sleepStateData.count), data: sleepStateData)

        var scalars = [Scalar]()
        var digitals = [Digital]()
        scalars.append(scoreScalar)
        scalars.append(sleepedScalar)
        scalars.append(wakeupScalar)
        scalars.append(soberScalar)
        scalars.append(blurryScalar)
        scalars.append(sleepScalar)
        scalars.append(timeInterval)
        digitals.append(curveDigital)
        digitals.append(stateDigital)
        return ReportData(scalars: scalars, digitals: digitals)
    }

    fileprivate func simulatorFinishData() -> FinishData {
        let sleepScore = 89
        let soberDuration = 300.0
        let blurrDuration = 350.0
        let sleepDuration = 666.0
        let sleepLatency = 1316.0
        let sleepPoint = 60
        let alarmPoint = 100
        let soberLevelPoint = 88
        let blurrLevelPoint = 70
        let sleepLevelPoint = 44
        let sleepStateData = self.simulatorSleepStateData()
        let sleepCurveData = self.simulatorSleepCurveData()

        return FinishData(sleepScore: UInt8(sleepScore),
                          sleepLatency: sleepLatency,
                          soberDuration: soberDuration,
                          blurrDuration: blurrDuration,
                          sleepDuration: sleepDuration,
                          sleepPoint: UInt8(sleepPoint),
                          alarmPoint: UInt8(alarmPoint),
                          soberLevelPoint: UInt8(soberLevelPoint),
                          blurrLevelPoint: UInt8(blurrLevelPoint),
                          sleepLevelPoint: UInt8(sleepLevelPoint),
                          sleepStateData: sleepStateData,
                          sleepCurveData: sleepCurveData)
    }

    let TestDigitalDataLength = 160
    fileprivate func simulatorSleepStateData() -> Data {
        var bytes = [UInt8]()
        while bytes.count <= TestDigitalDataLength {
            let element = [0x00, 0x01, 0x02].randomElement()!
            let index = [8, 9, 10].randomElement()!
            for _ in 1...index {
                bytes.append(UInt8(element))
            }
        }
        return Data(bytes: bytes)
    }

    fileprivate func simulatorSleepCurveData() -> Data {
        var bytes = [UInt8]()
        while bytes.count <= TestDigitalDataLength {
            let element = [60...100].randomElement()!
            let index = [8, 9, 10].randomElement()!
            for _ in 1...index {
                bytes.append(UInt8(element.randomElement()!))
            }
        }
        return Data(bytes: bytes)
    }

    fileprivate struct FinishData {
        public internal(set) var sleepScore: UInt8
        public internal(set) var sleepLatency: Double
        public internal(set) var soberDuration: Double
        public internal(set) var blurrDuration: Double
        public internal(set) var sleepDuration: Double
        public internal(set) var sleepPoint: UInt8
        public internal(set) var alarmPoint: UInt8
        public internal(set) var soberLevelPoint: UInt8
        public internal(set) var blurrLevelPoint: UInt8
        public internal(set) var sleepLevelPoint: UInt8
        public internal(set) var sleepStateData: Data?
        public internal(set) var sleepCurveData: Data?
    }
}
