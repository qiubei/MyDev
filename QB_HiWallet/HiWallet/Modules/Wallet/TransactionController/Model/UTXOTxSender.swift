//
//  UTXOTxSender.swift
//  HiWallet
//
//  Created by Jax on 2019/9/20.
//  Copyright © 2019 TOP. All rights reserved.
//

import EssentiaBridgesApi
import Foundation
import TOPCore

class UTXOTxSender: TxSenderProtocol {
    var txInputInfo: SendTxInputInfo!
    var wallet: ViewWalletInterface!
    var utxoService: UtxoWalletUnterface?
    var utxo: [UnspentTransaction] = []
    
    private let utxoCoin: ChainType

    private var isBtc: Bool {
        return utxoCoin == .bitcoin
    }

    init(walletInfo: ViewWalletInterface) {
        wallet = walletInfo
        let cryptoWallet = CryptoWallet(
            bridgeApiUrl: "https://b3.essentia.network/api/v1",
            etherScanApiKey: "")
        utxoCoin = wallet.asset as? ChainType ?? .bitcoin
        utxoService = cryptoWallet.utxoWallet(coin: utxoCoin)
    }
    
    private let decimalNumber = 8
    func checkInputInChain(_ inputInfo: SendTxInputInfo, callback: @escaping (_ result: ValidInputMessageType) -> Void) {
        // 小数点位数
        guard getdigitNumber(value: inputInfo.amount) <= decimalNumber else {
            callback(ValidInputMessageType.toast("小数点不能超过8位！".localized()))
            return
        }
        guard let amount = Double(inputInfo.amount) else {
            callback(ValidInputMessageType.toast("输入金额有误".localized()))
            return
        }
        // 不能小于0.0000273
        if amount < 0.0000273 {
            callback(ValidInputMessageType.toast("低于最小发送金额".localized()))
            return
        }
        // 上一笔交易还在确认中
        if utxo.isEmpty || utxo.sum() < BitcoinConverter(bitcoin: amount).inSatoshi {
            callback(ValidInputMessageType.alert("前一笔交易正在处理中，请稍后再试。".localized()))
            return
        }
        
        self.txInputInfo = inputInfo
        
        // 加载链上数据
        let group = DispatchGroup()
        var f = false
        group.enter()
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
    
    func loadData(callback: @escaping (Bool) -> Void) {
        utxoService!.getUtxo(for: wallet!.address) { result in
            switch result {
            case let .success(transactions):
                self.utxo = transactions.map { $0.unspendTx }
                callback(true)
            case .failure:
                self.utxo = []
                callback(false)
            }
        }
    }
    
    private var feePriceList: [String] = []
    private var feeLevel: TxFeeLevel!
    private func loadFeeData(callback: @escaping (TxFeeLevel?) -> Void) {
        if isBtc {
            TOPNetworkManager<BTCServices, BtcFeeList>.requestModel(.getFeeList, success: { [weak self] model in
                guard let self = self else { return }
                self.feeLevel = self.creatTxFeeLevel(model: model)
                callback(self.feeLevel)
            }) { _ in
                callback(nil)
            }
        } else {
            let model = BtcFeeList.defautFee()
            feeLevel = creatTxFeeLevel(model: model)
            callback(feeLevel)
        }
    }
    
    private func creatTxFeeLevel(model: BtcFeeList) -> TxFeeLevel {
        let fastest = ("20", model.fastestFee,self.getAmountStringWith(self.totalAmount(with: 0, feePrice: model.fastestFee), self.wallet))
        let fast = ("30", model.halfHourFee,self.getAmountStringWith(self.totalAmount(with: 0, feePrice: model.halfHourFee), self.wallet))
        let normal = ("60", model.hourFee, self.getAmountStringWith(self.totalAmount(with: 0, feePrice: model.hourFee), self.wallet))
        self.feePriceList = [model.fastestFee, model.halfHourFee, model.hourFee]
        return TxFeeLevel(fastest: fastest,
                          fast: fast,
                          normal: normal)
    }
    
    private var popProvider = PopViewModelProvider()
    private var feePrice: String!
    func getPopDatalist(feeIndex: Int) -> [SendPopViewModel] {
        feePrice = feePriceList[feeIndex]
        // 本地联系人
        let contact = TOPStore.shared.currentUser.addressBook.filter { $0.address == self.txInputInfo.to }.first
        popProvider.from.topDesc = wallet.name
        popProvider.from.bottomDesc = wallet.address
        popProvider.to.topDesc = contact?.note ?? ""
        popProvider.to.bottomDesc = self.txInputInfo.to
        
        var feeList = popProvider.createTxLevelList(txLevel: feeLevel)
        if isBtc {
            feeList = popProvider.createTxFeeList(txLevel: feeLevel)
        }
        let selectedFee = feeList[feeIndex]
        popProvider.process.topDesc = selectedFee.speedDesc
        popProvider.process.bottomDesc = selectedFee.Fee
        popProvider.process.nextList = feeList
        
        let totalA = totalAmount(with: Double(txInputInfo.amount) ?? 0, feePrice: feePrice)
        popProvider.total.topDesc = totalA + " \(wallet.symbol)"
        popProvider.total.bottomDesc = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(totalA) ?? 0)
        
        if !isBtc {
            return [popProvider.from, popProvider.to, popProvider.fee, popProvider.total]
        }
        return [popProvider.from, popProvider.to, popProvider.process, popProvider.total]
    }
    
    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        if getTotalAmount(feePrice: feePrice) > wallet.lastBalance {
            callback(ValidInputMessageType.toast("余额不足".localized()))
        } else {
            callback(ValidInputMessageType.success)
        }
    }
    
    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        do {
            let rawTx = try createRawTx(feePrice: feePrice)
            utxoService!.sendTransaction(with: rawTx) { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case let .success(object):
                    self.recordLocalTx(feePrice: self.feePrice, txhash: object.txid)
                    callback((true, ""))
                    
                case let .failure(error):
                    callback((false, error.localizedDescription))
                }
            }
        } catch {
            callback((false, "经链上计算，账户余额不足以支付手续费".localized()))
        }
    }
    
    private func getTotalAmount(feePrice: String) -> Double {
        return FeeCaculator.getBTCTotalAmountWith(utxo, Double(txInputInfo.amount) ?? 0, feePrice).doubleValue
    }
    
    func totalAmount(with amount: Double, feePrice: String) -> String {
        let totalAmount = FeeCaculator.getBTCTotalAmountWith(utxo, amount, feePrice)
        let num = NSDecimalNumber(string: String(format: "%.15f", totalAmount.doubleValue))
        return num.stringValue
    }
}

extension UTXOTxSender {
    private func recordLocalTx(feePrice: String, txhash: String) {
        let localModel = LocalTxModel(txHash: txhash,
                                      from: wallet.address,
                                      to: txInputInfo.to,
                                      value: txInputInfo.amount,
                                      fee: feePrice,
                                      note: txInputInfo.note ?? "",
                                      assetID: wallet.asset.assetID)
        
        LocalTxPool.pool.insertLocalTx(localTx: localModel, asset: wallet.asset)
    }
    
    private func createRawTx(feePrice: String) throws -> String {
        let privateKey = PrivateKey(pk: wallet!.privateKey, coin: wrapCoin(coin: utxoCoin))!
        let utxoSelector = UtxoSelector(feePerByte: UInt64(Float(feePrice)!), dustThreshhold: 2730)
        let utxoWallet = UTXOWallet(privateKey: privateKey,
                                    utxoSelector: utxoSelector,
                                    utxoTransactionBuilder: UtxoTransactionBuilder(),
                                    utoxTransactionSigner: UtxoTransactionSigner())
        let address = try LegacyAddress(txInputInfo.to, coin: wrapCoin(coin: utxoCoin))
        return try utxoWallet.createTransaction(to: address, amount: BitcoinConverter(bitcoin: Double(txInputInfo.amount) ?? 0).inSatoshi, utxos: utxo)
    }
}

extension UtxoResponce {
    fileprivate var unspendTx: UnspentTransaction {
        let lockingScript: Data = Data(hex: scriptPubKey)
        let txidData: Data = Data(hex: String(txid))
        let txHash: Data = Data(txidData.reversed())
        let output = TransactionOutput(value: UInt64(satoshis), lockingScript: lockingScript)
        let outpoint = TransactionOutPoint(hash: txHash, index: UInt32(vout))
        return UnspentTransaction(output: output, outpoint: outpoint)
    }
}

extension Sequence where Element == UnspentTransaction {
    func sum() -> UInt64 {
        return reduce(UInt64()) { $0 + $1.output.value }
    }
}
