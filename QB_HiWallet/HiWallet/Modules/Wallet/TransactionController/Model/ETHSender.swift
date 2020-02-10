//
//  ETHTransViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore
import UIKit

class ETHSender: TxSenderProtocol {
    // 转账需要的参数
    var txInputInfo: SendTxInputInfo!
    
    var wallet: ViewWalletInterface!
    init(walletInfo: ViewWalletInterface) {
        wallet = walletInfo
    }
    
    private let decimalNumber = 8
    private var feeLevel: TxFeeLevel!
    func checkInputInChain(_ inputInfo: SendTxInputInfo, callback: @escaping (ValidInputMessageType) -> Void) {
        // 小数点位数
        guard getdigitNumber(value: inputInfo.amount) <= decimalNumber else {
            callback(ValidInputMessageType.toast("小数点不能超过8位！".localized()))
            return
        }
        
        self.txInputInfo = inputInfo
        // 加载链上数据
        let group = DispatchGroup()
        group.enter()
        var flag = false
        loadFeeData { (txLevel) in
            if let level = txLevel {
                flag = true
                self.feeLevel = level
            } else {
                flag = false
            }
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            if flag {
                callback(.success)
            } else {
                callback(ValidInputMessageType.toast("网络出走了，请检查网络状态后重试".localized()))
            }
        }
    }
    
    func loadData(callback: @escaping (Bool) -> Void) { }
    
    private var feePriceList: [String] = []
    private var popProvider = PopViewModelProvider()
    func getPopDatalist(feeIndex: Int) -> [SendPopViewModel] {
        feePrice = feePriceList[feeIndex]
        // 本地联系人
        let contact = TOPStore.shared.currentUser.addressBook.filter { $0.address == self.txInputInfo.to }.first
        popProvider.from.topDesc = wallet.name
        popProvider.from.bottomDesc = wallet.address
        popProvider.to.topDesc = contact?.note ?? ""
        popProvider.to.bottomDesc = self.txInputInfo.to
        let feeList = popProvider.createTxFeeList(txLevel: feeLevel)
        let selectedFee = feeList[feeIndex]
        popProvider.process.topDesc = selectedFee.speedDesc
        popProvider.process.bottomDesc = selectedFee.Fee
        popProvider.process.nextList = feeList
        let totalA = totalAmount(with: Double(txInputInfo.amount) ?? 0, feePrice: feePrice)
        popProvider.total.topDesc = totalA + " \(wallet.symbol)"
        popProvider.total.bottomDesc = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(totalA) ?? 0)
        popProvider.memo.topDesc = txInputInfo.note ?? ""
        
        return [popProvider.from, popProvider.to, popProvider.process, popProvider.total, popProvider.memo]
    }
    
    private func loadFeeData(callback: @escaping (TxFeeLevel?) -> Void) {
        TOPNetworkManager<ETHServices, GasSpeed>.requestModel(.getFeeList, success: { [weak self] gasSpeedModel in
            guard let self = self else { return }
            self.feePriceList = [gasSpeedModel.fastest, gasSpeedModel.average, gasSpeedModel.safeLow]
            let fastestAmount = self.getAmountStringWith(self.totalAmount(with: 0, feePrice: gasSpeedModel.fastest), self.wallet)
            let fastest = (gasSpeedModel.fastWait, gasSpeedModel.fastest, fastestAmount)
            let fastAmount = self.getAmountStringWith(self.totalAmount(with: 0, feePrice: gasSpeedModel.average), self.wallet)
            let fast = (gasSpeedModel.avgWait, gasSpeedModel.average, fastAmount)
            let normalAmount = self.getAmountStringWith(self.totalAmount(with: 0, feePrice: gasSpeedModel.safeLow), self.wallet)
            let normal = (gasSpeedModel.safeLowWait, gasSpeedModel.safeLow, normalAmount)
            let feeLevel = TxFeeLevel(fastest: fastest,
                                      fast: fast,
                                      normal: normal)
            callback(feeLevel)
            
        }) { _ in
            callback(nil)
        }
    }
    
    var feePrice: String!
    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        let totalAmount = FeeCaculator.getEthTotalAmountWith(Double(txInputInfo.amount) ?? 0, feePrice)
        if totalAmount.doubleValue > wallet.lastBalance {
            callback(ValidInputMessageType.toast("ETH 余额不足".localized()))
        } else {
            callback(ValidInputMessageType.success)
        }
    }
    
    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        let gasPrice = Int(Double(feePrice)! / 10 * pow(10, 9))
        let txInfo = EtherTxInfo(address: txInputInfo.to,
                                 ammount: SelectedTransacrionAmmount(inCrypto: txInputInfo.amount, inCurrency: "0"),
                                 data: (txInputInfo.note ?? "").toHexString(),
                                 fee: 0, // 换算成货币的价值，不用了
                                 gasPrice: gasPrice,
                                 gasLimit: txInputInfo.gasLimit)
        
        do {
            try (inject() as WalletBlockchainWrapperInteractorInterface).sendEthTransaction(wallet: wallet!, transacionDetial: txInfo, result: { txID in
                self.recordLocalTx(gasPrice: gasPrice, txhash: txID)
                callback((true, txID))
            }) { error in
                callback((false, error.message))
            }
            
        } catch {
            callback((false, error.localizedDescription))
        }
    }
    
    func totalAmount(with amount: Double, feePrice: String) -> String {
        let totalAmount = FeeCaculator.getEthTotalAmountWith(amount, feePrice)
        let num = NSDecimalNumber(string: String(format: "%.15f", totalAmount.doubleValue))
        return num.stringValue
    }
}

extension ETHSender {
    private func recordLocalTx(gasPrice: Int, txhash: String) {
        let fee = FeeCaculator.getETHfee(gasPrice: gasPrice)
        let localModel = LocalTxModel(txHash: txhash,
                                      from: wallet.address,
                                      to: txInputInfo.to,
                                      value: txInputInfo.amount,
                                      fee: fee,
                                      note: (txInputInfo.note ?? "").toHexString(),
                                      assetID: wallet.asset.assetID)
        LocalTxPool.pool.insertLocalTx(localTx: localModel, asset: wallet.asset)
    }
}
