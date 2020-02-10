//
//  LoginService.swift
//  HiWallet
//
//  Created by Jax on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import UIKit

class LoginService {
    static let shared = LoginService()
    private var window: UIWindow?
    private init() {
    }

    func register() {}
    func showLogin() {
        let guide = GuideViewController.loadFromWalletStoryboard()
        let nav = BaseNavigationController(rootViewController: guide)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.backgroundColor = .white
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        self.window = window
        window.makeKeyAndVisible()
    }

    func close() {
        guard let window = window else { return }
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            window.transform = CGAffineTransform(translationX: 0, y: window.bounds.size.height)
        }, completion: { _ in
            self.window = nil
        })
    }
}
