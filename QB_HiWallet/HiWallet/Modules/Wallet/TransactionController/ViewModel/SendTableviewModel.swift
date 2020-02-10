//
//  SendTableviewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/11/29.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

struct SendTableviewModel {
    
    private let wallet: ViewWalletInterface
    init(wallet: ViewWalletInterface) {
        self.wallet = wallet
    }
    
    var maxAmount: String {
        return wallet.formattedBalance
    }
    
    func submitTxWith(_ txInput: SendTxInputInfo, callback: (ValidInputMessageType)->()) {
        if let amountValue = Double(txInput.amount) {
            guard wallet.lastBalance >= amountValue else {
                callback(ValidInputMessageType.toast("余额不足".localized()))
                return
            }
            // 地址无效
            guard txInput.to.count > 0 && wallet.asset.isValidAddress(txInput.to) else {
                callback(ValidInputMessageType.toast("请输入有效地址".localized()))
                return
            }
            
            callback(ValidInputMessageType.success)
        } else {
            callback(ValidInputMessageType.toast("输入金额有误".localized()))
        }
    }
}
