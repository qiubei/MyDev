//
//  Colors.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/6.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

extension App {
    struct Color {
        static let bgColorWhite = UIColor.init(hex: "#EAEAEA", alpha: 0.95)
        static let title = UIColor.black
        static let mainColor = UIColor.init(named: "#369BFF")!
        static let cellTitle = UIColor.init(named: "#111622")!
        static let cellInfo = UIColor.init(named: "#8E8E93")!
        static let subHeader = UIColor.init(named: "#6E788A")!
        static let settingBG = UIColor.init(named: "#F7F7F7")!
        static let createCard = UIColor.init(named: "#888888")!
        static let titleColor = UIColor.init(named: "#333333")!
        static let numberColor = UIColor.init(named: "#FE3B30")

        static let addressNavigationBar = UIColor.init(named: "#6D778A")!
        static let mnemonicVerifyCellBg = UIColor.init(named: "#F7F8FA")!
        static let assetCardPageColor = UIColor.init(named: "#D3D3D3")!
        static let tarbarHightlight = UIColor.init(named: "#0077FF")!
        
        static let bgColorLight = UIColor.init(named: "#38A8FF")!
        static let backGradientDrak = UIColor.init(named: "#7CB1F8")!
        static let backGradientLight = UIColor.init(named: "#526DFA")!
        static let eosGradientDark = UIColor.init(named: "#2C4AC2")!
        static let eosGradientLight = UIColor.init(named: "#8C86FF")!
        static let usdtGradientDark = UIColor.init(named: "#127B66")!
        static let usdtGradientLight = UIColor.init(named: "#33CE9A")!
        
        static let ethGradientDark = UIColor.init(named: "card_eth_dark")!
        static let ethGradientLight = UIColor.init(named: "card_eth_light")!
        static let btcGradientDark = UIColor.init(named: "card_btc_dark")!
        static let btcGradientLight = UIColor.init(named: "card_btc_light")!
        static let topGradientDark = UIColor.init(named: "card_top_dark")!
        static let topGradientLight = UIColor.init(named: "card_top_light")!
        static let dashGradientDark = UIColor.init(named: "card_dash_dark")!
        static let dashGradientLight = UIColor.init(named: "card_dash_light")!
        static let bchGradientDark = UIColor.init(named: "card_bch_dark")!
        static let bchGradientLight = UIColor.init(named: "card_bch_light")!
        static let ltcGradientDark = UIColor.init(named: "card_ltc_dark")!
        static let ltcGradientLight = UIColor.init(named: "card_ltc_light")!
        static let rewardDetailsDark = UIColor.init(named: "card_reward_details_dark")!
        static let rewardDetailsLight = UIColor.init(named: "card_reward_details_light")!
        
        static let topColors = [topGradientDark.cgColor, topGradientLight.cgColor]
        static let btcColors = [btcGradientDark.cgColor,btcGradientLight.cgColor]
        static let eosColors = [eosGradientDark.cgColor, eosGradientLight.cgColor]
        static let usdtColors = [usdtGradientDark.cgColor, usdtGradientLight.cgColor]
        static let ethColors = [ethGradientDark.cgColor, ethGradientLight.cgColor]
        static let dashColors = [dashGradientDark.cgColor, dashGradientLight.cgColor]
        static let ltcColors = [ltcGradientDark.cgColor, ltcGradientLight.cgColor]
        static let bchColors = [bchGradientDark.cgColor, bchGradientLight.cgColor]
        
        static let rewardDetailsBgColors = [rewardDetailsDark.cgColor, rewardDetailsLight.cgColor]
        static let backupBgColors = [backGradientDrak.cgColor, backGradientLight.cgColor]
        static let sharedBgColors = [backGradientLight.cgColor, backGradientDrak.cgColor]
        static let walletMainBg = [backGradientLight.cgColor, bgColorLight.cgColor]
        
        static let lineColor = UIColor.init(named: "lineColor")
    }
}
