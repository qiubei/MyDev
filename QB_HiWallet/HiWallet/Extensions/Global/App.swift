//
//  App.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore

struct App {
    static var isSmallScreen: Bool {
        return UIScreen.main.bounds.width == 320
    }
}

extension App {
    static var assetCardRatio: CGFloat {
        if isSmallScreen {
            return 312 / 184
        } else {
            return 312 / 173
        }
    }
    
    static var heightRatio: CGFloat {
        return UIScreen.main.bounds.height / 812
    }
    
    static var widthRatio: CGFloat {
        return UIScreen.main.bounds.width / 375
    }
    
    struct UIConstant {
        static let walletMainHeaderHeight: CGFloat = 310
        static let walletMainStakingViewHeight: CGFloat = 38
    }
}

extension ChainType {
    func getColors() -> [CGColor] {
        switch self {
        case .bitcoin:
            return App.Color.btcColors
        case .ethereum:
            return App.Color.ethColors
        case .topnetwork:
            return App.Color.topColors
        default:
            return App.Color.ethColors
        }
    }
}


extension App {
    static let currentLanguage = LocalizationLanguage.systemLanguage.isChinese ? "CN" : "EN"
}
