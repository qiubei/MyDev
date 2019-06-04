//
//  AppDelegate.swift
//  BLESDK
//
//  Created by HyanCat on 2018/5/14.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        Language.initLocal()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Language.load()
    }
}

