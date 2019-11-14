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
    
    static var assetCardRatio: CGFloat {
        if isiPhoneSE {
            return 312 / 184
        } else {
            return 312 / 173
        }
    }
}

extension App {
    struct Color {
        static let mainColor = UIColor(named: "#369BFF")!
        static let cellTitle = UIColor(named: "#111622")!
        static let cellInfo = UIColor.init(named: "#8E8E93")!
        static let title = UIColor.black
        static let subHeader = UIColor(named: "#6E788A")!
        static let settingBG = UIColor(named: "#F7F7F7")!
        
        static let topColors = [#colorLiteral(red: 0.6352941176, green: 0.5215686275, blue: 0.1921568627, alpha: 1).cgColor, #colorLiteral(red: 0.7764705882, green: 0.6901960784, blue: 0.2392156863, alpha: 1).cgColor]
        static let btcColors = [#colorLiteral(red: 0.7529411765, green: 0.4549019608, blue: 0.09411764706, alpha: 1).cgColor, #colorLiteral(red: 0.8823529412, green: 0.6509803922, blue: 0.1803921569, alpha: 1).cgColor]
        static let eosColors = [#colorLiteral(red: 0.1725490196, green: 0.2901960784, blue: 0.7607843137, alpha: 1).cgColor, #colorLiteral(red: 0.5490196078, green: 0.5254901961, blue: 1, alpha: 1).cgColor]
        static let usdtColors = [#colorLiteral(red: 0.07058823529, green: 0.4823529412, blue: 0.4, alpha: 1).cgColor, #colorLiteral(red: 0.2, green: 0.8078431373, blue: 0.6039215686, alpha: 1).cgColor]
        static let ethColors = [#colorLiteral(red: 0.1882352941, green: 0.1843137255, blue: 0.2745098039, alpha: 1).cgColor, #colorLiteral(red: 0.2745098039, green: 0.3019607843, blue: 0.4470588235, alpha: 1).cgColor]
        
        static let lineColor = UIColor.init(named: "lineColor")
    }
}

extension App {
    struct UIConstant {
        static let homePageTableViewHeaderHeight: CGFloat = 310
        static let homePageStakingViewHeight: CGFloat = 38
    }
}

extension MainCoin {
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
