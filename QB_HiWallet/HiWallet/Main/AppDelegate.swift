//
//  AppDelegate.swift
//  HiWallet
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 TOP. All rights reserved.
//

import Firebase
import IQKeyboardManagerSwift
import RealmSwift
import TOPCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var appStateEventProxy: AppStateEventProxyInterface = inject()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase
        IQKeyboardManager.shared.enable = true
        regisJPushWithaplication(application, didFinishLaunchingWithOptions: launchOptions)

        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        AuthenticationService.shared.register()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        #if DEBUG
        //NFX.sharedInstance().start()
        #else
            FirebaseApp.configure()
        #endif
        AppHandler.shared.setUp()

        return true
    }

    // MARK: - AppEvents

    func applicationDidEnterBackground(_ application: UIApplication) {
        appStateEventProxy.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        appStateEventProxy.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appStateEventProxy.applicationDidBecomeActive(application)
        UIApplication.shared.applicationIconBadgeNumber = 0

    }

    func applicationWillResignActive(_ application: UIApplication) {
        appStateEventProxy.applicationWillResignActive(application)
    }
}

