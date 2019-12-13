//
//  TokenTransViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/9/20.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import TOPCore

class TokenSender: TxSenderProtocol {
    // 转账需要的参数
    var txInputInfo: SendTxInputInfo!
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
        var f = false
        loadFeeData { (txLevel) in
            if let level = txLevel {
                f = true
                self.feeLevel = level
            } else {
                f = false
            }
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            if f {
                callback(.success)
            } else {
                callback(ValidInputMessageType.toast("网络出走了，请检查网络状态后重试".localized()))
            }
        }
    }
    
    private var feePriceList: [String] = []
    private var popProvider = PopViewModelProvider()
    func getPopDatalist(feeIndex: Int) -> [SendPopViewModel] {
        feePrice = self.feePriceList[feeIndex]
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
        
        if _isContract {
            let totalA = totalAmount(with: Double(txInputInfo.amount) ?? 0, feePrice: feePrice)
            popProvider.total.topDesc = totalA + " \(wallet.chainSymbol)"
            popProvider.total.bottomDesc = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(totalA) ?? 0)
            return [popProvider.from, popProvider.to, popProvider.process, popProvider.total]
        } else {
            return [popProvider.from, popProvider.to, popProvider.process]
        }
    }
    
    private var ethbalanceModel: BalanceModel?
    private let _isContract: Bool
    var wallet: ViewWalletInterface!
    init(isContract: Bool = false, walletInfo: ViewWalletInterface) {
        _isContract = isContract
        wallet = walletInfo
    }
    
    func loadFeeData(callback: @escaping (TxFeeLevel?) -> Void) {
        TOPNetworkManager<ETHServices, GasSpeed>.requestModel(.getFeeList, success: { [weak self] gasSpeedModel in
            guard let self = self else { return }
            self.feePriceList = [gasSpeedModel.fastest, gasSpeedModel.average, gasSpeedModel.safeLow]
            let fastestAmount = self.getAmountStringWith(self.totalAmount(with: 0, feePrice: gasSpeedModel.fastest), self.wallet)
            let fastest = (gasSpeedModel.fastWait, gasSpeedModel.fastest ,fastestAmount)
            let fastAmount = self.getAmountStringWith(self.totalAmount(with: 0, feePrice: gasSpeedModel.average), self.wallet)
            let fast = (gasSpeedModel.avgWait, gasSpeedModel.average ,fastAmount)
            let normalAmount = self.getAmountStringWith(self.totalAmount(with: 0, feePrice: gasSpeedModel.safeLow), self.wallet)
            let normal = (gasSpeedModel.safeLowWait, gasSpeedModel.safeLow , normalAmount)
            let feeLevel = TxFeeLevel(fastest: fastest,
                                      fast: fast,
                                      normal: normal)
            callback(feeLevel)
        }) { _ in
            callback(nil)
        }
    }
    
    func loadData(callback: @escaping (Bool) -> Void) {
        TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getBalance(address: wallet.address), success: { [unowned self] balance in
            self.ethbalanceModel = balance
            callback(true)
            }, failure: { _ in
                callback(false)
        })
    }
    
    private var feePrice: String!
    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        if let model = ethbalanceModel {
            let balance = Double(model.balance) ?? 0
            
            let checkBalanceEnough: Bool
            if _isContract {
                let totalAmount = FeeCaculator.getEthTotalAmountWith(Double(txInputInfo.amount) ?? 0, feePrice).doubleValue
                checkBalanceEnough = totalAmount < balance
            } else {
                let fee: NSNumber
                if _isContract {
                    fee = FeeCaculator.getETHGas(gas: Double(feePrice)! / 10, gasLimit: txInputInfo.gasLimit)
                } else {
                    fee = FeeCaculator.getETHGas(gas: Double(feePrice)! / 10)
                }
                checkBalanceEnough = fee.doubleValue < balance
            }
            if checkBalanceEnough {
                callback(ValidInputMessageType.success)
            } else {
                callback(ValidInputMessageType.toast("ETH 余额不足以支付手续费，请充值".localized()))
            }
            
        } else {
            TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getBalance(address: wallet.address), success: { [unowned self] balance in
                self.ethbalanceModel = balance
                self.confirmVerify(callback: callback)
                }, failure: { _ in
                    callback(ValidInputMessageType.toast("网络出走了，请检查网络状态后重试".localized()))
            })
        }
    }
    
    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        let gasPrice = Int(Double(feePrice)! / 10 * pow(10, 9))
        let dataStr = _isContract ? txInputInfo.note ?? "" : "0x"
        let txInfo = EtherTxInfo(address: txInputInfo.to,
                                 ammount: SelectedTransacrionAmmount(inCrypto: txInputInfo.amount, inCurrency: "0"),
                                 data: dataStr,
                                 fee: 0,
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
    
    // Token 与 Eth 币种计算方式不一样，所以计算成法币的总额
    func totalAmount(with amount: Double, feePrice: String) -> String {
        var totalAmount = FeeCaculator.getEthTotalAmountWith(amount, feePrice)
        if _isContract {
            totalAmount = FeeCaculator.getEthTotalAmountWith(amount, feePrice, txInputInfo.gasLimit)
        }
        let num = NSDecimalNumber(string: String(format: "%.15f", totalAmount.doubleValue))
        return num.stringValue
    }
}

extension TokenSender {
    private func recordLocalTx(gasPrice: Int,txhash: String) {
        let fee: String
        if _isContract {
            fee = FeeCaculator.getETHfee(gasPrice: gasPrice, gasLimit: txInputInfo.gasLimit)
        } else {
            fee = FeeCaculator.getETHfee(gasPrice: gasPrice)
        }
        
        let localModel = LocalTxModel(txHash: txhash,
                                      from: wallet.address,
                                      to: txInputInfo.to,
                                      value: txInputInfo.amount,
                                      fee: fee,
                                      note: txInputInfo.note ?? "",
                                      assetID: wallet.asset.assetID)
        LocalTxPool.pool.insertLocalTx(localTx: localModel, asset: wallet.asset)
    }
}
