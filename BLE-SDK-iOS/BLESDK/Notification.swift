//
//  Notification.swift
//  BLESDK
//
//  Created by HyanCat on 2018/5/18.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation

/// 所有的通知
public enum NotificationName: String {
    case bleStateChanged
    case bleBrainwaveData
    case bleBatteryChanged

    case concentrationData
    case concentrationBlink
    case concentrationMusicData
    case concentrationMusicFinishData

    case napProcessData
    case napFinishData
    case napMusicData

    case sleepMicProcessData
    case sleepFinishResult

    case dfuStateChanged
}

/// 通知信息中的 key
public enum NotificationKey: String {
    case bleStateKey
    case bleBrainwaveKey
    case bleBatteryKey
    case concentrationDataKey
    case concentrationBlinkKey
    case concentrationMusicKey
    case concentrationFinishDataKey
    case napProcessDataKey
    case napFinishDataKey
    case napMusicCommandKey
    case sleepMicProcessDataKey
    case sleepFinishResultKey
    case dfuStateKey
}

extension NotificationName {
    public var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

extension NotificationName {
    func emit(_ userInfo: [NotificationKey: Any]? = nil) {
        dispatch_to_main {
            NotificationCenter.default.post(name: self.name, object: nil, userInfo: userInfo)
        }
    }
}

/// 异步主线程执行任务
///
/// - Parameter block: 任务 block
func dispatch_to_main(block: @escaping () -> ()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

func delay(seconds: TimeInterval, block: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: block)
}
