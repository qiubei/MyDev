//
//  Notification.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

// 局部维护通知的 key
fileprivate struct NotificationKey {
    static let createNewAccountKey = "createNewAccountKey"
    static let changeAccountInfoKey = "changeAccountInfoKey"
    static let deleteAccountKey = "deleteAccountKey"
    static let changeNotificationInfoKey = "changeNotificationInfoKey"
    static let deleteAllNotification = "deleteAllNotification"

}

extension Notification.Name {
    /// emit  a notification
    func emit(_ userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: self,
                                        object: nil,
                                        userInfo: userInfo)
    }

    /// observe notification
    func observe(sender: Any, selector: Selector) {
        NotificationCenter.default.addObserver(sender,
                                               selector: selector,
                                               name: self,
                                               object: nil)
    }
    
    /// remove notification
    func remove(sender: Any) {
        NotificationCenter.default.removeObserver(sender, name: self,
                                                  object: nil)
    }
}
struct NotificationName {}

extension NotificationName {
    static let createNewAccout = Notification.Name.init(NotificationKey.createNewAccountKey)
    static let changeAccountInfo = Notification.Name.init(NotificationKey.changeAccountInfoKey)
    static let deleteAccount = Notification.Name.init(NotificationKey.deleteAccountKey)
    static let changeNotiifcationInfo = Notification.Name.init(NotificationKey.changeNotificationInfoKey)
    static let deleteAllNotification = Notification.Name.init(NotificationKey.deleteAllNotification)

}
