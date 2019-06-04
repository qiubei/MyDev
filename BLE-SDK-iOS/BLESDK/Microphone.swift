//
//  Microphone.swift
//  BLESDK
//
//  Created by Anonymous on 2018/7/27.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import AVFoundation
import BLESDK_Microphone
import Foundation

let kPeridicityDuration = 30.0
let kAudioDataLengthPerMinute = 22050 * 60 // 一分钟的音频数据长度
let kAudioInputBufferLength = 22050  // 1秒钟的音频数据长度


public enum MicrophoneState {
    case unPermission
    case recording
    case other
}


typealias AudioUnitInputBlock = (UnsafeMutablePointer<AudioBufferList>?)->()
/// 对 sleep 算法了一些封装：算法调用和录音相关逻辑。
public final class Microphone {

    public init() {
    
    }

    private var isRecording = false
    /// 麦克风状态
    public var state: MicrophoneState {
        var _state: MicrophoneState = .other
        AVCaptureDevice.requestAccess(for: .audio) { (granted) in
            if !granted {
                _state = MicrophoneState.unPermission
            } else {
                _state = self.isRecording ? MicrophoneState.recording : MicrophoneState.other
            }
        }
        return _state
    }

    /// 体验过程中的 pcm 数据文件路径
    public var pcmAudioURL: URL {
        return URL(fileURLWithPath: audioPath)
    }

    /// 设置闹钟参数
    ///
    /// - Parameters:
    ///   - isWithinPeriod: 是否在设置的闹钟区间内
    ///   - alarmPeriodLen: 闹钟区间长度
    public func setAlarmConfig(_ isWithinPeriod: Bool, _ alarmPeriodLen: Double) {
        let alarmSet = AlarmSet(alarmPeriodFlag: ObjCBool(isWithinPeriod), alarmPeriodLen: alarmPeriodLen)
        Sleep.setAlarm(alarmSet: alarmSet)
    }

    private var timer: Timer?
    /// 开启算法
    public func start() throws {
        if self.state == .unPermission {
            throw InnerpeaceError.invalid(message: "没有开启麦克风权限，晚睡无法使用")
        }
        self.clearTempRecorderFile(offsetData: nil)
        self.clearAudioFile()

        Sleep.start()
        XBEchoCancellation.shared()?.startService()
        self.handleEcho()
        XBEchoCancellation.shared()?.startInput()
        // 去除由于 timer 不准导致
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            if self.timer == nil {
                self.timer = Timer(timeInterval: kPeridicityDuration,
                                   target: self,
                                   selector: #selector(self.periodicSchedule(timer:)),
                                   userInfo: nil,
                                   repeats: true)
                RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
            }
        }
    }

    private var algorhimInterval = Date().timeIntervalSince1970
    /// 结束晚睡算法，并通过回调获取算法结果
    ///
    /// - Parameter napAnalyzedDatas: 小睡算法实时分析的结果列表；如果参数为 nil 说明只有麦克风算法，否者为晚睡（麦克风 + 小睡）算法。
    public func end(napAnalyzedDatas: Array<Sleep.NapAnalyzedProcessData>? = nil) {
        algorhimInterval = Date().timeIntervalSince1970
        if let array = napAnalyzedDatas {
            Sleep.finish(napAnalyzedResults: array) { (result) in
                DLog("algrothm consume time: \(Date().timeIntervalSince1970 - self.algorhimInterval)")
                NotificationName.sleepFinishResult.emit([NotificationKey.sleepFinishResultKey: result])
            }
        } else {
            Sleep.finish { (result) in
                DLog("algrothm consume time: \(Date().timeIntervalSince1970 - self.algorhimInterval)")
                NotificationName.sleepFinishResult.emit([NotificationKey.sleepFinishResultKey: result])
            }
        }
        DLog("before globe: \(Date().timeIntervalSince1970 - self.algorhimInterval)")
        XBEchoCancellation.shared()?.stop()
        XBEchoCancellation.shared()?.stopInput()
        DLog("after globe: \(Date().timeIntervalSince1970 - self.algorhimInterval)")
        self.timer?.invalidate()
        self.timer = nil
        self.isRecording = false
        self.clear()
        DLog("after clear: \(Date().timeIntervalSince1970 - self.algorhimInterval)")
    }

    private func clear() {
        self.dataPool.dry()
        self.queue.async {
            self.tempFileLock.lock()
            self.tempFileHandler?.closeFile()
            self.tempFileHandler = nil
//            self.fileHandle?.closeFile()
//            self.fileHandle = nil
            self.tempFileLock.unlock()
            if FileManager.default.fileExists(atPath: self.tempPath) {
                try? FileManager.default.removeItem(atPath: self.tempPath)
            }
        }
    }

    private var _state: MicrophoneState = .other
    /// 每 1 分钟的临时录音文件路径
    private let tempPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                          .userDomainMask,
                                                                          true).first! + "/tmpRecord.wav"
    private let audioPath: String = {
        let headerName = Date().stringWith(formateString: "MM-dd-HH-mm")
        return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                   FileManager.SearchPathDomainMask.userDomainMask,
                                                   true).first! + "/record.pcm"
    }()


    var lastIntreval = Date().timeIntervalSince1970
    /// 周期性调用晚睡算法内容
    ///
    /// - Parameter timer: 附带参数
    @objc
    private func periodicSchedule(timer: Timer) {
        let url = URL(fileURLWithPath: self.tempPath)
        self.handlePeriodicData(audioDataURL: url)
        DLog("1 min interval: \(Date().timeIntervalSince1970 - lastIntreval)")
        lastIntreval = Date().timeIntervalSince1970
    }

    /// 清除 1 分钟的录音数据, 如果上一分钟的数据还有剩余，先写入临时文件后开始音频数据监听
    ///
    /// - Parameter offsetData: 上一分钟剩余数据
    private func clearTempRecorderFile(offsetData: Data?) {
        if FileManager.default.fileExists(atPath: tempPath) {
            self.tempFileLock.lock()
            self.tempFileHandler = nil
            let url = URL(fileURLWithPath: self.tempPath)
            try? FileManager.default.removeItem(at: url)
            FileManager.default.createFile(atPath: self.tempPath, contents: nil, attributes: nil)
            self.tempFileHandler = try? FileHandle(forWritingTo: url)
            if let data = offsetData {
                self.tempFileHandler?.write(data)
            }
            self.tempFileLock.unlock()
            XBEchoCancellation.shared()?.startInput()
            DLog("temp file remove and create")
        }
    }

    private func clearAudioFile() {
        if FileManager.default.fileExists(atPath: audioPath) {
            self.tempFileLock.lock()
            self.tempFileHandler = nil
            self.tempFileLock.unlock()
            
            let url = URL(fileURLWithPath: self.audioPath)
            try? FileManager.default.removeItem(at: url)
//            FileManager.default.createFile(atPath: self.audioPath, contents: nil, attributes: nil)
            DLog("auido file remove and create")
        }
    }

    private var tempFileHandler: FileHandle?
//    private var fileHandle: FileHandle?i
    private var dataPool = AudioDataPool()
    private let queue = DispatchQueue(label: "com.write.queue")
    private let tempFileLock = NSLock()
    /// 回调获取噪声处理后数据，并写入文件中
    private func handleEcho() {
        if XBEchoCancellation.shared()?.bl_input == nil {
            let inputBlock: AudioUnitInputBlock = { audioList in
                self.isRecording = true
                if let inputDataPtr = UnsafeMutableAudioBufferListPointer(audioList) {
                    let buffer : AudioBuffer = inputDataPtr[0]
                    if let data = buffer.mData {
                        let handleData = Data(bytesNoCopy: data, count: Int(buffer.mDataByteSize), deallocator: .none)
                        self.dataPool.push(data: handleData)
                        if let _ = self.tempFileHandler {
                            if self.dataPool.count > 22050*10 {
                                DLog("datapool count \(self.dataPool.count)")
                                let tempdata = self.dataPool.pop(length: 22050*10)
                                self.queue.async {
                                    self.tempFileLock.lock()
                                    self.tempFileHandler?.seekToEndOfFile()
                                    self.tempFileHandler?.write(tempdata)
                                    self.tempFileHandler?.synchronizeFile()
//                                    self.fileHandle?.seekToEndOfFile()
//                                    self.fileHandle?.write(tempdata)
//                                    self.fileHandle?.synchronizeFile()
                                    self.tempFileLock.unlock()
                                }
                            }
                        } else {
                            let tempURL = URL(fileURLWithPath: self.tempPath)
                            do {
                                if !FileManager.default.fileExists(atPath: self.tempPath) {
                                    FileManager.default.createFile(atPath: self.tempPath, contents: nil, attributes: nil)
                                    DLog("temp file create file successed")
                                }
                                try self.tempFileHandler = FileHandle(forWritingTo: tempURL)
                            } catch {
                                DLog("\(self.tempPath) \n create temp file handle error \(error)")
                            }
                        }
//                        if let _ = self.fileHandle {
//
//                        } else {
//                            let audioURL = URL(fileURLWithPath: self.audioPath)
//                            do {
//                                if !FileManager.default.fileExists(atPath: self.audioPath) {
//                                    FileManager.default.createFile(atPath: self.audioPath, contents: nil, attributes: nil)
//                                    DLog("audio file create file successed")
//                                }
//                                try self.fileHandle = FileHandle(forWritingTo: audioURL)
//                            } catch {
//                                DLog("\(audioURL) \n create file handle error \(error)")
//                            }
//                        }
                    }
                }
            }
            XBEchoCancellation.shared()?.bl_input = inputBlock
        }
    }


    /// 1 分钟周期内音频数据处理：由于 timer 的时间不是精确的，所以 1 分钟是有误差的。
    /// 所以我们需要对每分钟的录音数据进行处理，严格按照一分钟的长度（60*22050）喂给算法，
    /// 多余的数据写入下分钟的临时文件内
    /// - Parameters:
    ///   - temURL: 临时（每分钟）的录音文件路径
    ///   - length: 1 分钟的数据长度，默认是 22050 * 60
    private func handlePeriodicData(audioDataURL url: URL, length: Int = kAudioDataLengthPerMinute) {
        do {
            self.tempFileLock.lock();
            let data = try Data(contentsOf: url)
            DLog("data count:\(data.count) -- length: \(length)")
            if length > data.count {
                DLog("audio data length less 1 minute")
                self.tempFileLock.unlock()
                return
            }
            XBEchoCancellation.shared()?.stopInput()
        
            self.tempFileHandler?.closeFile()
            
            self.tempFileLock.unlock()
            // 取出一分钟算法然后喂给算法
            let unitData = data.subdata(in: 0..<length)
//            self.createFils(data: unitData)
            DLog("unit data length is \(unitData.count)")
            Sleep.append(audioData: unitData) { (processData) in
                DLog("sleep process data \(processData)")
                NotificationName.sleepMicProcessData.emit([NotificationKey.sleepMicProcessDataKey: processData])
            }
            // 取出多出来的数据写入下一分钟的文件内
            let offsetData = data.subdata(in: length..<data.count)
            DLog("offset data length is \(offsetData.count)")
            self.clearTempRecorderFile(offsetData: offsetData)
        } catch {
            DLog("periodic audio data file not found \(error.localizedDescription)")
        }
    }

    public var tempURLs = [URL]()
    private func createFils(data: Data) {
        let nameHeader = Date().stringWith(formateString: "MM-dd-HH-mm")
        let ducumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask,
                                                               true).first!
        let tempPCMPath =  ducumentPath + "/\(nameHeader)+temp_\(tempURLs.count+1).pcm"
        if !FileManager.default.fileExists(atPath: tempPCMPath) {
            FileManager.default.createFile(atPath: tempPCMPath, contents: data, attributes: nil)
            self.tempURLs.append(URL(fileURLWithPath: tempPCMPath))
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
