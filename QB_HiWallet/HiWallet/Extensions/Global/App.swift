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
    static var isiPhoneSE: Bool {
        return UIScreen.main.bounds.width == 320
    }
}

extension App {
    struct Color {
        static let bgColorWhite = UIColor.init(hex: "#EAEAEA", alpha: 0.95)
        static let title = UIColor.black
        static let mainColor = UIColor.init(named: "#369BFF")!
        static let cellTitle = UIColor.init(named: "#111622")!
        static let cellInfo = UIColor.init(named: "#8E8E93")!
        static let subHeader = UIColor.init(named: "#6E788A")!
        static let settingBG = UIColor.init(named: "#F7F7F7")!
        static let createCard = UIColor.init(named: "#888888")
        static let titleColor = UIColor.init(named: "#333333")
        static let numberColor = UIColor.init(named: "#FE3B30")

        static let addressNavigationBar = UIColor.init(named: "#6D778A")!
        static let mnemonicVerifyCellBg = UIColor.init(named: "#F7F8FA")!
        static let assetCardPageColor = UIColor.init(named: "#D3D3D3")!
        static let tarbarHightlight = UIColor.init(named: "#0077FF")!
        
        static let bgColorLight = UIColor.init(named: "#38A8FF")!
        static let backGradientDrak = UIColor.init(named: "#7CB1F8")!
        static let backGradientLight = UIColor.init(named: "#526DFA")!
        static let topGradientDark = UIColor.init(named: "#A28531")!
        static let topGradientLight = UIColor.init(named: "#C6B03D")!
        static let btcGradientDark = UIColor.init(named: "#C07418")!
        static let btcGradientLight = UIColor.init(named: "#E1A62E")!
        static let eosGradientDark = UIColor.init(named: "#2C4AC2")!
        static let eosGradientLight = UIColor.init(named: "#8C86FF")!
        static let usdtGradientDark = UIColor.init(named: "#127B66")!
        static let usdtGradientLight = UIColor.init(named: "#33CE9A")!
        static let ethGradientDark = UIColor.init(named: "#302F46")!
        static let ethGradientLight = UIColor.init(named: "#464D72")!
        
        static let topColors = [topGradientDark.cgColor, topGradientLight.cgColor]
        static let btcColors = [btcGradientDark.cgColor,btcGradientLight.cgColor]
        static let eosColors = [eosGradientDark.cgColor, eosGradientLight.cgColor]
        static let usdtColors = [usdtGradientDark.cgColor, usdtGradientLight.cgColor]
        static let ethColors = [ethGradientDark.cgColor, ethGradientLight.cgColor]
        
        static let backupBgColors = [backGradientDrak.cgColor, backGradientLight.cgColor]
        static let sharedBgColors = [backGradientLight.cgColor, backGradientDrak.cgColor]
        static let walletMainBg = [backGradientLight.cgColor, bgColorLight.cgColor]
        
        static let lineColor = UIColor.init(named: "lineColor")
    }
}

extension App {
    static var assetCardRatio: CGFloat {
        if isiPhoneSE {
            return 312 / 184
        } else {
            return 312 / 173
        }
    }
    
    static var heightRatio: CGFloat {
        return UIScreen.main.bounds.height / 812
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
