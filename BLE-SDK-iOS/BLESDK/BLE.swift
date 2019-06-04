//
//  BLEManager.swift
//  BLESDK
//
//  Created by HyanCat on 2018/6/5.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation
import NaptimeBLE
import PromiseKit
import RxBluetoothKit
import RxSwift

/// BLE 类
public class BLE {

    private let _disposeBag: DisposeBag = DisposeBag()

    /// 设备状态
    public private (set) var state: BLEState = .disconnected {
        didSet {
            NotificationName.bleStateChanged.emit([.bleStateKey: state])
        }
    }

    /// 设备信息
    public private (set) var deviceInfo: BLEDeviceInfo = BLEDeviceInfo()
    /// 设备电量
    public private (set) var battery: Battery? = nil {
        didSet {
            guard let battery = battery else { return }
            NotificationName.bleBatteryChanged.emit([.bleBatteryKey: battery])
        }
    }

    /// 扫描器
    public var scanner = NaptimeBLE.Scanner()
    /// 连接器
    public var connector: NaptimeBLE.Connector?

    // MARK: - 连接逻辑

    /// 查找并连接设备
    ///
    /// - Parameters:
    ///   - identifier: 身份 ID
    ///   - completion: 完成回调
    public func findAndConnect(identifier: UInt32, completion: Connector.ConnectResultBlock?) throws {
        if self.state.isBusy {
            throw InnerpeaceError.busy
        }
        search()
            .then { [unowned self] in
                self.connect(peripheral: $0.peripheral, identifier: identifier)
            }.done {
                completion?(true)
            }.catch { _ in
                completion?(false)
        }
    }

    /// 断开当前连接
    public func disconnect() {
        reset()
    }

    private func search() -> Promise<ScannedPeripheral> {
        let promise = Promise<ScannedPeripheral> { [weak self] seal in
            guard let `self` = self else { return }
            self.state = .searching

            scanner.stop()
            scanner.scan()
                .filter { scanned in
                    scanned.rssi.intValue > -60
                }
                .take(1)
                .timeout(10, scheduler: MainScheduler.asyncInstance)
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { scanned -> Void in
                    self.state = .connecting
                    seal.fulfill(scanned)
                }, onError: {
                    self.state = .disconnected
                    seal.reject($0)
                })
                .disposed(by: self._disposeBag)
        }
        return promise
    }

    public func connect(peripheral: Peripheral, identifier: UInt32) -> Promise<Void> {
        state = .connecting
        connector = Connector(peripheral: peripheral)
        let promise = Promise<Void> { seal in
            connector!.tryConnect()
                .then { _ -> Promise<Void> in
                    self.readBattery()
                    self.readDeviceInfo()
                    return self.connector!.handshake(userID: identifier)
                }.done {
                    // TODO: 比较 mac 地址
                    self.state = .connected(.allWrong)
                    self.listenConnection()
                    self.listenWear()
                    self.listenBattery()
                    seal.fulfill(())
                }.catch { error in
                    self.state = .disconnected
                    seal.reject(error)
            }
        }
        return promise
    }

    // MARK: - 指令操作

    func start() {
        // 监听脑波
        observers.eeg = connector?.eegService?
            .notify(characteristic: .data)
            .subscribe(onNext: { [weak self] bytes in
                autoreleasepool {
                    self?.handleBrainData(bytes: bytes)
                }
            }, onError: {
                DLog("eeg notify error: \($0)")
            })
        // 开始指令
        _ = connector?.commandService?.write(data: Data(bytes: [0x01]), to: .send)
    }

    /// 脑波数据缓冲
    private var _buffer: [UInt8] = []
    private let _bufferSize: Int = 150

    private func handleBrainData(bytes: [UInt8]) {
        var subbytes = bytes
        subbytes.removeFirst(2)
        _buffer.append(contentsOf: subbytes)
        if _buffer.count < _bufferSize {
            return
        }
        let data = Data(bytes: _buffer)
        _buffer.removeAll()
        NotificationName.bleBrainwaveData.emit([.bleBrainwaveKey: data])
    }

    func stop() {
        _buffer.removeAll()
        // 结束指令
        _ = connector?.commandService?.write(data: Data(bytes: [0x02]), to: .send)

        // 结束脑波监听
        observers.eeg?.dispose()
        observers.eeg = nil
    }

    // MARK: - DFU

    private lazy var dfu: DFU = {
        return DFU(peripheral: self.connector!.peripheral.peripheral, manager: self.connector!.peripheral.manager.centralManager)
    }()

    /// DFU 方法
    ///
    /// - Parameter fileURL: 固件文件 URL，必须是本地 URL
    /// - Throws: 如果设备未连接会抛出错误
    public func dfu(fileURL: URL) throws {
        guard self.connector?.peripheral != nil else { throw InnerpeaceError.invalid(message: "设备未连接") }

        dfu.fileURL = fileURL
        dfu.fire()
    }

    // MARK: - 监听逻辑

    struct Observers {
        var eeg: Disposable?
        /// 设备连接状态监听
        var connection: Disposable?
        /// 设备电量监听
        var battery: Disposable?
        /// 设备佩戴状态监听
        var wearing: Disposable?
    }
    private var observers: Observers = Observers()

    private func listenConnection() {
        observers.connection = connector?.peripheral.observeConnection()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isConnected in
                guard let `self` = self else { return }
                self.state = isConnected ? .connected(.allWrong) : .disconnected
                if !isConnected {
                    self.reset()
                }
            })
    }

    private func unlistenConnection() {
        observers.connection?.dispose()
        observers.connection = nil
    }

    private func listenWear() {
        observers.wearing = connector?.eegService?.notify(characteristic: .contact)
            .subscribe(onNext: { [unowned self] in
                guard let value = $0.first, let wearState = BLEWearState(rawValue: value), self.state.isConnected else { return }
                self.state = .connected(wearState)
            })
    }

    private func unlistenWear() {
        observers.wearing?.dispose()
        observers.wearing = nil
    }

    private func readBattery() {
        delay(seconds: 0.1) { [weak self] in
            self?.connector?.batteryService?.read(characteristic: .battery)
                .done { [weak self] in
                    guard let value = $0.copiedBytes.first else { return }
                    self?.battery = self?.battery(from: value)
                    DLog("BLE read: battery: \(value)")
                }.catch { _ in
                    //
            }
        }
    }

    private func listenBattery() {
        delay(seconds: 0.2) { [weak self] in
            self?.observers.battery = self?.connector?.batteryService?.notify(characteristic: .battery)
                .subscribe(onNext: { [weak self] in
                    guard let value = $0.first else { return }
                    self?.battery = self?.battery(from: value)
                    DLog("BLE notify: battery: \(value)")
                })
        }
    }
    private func unlistenBattery() {
        observers.battery?.dispose()
        observers.battery = nil
        self.battery = nil
    }

    private func readDeviceInfo() {
        connector?.deviceInfoService?.read(characteristic: .hardwareRevision).done { [weak self] in
            self?.deviceInfo.hardware = String(data: $0, encoding: .utf8) ?? ""
            }.catch { _ in }
        connector?.deviceInfoService?.read(characteristic: .firmwareRevision).done { [weak self] in
            self?.deviceInfo.firmware = String(data: $0, encoding: .utf8) ?? ""
            }.catch { _ in }
        connector?.deviceInfoService?.read(characteristic: .mac).done { [weak self] data -> Void in
            let mac = data.copiedBytes.reversed().map { String(format: "%02X", $0) }.joined(separator: ":")
            self?.deviceInfo.mac = mac
            }.catch { _ in }
        self.deviceInfo.name = connector?.peripheral.peripheral.name ?? ""
    }

    private func battery(from value: UInt8) -> Battery {
        let voltage = Float(value)/100 + 3.1
        let remain = Int(((-12050*pow(voltage, 4)+137175*pow(voltage, 3)-517145*pow(voltage, 2)+644850*voltage+5034)/60).rounded())
        let percentage = min(Float(remain)/81, 1.0)
        return Battery(voltage: voltage, remain: remain, percentage: percentage)
    }

    func reset() {
        scanner = NaptimeBLE.Scanner()
        unlistenWear()
        unlistenBattery()
        unlistenConnection()
        connector?.cancel()
        connector = nil
        state = .disconnected
        deviceInfo = BLEDeviceInfo()
    }
}

