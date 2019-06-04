////
////  AudioUnitRecording.swift
////  BLESDK
////
////  Created by Enter on 2018/12/18.
////  Copyright © 2018 EnterTech. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//public final class AudioUnitRecording: NSObject {
//    
//    /// 每 1 分钟的临时录音文件路径
//    private let defaultPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/tmpRecord.wav"
//    private var _timer: Timer?
//    private let _record: XBEchoCancellation?
//    private var _state: MicrophoneState = .other
//    
//    public init() {
//        record = XBEchoCancellation(rate: 11025, bit: 16, channel: 1)
//    }
//    
//    /// 麦克风状态
//    public var state: MicrophoneState {
//        getState()
//        return _state
//    }
//    
//    public var recordFileURL: string {
//        return URL(fileURLWithPath: defaultPath)
//    }
//    
//    
//    private func getState() {
//        AVCaptureDevice.requestAccess(for: .audio) { (granted) in
//            if !granted {
//                self._state = MicrophoneState.unPermission
//            }
//        }
//        if let record = self._record {
//            self._state = record.echoCancellationStatus == 0 ? MicrophoneState.recording : MicrophoneState.other
//        }
//    }
//    
//}
