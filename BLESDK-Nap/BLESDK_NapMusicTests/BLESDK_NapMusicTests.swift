//
//  BLESDK_NapMusicTests.swift
//  BLESDK_NapMusicTests
//
//  Created by Anonymous on 2018/10/19.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import XCTest
import BLESDK_NapMusic

class BLESDK_NapMusicTests: XCTestCase {


    private var testBundle: Bundle?
    private var rawPath: String?
    private var rawFileHandle: FileHandle?
    private var analyzedPath: String?
    private var fileHandle: FileHandle?
    private let queue = DispatchQueue(label: "com.enter.nap.test.queue")
    override func setUp() {
        testBundle = Bundle(for: type(of: self))
        rawPath = self.testBundle?.path(forResource: "test", ofType: "raw")
        analyzedPath = NSTemporaryDirectory() + "/test.analyzed"
//        FileManager.default.createFile(atPath: rawPath!, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: analyzedPath!, contents: nil, attributes: nil)
//        self.rawFileHandle = FileHandle(forWritingAtPath: rawPath!)
        self.fileHandle = FileHandle(forWritingAtPath: self.analyzedPath!)
        self.loadRawData()
        self.createAnalyzedFile()
    }

    override func tearDown() {
        self.rawFileHandle?.closeFile()
        self.fileHandle?.closeFile()
    }

    func testPushData()  {
        self.loadRawData()
    }

    func testFinishHandle() {
//        guard let analyzeddata = self.praseAnalzedFiles() else { return }
//        NapMusic.caculateSleepCurve(analyzedData: analyzeddata) { (result) in
//            print("result is \(result)")
//        }
    }

    private func loadRawData() {
        guard let `rawPath` = rawPath else {
            XCTAssert(false, "文件错误")
            return
        }

        if let data = try? Data(contentsOf: URL(fileURLWithPath: rawPath)) {
            NapMusic.start()
            for i in 48 ..< data.count {
                guard (i+749) < data.count else { return }
                if (i > 0) && (i % 750 == 0) {
                    let subData = data.subData(in: i ... i+749)
                    NapMusic.push(rawData: subData, processBlock: { (processData) in
                        print("Test: \(String(describing: Thread.current.name)) -- \(processData)")
                    }, musicBlock: { (musicProcess) in
                        print("Test: \(String(describing: Thread.current.name)) -- \(musicProcess)")
                    })
//                    queue.async {
//                    }
                }
            }
        }
    }

    private func praseAnalzedFiles()-> Data? {
        let url = URL(fileURLWithPath: self.analyzedPath!)
        return try? Data(contentsOf: url)
    }

    private func createAnalyzedFile() {
        guard let `testBundle` = testBundle else { return }
        do {
            let sleepStateString = try String(contentsOfFile: testBundle.path(forResource: "common_sleep_state", ofType: "txt")!)
            let soundControlString = try String(contentsOfFile: testBundle.path(forResource: "common_sound_control", ofType: "txt")!)
            let dataQualityString = try String(contentsOfFile: testBundle.path(forResource: "common_data_quality", ofType: "txt")!)
            let mlpDegreeString = try String(contentsOfFile: testBundle.path(forResource: "common_mlp_degree", ofType: "txt")!)

            var sleepStates = [UInt8]()
            var soundControls = [UInt8]()
            var dataQualities = [UInt8]()
            var mlpDegrees = [UInt8]()
            for value in sleepStateString.split(separator: "\n") {
                let va = (Int(value) == -1) ? 255 : Int(value)!
                sleepStates.append(UInt8(va))
            }
            for value in soundControlString.split(separator: "\n") {
                soundControls.append(UInt8(value)!)
            }

            for value in dataQualityString.split(separator: "\n") {
                dataQualities.append(UInt8(value)!)
            }

            for value in mlpDegreeString.split(separator: "\n") {
                let va = Double(value)! * 255
                mlpDegrees.append(UInt8(va))
            }
            for i in 0 ..< sleepStates.count {
                let byte = [mlpDegrees[i],
                            0,
                            sleepStates[i],
                            dataQualities[i],
                            soundControls[i],
                            0,
                            0,
                            0]
                let data = Data(bytes: byte)
                fileHandle?.write(data)
                fileHandle?.seekToEndOfFile()
            }
        } catch {
            print("read txt file error: \(error)")
        }
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension Data {
    func subData(in range: ClosedRange<Int>) -> Data {

        return subdata(in: Index(range.lowerBound) ..< Index(range.upperBound+1))
    }
}

public struct NoteCommand: Command {
    public private (set) var duration: TimeInterval
    public let instrument: UInt8
    public let pitch: UInt64
    public let pan: Float
}

extension NapMusic.NapProcessData: CustomStringConvertible {
    public var description: String {
        return """
        mlpDegree: \(mlpDegree)
        napDegree: \(napDegree)
        sleepState: \(sleepState)
        dataQuality: \(dataQuality)
        soundControl: \(soundControl)
        smooth-count: \(smoothRawData?.count)
        """
    }
}

extension NapMusic.SleepCommand: CustomStringConvertible {
    public var description: String {
        return """
        duration: \(duration)
        """
    }
}

extension NapMusic.NoteCommand: CustomStringConvertible {
    public var description: String {
        return """
        duration: \(duration)
        instrument: \(duration)
        pitch: \(pitch)
        pan: \(pan)
        """
    }
}
public enum Status: UInt8 {
    case unwear = 0
    case generating
    case playing
    case warming
    case stopped
}

extension NapMusic.Status: CustomStringConvertible {
    public var description: String {
        let string: String
        switch self {
        case .unwear:
            string = "unwear"
        case .generating:
            string = "generating"
        case .playing:
            string = "playing"
        case .warming:
            string = "warming"
        case .stopped:
            string = "stopped"
        }
        return string
    }
}

extension NapMusic.NapMusicCommand: CustomStringConvertible {
    public var description: String {
        return """
        sleepDuration: \(sleepCommand)
        noteNumber: \(noteCommands)
        status: \(status)
        """
    }
}

extension NapMusic.NapFinishData: CustomStringConvertible {
    public var description: String {
        return """
        sleepscroe: \(sleepScore)
        sleepLatency: \(sleepLatency)
        soberDuration:\(soberDuration)
        blurrDuration: \(blurrDuration)
        sleepDuration: \(sleepDuration)
        sleepPoint: \(sleepPoint)
        alarmPoint: \(alarmPoint)
        soberLevelPoint: \(soberLevelPoint)
        blurrLevelPoint: \(blurrLevelPoint)
        sleepLevelPoint: \(sleepLevelPoint)
        """
    }
}
