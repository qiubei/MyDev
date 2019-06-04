//
//  Innerpeace.swift
//  BLESDK
//
//  Created by HyanCat on 2018/5/15.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation

/// Innerpeace SDK 入口类
public final class Innerpeace {

    private init() {}

    /// 开启 Log，建议 Debug 模式下开启
    public static func enableLog() {
        __enableLog = true
    }

    /// 默认单例
    private static let `default` = Innerpeace()

    /// BLE 入口
    public static let ble = BLE()
    /// 麦克风算法入口
    public static let microphone = Microphone()
    /// 产品硬件算法入口
    private static let algorithmWrapper = AlgorithmWrapper()

    private static var _isStarted = false

    /// 开始体验
    ///
    /// - Parameter options: 支持的算法选项
    /// - Throws: 如果设备未连接会抛出错误
    public static func start(algorithm options: AlgorithmOptions = []) throws {
        guard ble.state.isConnected else {
            throw InnerpeaceError.invalid(message: "未连接设备，无法开始")
        }

        if _isStarted {
            throw InnerpeaceError.invalid(message: "正在体验中没有结束，重复开始无效")
        }
        _isStarted = true


        NotificationCenter.default.addObserver(`default`,
                                               selector: #selector(handleBrainwaveData(_:)),
                                               name: NotificationName.bleBrainwaveData.name,
                                               object: nil)
        NotificationCenter.default.addObserver(`default`,
                                               selector: #selector(handleBLEStateChanged(_:)),
                                               name: NotificationName.bleStateChanged.name,
                                               object: nil)

        algorithmWrapper.register(algorithm: options)
        algorithmWrapper.start()
        ble.start()
    }

    /// 结束体验
    public static func end() {
        _isStarted = false

        NotificationCenter.default.removeObserver(`default`, name: NotificationName.bleBrainwaveData.name, object: nil)
        NotificationCenter.default.removeObserver(`default`, name: NotificationName.bleStateChanged.name, object: nil)

        ble.stop()
        algorithmWrapper.end()
    }

    @objc
    private func handleBrainwaveData(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let data = userInfo[NotificationKey.bleBrainwaveKey] as? Data else { return }

        Innerpeace.algorithmWrapper.handleBrainData(data)
    }

    @objc
    private func handleBLEStateChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let state = userInfo[NotificationKey.bleStateKey] as? BLEState else { return }
        switch state {
        case .connected(let wear):
            Innerpeace.algorithmWrapper.wearing(isOK: wear.isOK)
            break
        default:
            break
        }
    }

}
