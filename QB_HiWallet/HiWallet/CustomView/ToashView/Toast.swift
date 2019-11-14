//
//  NeuLoad.swift
//  HiWallet
//
//  Created by XiaoLu on 2018/6/6.
//  Copyright © 2018年 cryptape. All rights reserved.
//

import SVProgressHUD
import Toast_Swift
import UIKit

struct Toast {
    // 展示我们自定义的Toast
    public static func showToast(text: String) {
        guard text.lengthOfBytes(using: .utf8) > 0 else { return }
        ToastView.showMessage(message: text)
    }

    public static func hideToast() {
        UIApplication.shared.keyWindow?.hideAllToasts()
    }

    public static func showHUD(text: String? = nil) {
        SVProgressHUD.show(withStatus: text)
        SVProgressHUD.setDefaultMaskType(.clear)
    }

    public static func hideHUD() {
        SVProgressHUD.dismiss()
    }

    private static var rootView: UIView? {
        return (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
    }

    private static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
}

class ToastActivityView: UIView, NibLoadable {
    @IBOutlet private var label: UILabel!

    var text: String? {
        didSet {
            label.text = text
            label.isHidden = text == nil || text!.isEmpty
        }
    }
}
