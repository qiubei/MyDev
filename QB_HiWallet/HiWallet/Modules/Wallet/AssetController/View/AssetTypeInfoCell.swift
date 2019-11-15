//
//  AssetTypeInfoCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/2.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import UIKit

class AssetTypeInfoCell: UITableViewCell {
    @IBOutlet var chainImageview: UIImageView!
    @IBOutlet var iconImageview: UIImageView!
    @IBOutlet var assetSymbolLabel: UILabel!
    @IBOutlet var assetNameLabel: UILabel!
    @IBOutlet var coinCountLabel: UILabel!
    @IBOutlet var moneyLabel: UILabel!
}

extension AssetTypeInfoCell {
    func setupWith(wallets: [ViewWalletInterface], hiddenNum: Bool) {
        // 取到第一个
        let wallet = wallets.first!
        iconImageview.setIconWithWallet(model: wallet)
        chainImageview.isHidden = wallet.isMainCoin
        chainImageview.setChainIconWithWallet(model: wallet)
        assetSymbolLabel.text = wallet.symbol
        assetNameLabel.text = wallet.fullName

        coinCountLabel.text = hiddenNum ? "******" : getAllBalance(wallets: wallets)
        moneyLabel.text = hiddenNum ? "******" : getAllBalanceInCurrentCurrency(wallets: wallets)
    }

    func getAllBalance(wallets: [ViewWalletInterface]) -> String {
        var balance = 0.0
        for wallet in wallets {
            balance = balance + wallet.lastBalance
        }

        let formatter = BalanceFormatter(asset: wallets.first!.asset)
        let formatterBalance = formatter.formattedAmmount(amount: balance)
        return formatterBalance // + " " + wallets.first!.asset.symbol
    }

    func getAllBalanceInCurrentCurrency(wallets: [ViewWalletInterface]) -> String {
        var balance = 0.0
        for wallet in wallets {
            balance = balance + wallet.lastBalance
        }
        let currency = TOPStore.shared.currentUser.profile?.currency ?? .cny

        guard let rank = TOPStore.shared.ranks.getRank(for: wallets.first!.asset, on: currency) else {
            return currency.symbol + "0.00"
        }
        let formatter = BalanceFormatter(currency: currency)

        return formatter.formattedAmmountWithSymbol(amount: balance * rank)
    }
}
