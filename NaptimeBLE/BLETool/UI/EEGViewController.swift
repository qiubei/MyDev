//
//  EEGViewController.swift
//  NaptimeBLE
//
//  Created by NyanCat on 27/10/2017.
//  Copyright © 2017 EnterTech. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxBluetoothKit
import RxSwift
import SVProgressHUD
import SwiftyTimer
import NaptimeBLE
import AVFoundation

class EEGViewController: UITableViewController {
    var eegService: EEGService!
    var commandService: CommandService!
    var peripheral: Peripheral!

    private let _player: AVAudioPlayer = {
        let url = Bundle.main.url(forResource: "1-minute-of-silence", withExtension: "mp3")!
        let player = try! AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = 10000
        return player
    }()

    private var _isSampling: Bool = false
    private var _disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Acquire", style: .plain, target: self, action: #selector(sampleButtonTouched))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none

        _player.play()

        self.eegService.notify(characteristic: .contact)
            .observeOn(MainScheduler())
            .subscribe(onNext: { [weak self] in
                self?._wearLabel.text = "wear: \($0)"
            }, onError: { _ in
                SVProgressHUD.showInfo(withStatus: "Failed to listen wearing state.")
            }).disposed(by: _disposeBag)

        window.windowLevel = UIWindow.Level.statusBar + 1
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.lightGray
        window.frame = CGRect(x: 0, y: window.bounds.height-80, width: window.bounds.width, height: 80)
        _wearLabel.frame = CGRect(x: 16, y: 8, width: window.bounds.width - 32, height: 20)
        _rssiLabel.frame = CGRect(x: 16, y: 36, width: window.bounds.width - 32, height: 20)
        window.addSubview(_wearLabel)
        window.addSubview(_rssiLabel)
    }

    private let window = UIWindow()
    private let _wearLabel = UILabel()
    private let _rssiLabel = UILabel()

    deinit {
        _player.stop()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if _isSampling {
            stopSample()
        }
    }

    @objc
    private func sampleButtonTouched() {
        if _isSampling {
            commandService.write(data: Data(bytes: [0x02]), to: .send).done {
                dispatch_to_main { [unowned self] in
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Acquire", style: .plain, target: self, action: #selector(self.sampleButtonTouched))
                    self.stopSample()
                    self._isSampling = !self._isSampling
                }
                }.catch { _ in
                    SVProgressHUD.showError(withStatus: "Failed to send 'stop' command!")
            }
        } else {
            dataList.removeAll()
            tableView.reloadData()
            commandService.write(data: Data(bytes: [0x01]), to: .send).done {
                dispatch_to_main { [unowned self] in
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(self.sampleButtonTouched))

                    self._timerDisposable = self.startSample()
                        .observeOn(MainScheduler())
                        .subscribe(onNext: {
                            self.render(data: $0)
                        })
                    self._isSampling = !self._isSampling
                }
                }.catch { _ in
                    SVProgressHUD.showError(withStatus: "Failed to send 'start' command!")
            }
        }
    }

    private var _eegDisposable: Disposable?
    private var _timerDisposable: Disposable?

    private func startSample() -> Observable<Data> {
        SVProgressHUD.showInfo(withStatus: "Showing only 10s of data on screen,\n otherwise the memory will bomb💥💥")
        EEGFileManager.shared.create()

        let dataPool = DataPool()
        _eegDisposable = self.eegService.notify(characteristic: .data)
            .subscribe(onNext: { [weak self] in
                var received = $0
                received.removeFirst(2)
                let data = Data(bytes: received)
                dataPool.push(data: data)

                guard let `self` = self else { return }
                self.peripheral.readRSSI()
                    .observeOn(MainScheduler.asyncInstance)
                    .subscribe(onSuccess: { sig in
                        self._rssiLabel.text = "rssi: \(sig.1)"
                        print("111")
                    }, onError: { e in
                        print("e: \(e)")
                    }).disposed(by: self._disposeBag)
            }, onError: { _ in
                SVProgressHUD.showError(withStatus: "Failed to listen brainwave data.")
            })

        return Observable<Data>.create { observer -> Disposable in
            let timer = Timer.every(1.0, {
                if dataPool.isAvailable {
                    // 每次取 750 个字节，即 1s 的数据量
                    let data = dataPool.pop(length: 750)
                    self.saveToFile(data: data)
                    observer.onNext(data)
                }
            })
            return Disposables.create {
                timer.invalidate()
                dataPool.dry()
            }
        }
    }

    private func stopSample() {
        _eegDisposable?.dispose()
        _timerDisposable?.dispose()
        let fileName = EEGFileManager.shared.fileName
        EEGFileManager.shared.close()
        SVProgressHUD.showSuccess(withStatus: "File saved: \(fileName!)")
    }

    var dataList: [Data] = []

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eegCellReuseIdentifier", for: indexPath) as! EEGCell
        let data = dataList[indexPath.row]
        cell.dataLabel.text = data.hexString
        return cell
    }

    private func render(data: Data) {
        if dataList.count >= 10 {
            dataList.removeAll()
            tableView.reloadData()
        }
        dataList.append(data)
        let indexPath = IndexPath(row: dataList.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    private func saveToFile(data: Data) {
        EEGFileManager.shared.save(data: data)
    }
}

class EEGCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
}
