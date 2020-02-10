//
//  BaseNavigationController.swift
//  HiWallet
//
//  Created by apple on 2019/5/24.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white

        clearSeparateLine()
//        self.clearNavigationBarBgColor()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // 拦截跳转事件
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            // 添加图片
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_left_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(leftClick))
        }
        super.pushViewController(viewController, animated: animated)
    }

    private func clearSeparateLine() {
        navigationBar.shadowImage = UIImage()
    }

    private func clearNavigationBarBgColor() {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    // 返回上一层控制器
    @objc func leftClick() {
        popViewController(animated: true)
    }
}

extension BaseNavigationController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count >= 2 {
            return true
        }
        return false
    }
}
