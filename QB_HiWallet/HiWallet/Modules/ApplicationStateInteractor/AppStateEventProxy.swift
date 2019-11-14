//
//   Interface.swift
//  TOP
//
//  Created by Jax on 12/19/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import UIKit

public class AppStateEventProxy: AppStateEventProxyInterface {
    private var eventSubscribers: [AppStates: [AppStateEventHandler]] = [:]
    public init() {}

    private func add(subscriber: AppStateEventHandler, for event: AppStates) {
        if eventSubscribers[event] == nil {
            eventSubscribers[event] = [AppStateEventHandler]()
        }
        eventSubscribers[event]?.append(subscriber)
    }

    private func remove(subscriber: AppStateEventHandler, for event: AppStates) {
        if let subscribers = eventSubscribers[event] {
            // TODO: 如果多次 add 同一个状态的事件这样删除会有问题。
            if let index = subscribers.firstIndex(where: { $0 === subscriber }) {
                eventSubscribers[event]?.remove(at: index)
            }
        }
    }

    private func notifySubscribers(with event: AppStates) {
        if let subscribers = eventSubscribers[event] {
            for subscriber in subscribers {
                subscriber.receive(event: event)
            }
        }
    }

    // MARK: - AppStateEventProxyInterface

    public func add(subscriber: AppStateEventHandler, for events: [AppStates]) {
        for event in events {
            add(subscriber: subscriber, for: event)
        }
    }

    public func remove(subscriber: AppStateEventHandler, for events: [AppStates]) {
        for event in events {
            remove(subscriber: subscriber, for: event)
        }
    }

    // MARK: - AppEvents

    public func applicationDidEnterBackground(_ application: UIApplication) {
        notifySubscribers(with: .didEnterBackground)
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.frame = UIScreen.main.bounds
        blurEffectView.tag = 221122
        UIApplication.shared.keyWindow?.addSubview(blurEffectView)
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        notifySubscribers(with: .willEnterForeground)
        UIApplication.shared.keyWindow?.viewWithTag(221122)?.removeFromSuperview()
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        notifySubscribers(with: .didBecomeActive)
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        notifySubscribers(with: .willResignActive)
    }

    public func didFinishLaunching(_ application: UIApplication) {
        notifySubscribers(with: .didFinishLaunching)
    }
}
