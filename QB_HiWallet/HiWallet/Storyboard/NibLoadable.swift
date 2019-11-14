//
//  NibLoadable.swift
//  HiWallet
//
//  Created by apple on 2019/6/6.
//  Copyright © 2019 TOP. All rights reserved.
//  获取类名的sb类

import UIKit

protocol NibLoadable {
}

extension NibLoadable where Self: UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname ?? "\(self)"
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}

extension NibLoadable where Self: UIViewController {
    static func loadFromStoryboard(_ nibname: String? = nil) -> Self {
        let loadName = nibname ?? "\(self)"
        return UIStoryboard.main().instantiateViewController(withIdentifier: loadName) as! Self
    }

    //自定义storyboard名字和nib名字，默认id和wallet
    static func loadFromStoryboard(_ nibname: String? = nil, storyboard: String?) -> Self {
        let loadName = nibname ?? "\(self)"
        return UIStoryboard.main(name: storyboard ?? "Wallet").instantiateViewController(withIdentifier: loadName) as! Self
    }

    // 从Wallet加载
    static func loadFromWalletStoryboard(_ nibname: String? = nil) -> Self {
        let loadName = nibname ?? "\(self)"
        return UIStoryboard.main(name: "Wallet").instantiateViewController(withIdentifier: loadName) as! Self
    }

    // 从Setting加载
    static func loadFromSettingStoryboard(_ nibname: String? = nil) -> Self {
        let loadName = nibname ?? "\(self)"
        return UIStoryboard.main(name: "Setting").instantiateViewController(withIdentifier: loadName) as! Self
    }
}
