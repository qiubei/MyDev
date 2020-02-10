//
//  ETHTxSender.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

enum ETHTxSenderType {
    case Eth
    case Token
    case Dapp
}

class ETHTxSender: TxSenderProtocol {
    var txInputInfo: SendTxInputInfo!
    
    private let wallet: ViewWalletInterface
    private let type: ETHTxSenderType
    init(type: ETHTxSenderType, wallet: ViewWalletInterface) {
        self.type = type
        self.wallet = wallet
    }
    
    private var ethbalanceModel: BalanceModel!
    /// Preloading data. you should call this method first
    func loadData(callback: @escaping (Bool) -> Void) {
        TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getBalance(address: wallet.address), success: { [weak self] balance in
            self?.ethbalanceModel = balance
            callback(true)
            }, failure: { _ in
                callback(false)
        })
    }
    
    private var feePriceList: [String]? {
        if feeLevel == nil { return nil }
        return [feeLevel.fastest.amount, feeLevel.fast.amount, feeLevel.normal.amount]
    }
    private var feeLevel: TxFeeLevel!
    /// you can check out the input info in chain
    /// - Parameters:
    ///   - inputInfo: the input info from UI
    ///   - callback: callback the result of checking out in chian
    func checkInputInChain(_ inputInfo: SendTxInputInfo, callback: @escaping (ValidInputMessageType) -> Void) {
        switch type {
        case .Dapp: break
        default:
            // 小数点位数
            guard getdigitNumber(value: inputInfo.amount) <= 8 else {
                callback(ValidInputMessageType.toast("小数点不能超过8位！".localized()))
                return
            }
        }
        // 加载链上数据
        loadFeeData { (txLevel) in
            if let level = txLevel {
                self.feeLevel = level
                callback(.success)
            } else {
                callback(ValidInputMessageType.toast("网络出走了，请检查网络状态后重试".localized()))
            }
        }
        self.txInputInfo = inputInfo
    }
    
    private var choseFeePrice: String!
    private var provider = PopViewModelProvider()
    /// the data list of displaying in popview controller
    /// - Parameter feeIndex: the gas price index of you chose.
    func getPopDatalist(feeIndex: Int) -> [SendPopViewModel] {
        choseFeePrice = feePriceList?[feeIndex]
        
        let contact = TOPStore.shared.currentUser.addressBook.filter { $0.address == self.txInputInfo.to }.first
        provider.from.topDesc = wallet.name
        provider.from.bottomDesc = wallet.address
        provider.to.topDesc = contact?.note ?? ""
        provider.to.bottomDesc = self.txInputInfo.to
        let feeList = provider.createTxFeeList(txLevel: feeLevel)
        let selectedFee = feeList[feeIndex]
        provider.process.topDesc = selectedFee.speedDesc
        provider.process.bottomDesc = selectedFee.Fee
        provider.process.nextList = feeList
        
        switch type {
        case .Eth:
            let totalA = totalAmount(with: Double(txInputInfo.amount) ?? 0, feePrice: choseFeePrice)
            provider.total.topDesc = totalA + " \(wallet.symbol)"
            provider.total.bottomDesc = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(totalA) ?? 0)
            provider.memo.topDesc = txInputInfo.note ?? ""
            
            return [provider.from, provider.to, provider.process, provider.total, provider.memo]
        case .Dapp:
            let totalA = totalAmount(with:  Double(txInputInfo.amount) ?? 0, feePrice: choseFeePrice)
            provider.total.topDesc = totalA + " \(wallet.chainSymbol)"
            provider.total.bottomDesc = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(totalA) ?? 0)
            
            return [provider.from, provider.to, provider.process, provider.total]
        default:
            return [provider.from, provider.to, provider.process]
        }
    }
    
    /// verify the tx info in chain
    /// - Parameter callback: callback the result of verifying in chiain
    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        let totalAmount = FeeCaculator.getEthTotalAmountWith(Double(txInputInfo.amount) ?? 0, choseFeePrice)
        
        if let model = ethbalanceModel {
            let balance = Double(model.balance) ?? 0
            var checkBalanceEnough: Bool = false
            var toastString: String = "ETH 余额不足".localized()
            
            switch type {
            case .Eth:
                checkBalanceEnough = totalAmount.doubleValue < balance
            case .Token:
                let fee = FeeCaculator.getETHGas(gas: Double(choseFeePrice)! / 10)
                checkBalanceEnough = fee.doubleValue < balance
                toastString = "ETH 余额不足以支付手续费，请充值".localized()
            case .Dapp:
                let fee = FeeCaculator.getEthTotalAmountWith(Double(txInputInfo.amount) ?? 0,
                                                             choseFeePrice,
                                                             txInputInfo.gasLimit)
                checkBalanceEnough = fee.doubleValue < balance
            }
            
            if checkBalanceEnough {
                callback(ValidInputMessageType.success)
            } else {
                callback(ValidInputMessageType.toast(toastString))
            }
        } else {
            loadData { [weak self] (success) in
                guard let self = self else { return }
                if success {
                    self.confirmVerify(callback: callback)
                } else {
                    callback(ValidInputMessageType.toast("网络出走了，请检查网络状态后重试".localized()))
                }
            }
        }
    }
    
    /// send tx to chain
    /// - Parameter callback: callback the result of sending tx
    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        let gasPrice = Int(Double(choseFeePrice)! / 10 * pow(10, 9))
        var dataStr = txInputInfo.note ?? ""
        switch type {
        case .Eth:
            dataStr = dataStr.toHexString()
        case .Token:
            dataStr = "0x"
        case .Dapp: break
        }
        
        let txInfo = EtherTxInfo(address: txInputInfo.to,
                                 ammount: SelectedTransacrionAmmount(inCrypto: txInputInfo.amount, inCurrency: "0"),
                                 data: dataStr,
                                 fee: 0,
                                 gasPrice: gasPrice,
                                 gasLimit: txInputInfo.gasLimit)
        
        do {
            try (inject() as WalletBlockchainWrapperInteractorInterface).sendEthTransaction(wallet: wallet, transacionDetial: txInfo, result: { txID in
                self.recordLocalTx(gasPrice: gasPrice, txhash: txID)
                self.uploadRewead(txID: txID)
                callback((true, txID))
            }) { error in
                callback((false, error.message))
            }
            
        } catch {
            callback((false, error.localizedDescription))
        }
    }
    
    /// caculate the total amount, the way is different to Eth, Token and Dapp.
    /// - Parameters:
    ///   - amount: the value of sending tx
    ///   - feePrice: the gas price you chose.
    func totalAmount(with amount: Double, feePrice: String) -> String {
        var totalAmount = FeeCaculator.getEthTotalAmountWith(amount, feePrice)
        switch type {
        case .Dapp:
            totalAmount = FeeCaculator.getEthTotalAmountWith(amount, feePrice, txInputInfo.gasLimit)
        default: break
        }
        
        let num = NSDecimalNumber(string: String(format: "%.15f", totalAmount.doubleValue))
        return num.stringValue
    }
}


//MARK: - Private Method

extension ETHTxSender {
    
    /// load tx fee level from chain.
    /// e.g. : fastest, average, slow
    /// - Parameter callback: callback different tx fee
    private func loadFeeData(callback: @escaping (TxFeeLevel?) -> Void) {
        TOPNetworkManager<ETHServices, GasSpeed>.requestModel(.getFeeList, success: { [weak self] gasSpeedModel in
            guard let self = self else { return }
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
    
    /// add tx record to local database
    /// - Parameters:
    ///   - gasPrice: the gas price of the record
    ///   - txhash: the txhash of the record
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
