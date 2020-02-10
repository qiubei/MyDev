//
//  ConfirmSendTxViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

struct ConfirmSendTxViewModel {
    private var sendModel: TxSenderProtocol!
    private let wallet: ViewWalletInterface
    init(_ isDapp: Bool = false, wallet: ViewWalletInterface) {
        self.wallet = wallet
        if !wallet.isMainCoin {
            sendModel = ETHTxSender(type: .Token, wallet: wallet)
        }
        
        if wallet.symbol == ChainType.ethereum.symbol {
            if isDapp { // Dapp
                sendModel = ETHTxSender(type: .Dapp, wallet: wallet)
            } else {
                sendModel = ETHTxSender(type: .Eth, wallet: wallet)
            }
        }
        
        if wallet.isUTXOWallet {
            sendModel = UTXOTxSender(walletInfo: wallet)
        }
    }
    
    /// get amount with attribute string.
    /// e.g. 1 BTC ≈ 8888.88 (formate string )
    /// - Parameter amount: amount of asset
    func attributeAmount(amount: String) -> NSAttributedString {
        let balance = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(amount) ?? 0)
        let attriStr = CryptoFormatter.attributeString(amount: amount + " \(wallet.symbol)", balance: balance)
        return attriStr
    }
    
    /// Loading pre data like balance, hould be load this method first.
    func loadData(callback: @escaping (Bool) -> Void) {
        sendModel.loadData(callback: callback)
    }
    
    /// check out tx input info in chain with txInput
    /// step:
    /// 1. load data from chain: feedata and balance and so no.
    /// 2. check input info.
    func checkoutInputInfoWith(txInputInfo: SendTxInputInfo, callback: @escaping (ValidInputMessageType) -> Void) {
        sendModel.checkInputInChain(txInputInfo, callback: callback)
    }
    
    /// get datalist that display in the popviewcontroller with the selected txFeeList index。（the txFeeList is ascending with fee）
    /// - Parameter feeLevelIndex: the index of selected txFeeList
    func updatePoplistWith(feeLevelIndex: Int) -> [SendPopViewModel] {
        let list = sendModel.getPopDatalist(feeIndex: feeLevelIndex)
        return list
    }
    
    /// confirming the txInputInfo in the chain
    /// - Parameter callback: callback of checking txInputInfo
    func confirmVerify(_ callback: @escaping (ValidInputMessageType) -> Void) {
        sendModel.confirmVerify(callback: callback)
    }
    
    /// send tx to main chain
    /// - Parameter callback: callback of the state of sending tx to main chain
    func sendTranscation(callback: @escaping ((Bool, String)) -> Void) {
        sendModel.sendTranstion(callback: callback)
    }
}
