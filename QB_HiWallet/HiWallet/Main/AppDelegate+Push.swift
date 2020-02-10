//
//  AppDelegate+Push.swift
//  HiWallet
//
//  Created by Jax on 2019/12/5.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import TOPCore

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// 注册通知
    func registerAppNotificationSettings(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.delegate = self
        
        notifCenter.requestAuthorization(options: [.alert, .badge, .sound]) { registered, _ in
            if registered {
                DLog("iOS request notification success")
            } else {
                DLog(" iOS 10 request notification fail")
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /// 处理后台点击通知的代理方法
    /// 当用户通过打开应用程序、取消通知或选择UNNotificationAction来响应通知时，该方法将在委托上调用。
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let model = PushMessage.deserialize(from: userInfo as? [String: Any]) {
            PushManager.shared.insertNewMessage(message: model)
 
            // handle event with notification type
            switch model.type {
            case .NOTICE_SIMPLE, .NOTICE_ALL:
                //detail notification info
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.notificationTransitionHandle(model: model) { nav in
                        let controller = NotificationDetailController()
                        controller.message = model
                        nav.pushViewController(controller, animated: true)
                    }
                })
            case .ACTIVITY:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.notificationTransitionHandle(model: model) { nav in
                        PushManager.shared.readMessage(messageID: model.id)
                        let web = WebBrowserViewController(urlStr: model.url!)
                        nav.pushViewController(web, animated: true)
                        NotificationName.changeNotiifcationInfo.emit()
                    }
                })
            default:
                break
            }
        }
        completionHandler()
    }
    
    /// 处理前台收到通知的代理方法
    /// 只有当应用程序在前台时，这个方法才会被调用。如果方法没有实现，或者没有及时调用处理程序，则不会显示通知。
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        DLog("userInfo10:\(userInfo)")
        
        if let model = PushMessage.deserialize(from: userInfo as? [String: Any]) {
            // handle event with notification type
            switch model.type {
            case .AWAKEN: break
            default:
                PushManager.shared.insertNewMessage(message: model)
            }
            if PushManager.shared.insertNewMessage(message: model) {
                NotificationName.changeNotiifcationInfo.emit()
            }
        }
        completionHandler([.sound, .alert])
    }
    
    /// 系统获取 Token：注意：设置的 deviceToken 格式为 "<a12b324c ... 12314cab8>"
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = (deviceToken as NSData).debugDescription
        PushManager.shared.setDeviceToken(deviceToken: tokenString)
        DLog("notification: devicetoken \(tokenString)")
    }
    
    /// 获取 token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    /// 点击转场时获取 navigationController
    private func notificationTransitionHandle(model: PushMessage, block: (UINavigationController) -> ()) {
        if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let controller = nav.viewControllers.last,
                controller is AuthenticationViewController {
                if let window = UIApplication.shared.windows.first,
                    let nav = (window.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
                    block(nav)
                    return
                }
            }
            block(nav)
        }
        
        if let nav = (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController {
            block(nav)
        }
    }
}
