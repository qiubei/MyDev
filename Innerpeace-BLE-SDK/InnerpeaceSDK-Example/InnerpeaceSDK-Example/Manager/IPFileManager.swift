//
//  IPFileManager.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/8/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation
import Files
//import NaptimeFileProtocol

extension Date {
    var toFileName: String {
        let fileFormatter = DateFormatter()
        fileFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return fileFormatter.string(from: self)
    }
}

extension DispatchQueue {
    static let file = DispatchQueue(label: "cn.entertech.NaptimeBLE.file")
}

extension FileManager {
    var dataDirectory: URL {
        let document = FileSystem(using: .default).documentFolder!
        try! document.createSubfolderIfNeeded(withName: "data")
        return URL(fileURLWithPath: try! document.subfolder(named: "data").path)
    }

    func fileURL(fileName: String) -> URL {
        return dataDirectory.appendingPathComponent("\(fileName).raw")
    }
}

class IPFileManager {

    static let shared = IPFileManager()

    private init() {}

//    private var _writer:  BrainwaveFileWriter<BrainwaveValue24>?
    private var fileHandle: FileHandle?

    private (set) var fileName: String?

    func create() {
        DispatchQueue.file.async { [unowned self] in

            let fileName = Date().toFileName
            let fileURL = FileManager.default.fileURL(fileName: fileName)
            self.fileName = fileName

            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path,
                                               contents: nil,
                                               attributes: nil)
            }
            self.fileHandle = try? FileHandle(forWritingTo: fileURL)
//            self._writer = BrainwaveFileWriter<BrainwaveValue24>()
////            self._writer?.protocolVersion = "2.0"
//            self._writer?.dataVersion = "3.0.0.0"
//            try? self._writer?.createFile(fileURL)
        }
    }

    func save(data: Data) {
        DispatchQueue.file.async { [unowned self] in
            self.fileHandle?.seekToEndOfFile()
            self.fileHandle?.write(data)
            self.fileHandle?.synchronizeFile()
//            let allBytes = data.copiedBytes
//            allBytes.splitBy(3).forEach({ bytes in
//                let brainwaveData = BrainwaveData(value: BrainwaveValue24(bytes: bytes))
//                try? self._writer?.writeBrainwave(brainwaveData)
//            })
        }
    }

    func close() {
        DispatchQueue.file.async { [unowned self] in
            self.fileHandle?.closeFile()
//            try? self._writer?.close()
//            self._writer = nil
            self.fileName = nil
        }
    }
}

extension IPFileManager {

    var audioPath: String {
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let audioPath = filePath + "/Audio"
        if !FileManager.default.fileExists(atPath: audioPath) {
            try! FileManager.default.createDirectory(atPath: audioPath, withIntermediateDirectories: true, attributes: nil)
        }
        return audioPath
    }

    func copyAt(url: URL) -> String {
        let filename = Date().toFileName + ".wav"
        let filePath = self.audioPath + "/\(filename)"
//        DispatchQueue.file.async {
//        }
        do {
            try FileManager.default.copyItem(at: url, to: URL(fileURLWithPath: filePath))
        } catch{
            print("copy audio file error! \(error)")
        }
        return filePath
    }
}

extension IPFileManager {
    private var reportPath: String {
        return NSHomeDirectory() + "/Documents/report.plist"
    }

    func writeReport(dic: NSDictionary) {
        if !FileManager.default.fileExists(atPath: reportPath) {
            FileManager.default.createFile(atPath: reportPath, contents: nil, attributes: nil)
        }
        let url = URL(fileURLWithPath: reportPath)
        if let mutableList = NSMutableArray(contentsOfFile: reportPath) {
            mutableList.add(dic)
            mutableList.write(to: url, atomically: true)
        } else {
            let mDic = NSMutableArray()
            mDic.add(dic)
            mDic.write(to: url, atomically: true)
        }
    }

    func readReport() -> NSArray? {
        if FileManager.default.fileExists(atPath: reportPath) {
            let reportArray = NSArray(contentsOfFile: reportPath)
            return reportArray
        } else {
            print("read failed: no report file")
            return nil
        }
    }
}

extension Array {
    func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map { startIndex in
            let endIndex = Swift.min(startIndex.advanced(by: subSize), self.count)
            return Array(self[startIndex ..< endIndex])
        }
    }
}
