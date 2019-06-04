//
//  RecordingViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/7/17.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import AVFoundation
import BLESDK
import BLESDK_NapMusic
import BLESDK_Microphone
import SVProgressHUD
import Files

class RecordingViewController: BaseTableViewController {
    private let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                  .userDomainMask,
                                                                  true).first!
    private let tempWavFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                      .userDomainMask,
                                                                      true).first! + "/myWav.wav"
    private let items = ["开启麦克风算法", "开启小睡算法", "实时麦克风分析监听", "实时脑波分析监听", "开音乐"]
    private var rawFilesList = [String]()
//    private let testRadioPath = Bundle.main.path(forResource: "five", ofType: "mp3")!
//    private var player: NPPlayer  {
//        return NPPlayer(url: URL(fileURLWithPath: testRadioPath))
//    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let _ = self.timer, self.presentedViewController == nil {
            self.stopMicrophone()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.brainDataHandler(notification:)),
                                               name: NotificationName.bleBrainwaveData.name,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.finishHandleWith(notification:)),
                                               name: NotificationName.sleepFinishResult.name,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.napFinish(_:)),
                                               name: NotificationName.napFinishData.name,
                                               object: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sleep_cell", for: indexPath)
        cell.accessoryView = self.createAccessoryView(indexPath: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]

        return cell
    }

    override func update(sender: UISwitch) {
        switch sender.tag % 100 {
        case 0:
            if Innerpeace.microphone.state == .unPermission {
                SVProgressHUD.showInfo(withStatus: "请开启麦克风权限")
                return
            }
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: "开启麦克风算法")
                self.startMicrophone()
            } else {
                SVProgressHUD.showInfo(withStatus: "关闭麦克风算法")
                self.stopMicrophone()
            }
        case 1:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: "开启小睡算法")
                try? Innerpeace.start(algorithm: .napMusic)
                IPFileManager.shared.create()
            } else {
                Innerpeace.end()
                IPFileManager.shared.close()
                SVProgressHUD.showInfo(withStatus: "关闭小睡算并保存文件 \(IPFileManager.shared.fileName!)")
            }
        case 2:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: "开启麦克风实时分析监听")
                self.startMicrophoneProcessingListen()

            } else {
                SVProgressHUD.showInfo(withStatus: "关闭麦克风实时分析监听")
                self.stopMicrophoneProcessingListen()
            }
        case 3:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: "开启小睡实时分析监听")
                self.startProcessingListen()
            } else {
                SVProgressHUD.showInfo(withStatus: "开启小睡实时分析监听")
                self.stopProcessingListen()
            }
        case 4:
            if sender.isOn {
                if let _ = self.player {
                    player?.play()
                } else {
                    self.test()
                }
            } else {
                player?.pause()
            }
        default:
            break
        }
    }

    override func startProcessingListen() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.napProcesshandler(notification:)),
                                               name: NotificationName.napProcessData.name,
                                               object: nil)
    }
 
    override func stopProcessingListen() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NotificationName.napProcessData.name,
                                                  object: nil)
    }

    override func finishHandleWith(notification: Notification) {
        let info = notification.userInfo
        let sleepReslut = info![NotificationKey.sleepFinishResultKey] as? Sleep.SleepFinishResult
        
        if let result = sleepReslut {
            self.writeTo(report: result)
            SVProgressHUD.showInfo(withStatus: "\(result)")
            print("----\(result)-----")
        } else {
            SVProgressHUD.showInfo(withStatus: "算法结果为空")
        }
    }

    @objc
    private func napFinish(_ notification: Notification) {
        print("test a case")
    }
    
    private func writeTo(report: Sleep.SleepFinishResult) {
        let dic = report.toDic()
        let mutableDic = NSMutableDictionary(dictionary: dic)
        mutableDic["name"] = Date().toFileName
        IPFileManager.shared.writeReport(dic: mutableDic)
    }

    private var napAnalyzedDatas: [Sleep.NapAnalyzedProcessData]?
    @objc private func napProcesshandler(notification: Notification) {
        let info = notification.userInfo
        let processData = info![NotificationKey.napProcessDataKey] as? NapMusic.NapProcessData
        // TODO: Ugly Test
        if let data = processData {
            if self.napAnalyzedDatas == nil {
                self.napAnalyzedDatas = [Sleep.NapAnalyzedProcessData]()
            }
            SVProgressHUD.showInfo(withStatus: "\(data)")
            let timestamp = Int(Date().timeIntervalSince1970)
            let process = Sleep.NapAnalyzedProcessData(timestamp,
                                                       data.dataQuality,
                                                       data.soundControl,
                                                       data.sleepState)



            self.napAnalyzedDatas!.append(process)
        } else {
            SVProgressHUD.showInfo(withStatus: "算法分析出错")
        }
    }

    @objc private func microphoneProcessHandler(notification: Notification) {
        let info = notification.userInfo
        let processData = info![NotificationKey.sleepMicProcessDataKey] as? Sleep.MicAnalyzedProcessData
        if let data = processData {
            SVProgressHUD.showInfo(withStatus: "\(data)")
            if data.daydreamFlag && data.daydreamRecData.count > 0 {
                let pcmData = data.daydreamRecData
                let path = documentDir + "/Daydream_\(Date().stringWith(formateString: "HH:mm")).wav"
                convertToWAV(buffer: pcmData, filePath: path)
            }
            if data.snoreFlag && data.snoreRecData.count > 0 {
                let pcmData = data.snoreRecData
                let path = documentDir + "/Snore_\(Date().stringWith(formateString: "HH:mm")).wav"
                convertToWAV(buffer: pcmData, filePath: path)
            }
            print("process Data: \(data)")
        } else {
            SVProgressHUD.showInfo(withStatus: "麦克风算法分析错误")
        }
    }

    private var startTime: Date?
    private var zeroTime: Date?
    private var timerString: String = "00:00:00"
    @objc
    private func updateTimer(_ timer: Timer) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        //TODO: 这里有 1 秒钟的延迟
        if self.startTime == nil {
            self.zeroTime = formatter.date(from: "00:00:00")
            self.startTime = Date()
        }
        let interval = Date().timeIntervalSince(self.startTime!)
        let intervalDate = Date(timeInterval: interval, since: self.zeroTime!)
        self.timerString = formatter.string(from: intervalDate)
        self.title = self.timerString
    }

    @objc
    private func brainDataHandler(notification: Notification) {
        let info = notification.userInfo
        if let dic = info,let data = dic[NotificationKey.bleBrainwaveKey ] as? Data {
            IPFileManager.shared.save(data: data)
        }
    }

    private func startMicrophoneProcessingListen() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.microphoneProcessHandler(notification:)),
                                               name: NotificationName.sleepMicProcessData.name,
                                               object: nil   )
    }

    private func stopMicrophoneProcessingListen() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NotificationName.sleepMicProcessData.name,
                                                  object: nil)
    }


    private var timer: Timer?
//    public var recordAudioURL: URL{
//        let audioPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/record.wav"
//        return URL(fileURLWithPath: audioPath)
//    }
//    private var _audioRecord: AVAudioRecorder?
//    private let recorderSetting: [String: Any] = [AVSampleRateKey: 11025,
//                                                  AVFormatIDKey: kAudioFormatLinearPCM,
//                                                  AVLinearPCMBitDepthKey: 16,
//                                                  AVNumberOfChannelsKey: 1,
//                                                  AVLinearPCMIsBigEndianKey: false]

    private func startMicrophone() {
        do {
            try Innerpeace.microphone.start()
            Sleep.setMusic(flag: false)
        } catch {
            SVProgressHUD.showError(withStatus: "没有开启麦克权限 \(error)")
        }

        self.timer = Timer(timeInterval: 1.0,
                           target: self,
                           selector: #selector(self.updateTimer(_:)),
                           userInfo: nil,
                           repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)

//        self._audioRecord = try? AVAudioRecorder(url: self.recordAudioURL, settings: recorderSetting)
//        self._audioRecord?.isMeteringEnabled = true
//        self._audioRecord?.prepareToRecord()
//        self._audioRecord?.record()
    }

    /// 保存录音文件
    private var _files: Folder? {
        return try? Folder(path: IPFileManager.shared.audioPath)
    }

    private func stopMicrophone() {
        self.player?.stop()
//        self.tableView.reloadData()
        Innerpeace.end()
        Innerpeace.microphone.end(napAnalyzedDatas: self.napAnalyzedDatas)
        self.clear()
    }

    private func clear() {
        self.timer?.invalidate()
        self.startTime = nil
        self.timer = nil
        self.timerString = "00:00:00"
        let audioPath = Innerpeace.microphone.pcmAudioURL.path
        DispatchQueue.global().async {
            self.saveAudioFile(audioPath)
        }
    }

    private func saveAudioFile(_ audioPath: String) {
        if FileManager.default.fileExists(atPath: audioPath) {
            do {
                let data = try! Data(contentsOf: URL(fileURLWithPath: audioPath))
                let int16Buffer = converToInt16(data: data)
                convertToWAV(buffer: int16Buffer, filePath: tempWavFilePath)
                let wavFilePath = IPFileManager.shared.copyAt(url: URL(fileURLWithPath: self.tempWavFilePath))
                try _files?.createFile(named: wavFilePath)
                try _files?.createFile(named: Innerpeace.microphone.pcmAudioURL.path)
                for item in Innerpeace.microphone.tempURLs {
                    try _files?.createFile(named: item.path)
                }
            } catch {
                print("save audio file error: \(error)")
            }
        }
    }

    private let testRadioPath = Bundle.main.path(forResource: "five", ofType: "mp3")!
    var player: AVAudioPlayer?
    private func test() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.multiRoute, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {

        }
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: self.testRadioPath))
        player!.prepareToPlay()
        player?.numberOfLoops = 10
        player?.volume = 1
        player!.play()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

fileprivate func converToInt16(data: Data) -> [Int16] {
    var list = [Int16]()
    for i in 0..<data.count/2 {
        if (2*i+1) >= data.count { break }
        let bigEnd = Int32(data[2*i])
        let smallEnd = Int32(data[2*i + 1])<<8
        var value: Int16 = 0
        if (bigEnd + smallEnd) > (1<<15) {
            value = Int16(bigEnd + smallEnd - (1<<16))
        } else {
            if (bigEnd + smallEnd) == 1<<15 {
                value = 0
            } else {
                value = Int16(bigEnd + smallEnd)
            }
        }
        list.append(value)
//        print("\(data[2*i])-\(data[2*i+1])----\(value)")
    }
    return list
}

fileprivate func convertToWAV(buffer: [Int16], filePath: String) {
    let outputFormateSetting = [AVFormatIDKey : kAudioFormatLinearPCM,
                                AVLinearPCMBitDepthKey : 16,
                                AVSampleRateKey : 11025,
                                AVNumberOfChannelsKey : 1,
                                AVLinearPCMIsBigEndianKey : false] as [String : Any]
    let audioFile = try? AVAudioFile(forWriting: URL(fileURLWithPath: filePath),
                                     settings: outputFormateSetting,
                                     commonFormat: AVAudioCommonFormat.pcmFormatInt16,
                                     interleaved: true)

    let audioFormat = AVAudioFormat(settings: outputFormateSetting)!
    let PCMbuf = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(buffer.count))

    PCMbuf?.frameLength = AVAudioFrameCount(buffer.count)
    for i in 0..<buffer.count {
        if (i + 1)>=buffer.count {break}
        PCMbuf?.int16ChannelData!.pointee[i] = Int16(buffer[i])
    }
    do {
        try audioFile?.write(from: PCMbuf!)
    } catch {
        print("audio file write failed \(error)")
    }
}
