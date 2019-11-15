//
//  UTXOTransViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/9/20.
//  Copyright © 2019 TOP. All rights reserved.
//

import EssentiaBridgesApi
import Foundation
import HDWalletKit
import TOPCore

class UTXOTransViewModel: TranstonInterface {
    var gasLimit: Int = 0
    var address: String = "" // 地址
    var amount: String = "" // 数量
    var note: String = "" // 备注不可用
    var selectFeeIndex: Int = 0

    var wallet: ViewWalletInterface!
    var btcfee: BtcFeeList? // btc
    var utxo: [UnspentTransaction] = []
    var utxoService: UtxoWalletUnterface?
    var feeList: [NormalPopModel]!
    var feePrice: [String]!
    var dataList: [SendPopViewModel]!

    func loadFeeData(callback: @escaping (Bool) -> Void) {
        TOPNetworkManager<BTCServices, BtcFeeList>.requestModel(.getFeeList, success: { model in
            self.btcfee = model
            callback(true)
        }) { _ in
            callback(false)
        }
    }

    func loadData(callback: @escaping (Bool) -> Void) {
        utxoService!.getUtxo(for: wallet!.address) { result in
            switch result {
            case let .success(transactions):
                self.utxo = transactions.map { $0.unspendTx }
            case .failure:
                self.utxo = []
            }
        }
    }

    func validInput() -> ValidInputMessageType {
        // 数量为空

        if let amountValue = Double(amount) {
            // 数量大于余额（不包含fee）
            guard wallet.lastBalance > amountValue else {
                return ValidInputMessageType.toast("余额不足".localized())
            }
            // 地址无效
            guard address.count > 0 && wallet.asset.isValidAddress(address) else {
                return ValidInputMessageType.toast("请输入有效地址".localized())
            }

            // 小数点位数
            guard getdigitNumber(value: amount) <= 8 else {
                return ValidInputMessageType.toast("小数点不能超过8位！".localized())
            }

            // 不能小于0.0000273
            if amountValue < 0.0000273 {
                return ValidInputMessageType.toast("低于最小发送金额".localized())
            }

            if utxo.isEmpty || utxo.sum() < BitcoinConverter(bitcoin: amountValue).inSatoshi {
                return ValidInputMessageType.alert("前一笔交易正在处理中，请稍后再试。".localized())
            }
        } else {
            return ValidInputMessageType.toast("输入金额有误".localized())
        }
        return ValidInputMessageType.success
    }

    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        if getTotalAmount().doubleValue > wallet.lastBalance {
            callback(ValidInputMessageType.toast("余额不足".localized()))
        } else {
            callback(ValidInputMessageType.success)
        }
    }

    init(walletInfo: ViewWalletInterface) {
        wallet = walletInfo
        let cryptoWallet = CryptoWallet(
            bridgeApiUrl: "https://b3.essentia.network/api/v1",
            etherScanApiKey: "")
        utxoService = cryptoWallet.utxoWallet(coin: .bitcoin)
    }

    func getPopData() -> [SendPopViewModel] {
        // 本地联系人
        let contact = TOPStore.shared.currentUser.addressBook.filter { $0.address == self.address }.first

        // 发送人
        let fromModel = SendPopViewModel(title: "从".localized(), topDesc: wallet.name, bottomDesc: wallet.address)
        // 接受人
        let toModel = SendPopViewModel(title: "发送到".localized(), topDesc: contact?.note ?? "", bottomDesc: address)
        // 速度
        let fastSpeed = NormalPopModel(speedDesc: "20分钟内".localized(),
                                       Fee: getBtcFeeDesc(sat: btcfee!.fastestFee),
                                       image: #imageLiteral(resourceName: "icon_tx_speed_fast"))
        let fastSpeed2 = NormalPopModel(speedDesc: "30分钟内".localized(),
                                        Fee: getBtcFeeDesc(sat: btcfee!.halfHourFee),
                                        image: #imageLiteral(resourceName: "icon_tx_speed_normal"))
        let fastSpeed3 = NormalPopModel(speedDesc: "1小时内".localized(),
                                        Fee: getBtcFeeDesc(sat: btcfee!.hourFee),
                                        image: #imageLiteral(resourceName: "icon_tx_speed_slow"))

        feeList = [fastSpeed, fastSpeed2, fastSpeed3]
        feePrice = [btcfee!.fastestFee, btcfee!.halfHourFee, btcfee!.hourFee]
        // 默认选中中间
        // 时间
        let processingModel = SendPopViewModel(title: "到账时间".localized(), topDesc: fastSpeed2.speedDesc, bottomDesc: fastSpeed2.Fee, nextList: feeList)

        let totalModel = SendPopViewModel(title: "总计".localized(), topDesc: "\(getTotalAmount())" + " BTC", bottomDesc: BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: getTotalAmount().doubleValue))

        dataList = [fromModel, toModel, processingModel, totalModel]
        selectFeeIndex = 1
        dataList = reloadPopDataWithIndex(index: selectFeeIndex)
        return dataList
    }

    func reloadPopDataWithIndex(index: Int) -> [SendPopViewModel] {
        selectFeeIndex = index
        let speed = feeList[selectFeeIndex]

        // 更新选择
        let processingModel = SendPopViewModel(title: "到账时间".localized(), topDesc: speed.speedDesc, bottomDesc: speed.Fee, nextList: feeList)
        dataList[2] = processingModel

        // 更新总额度
        let totalModel = SendPopViewModel(title: "总计".localized(), topDesc: "\(getTotalAmount())" + " BTC", bottomDesc: BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: getTotalAmount().doubleValue))
        dataList[3] = totalModel

        return dataList
    }

    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        do {
            let rawTx = try createRawTx()
            utxoService!.sendTransaction(with: rawTx) { [weak self] in
                switch $0 {
                case let .success(object):
                    self?.recordLocalTx(txhash: object.txid)
                    callback((true, ""))

                case let .failure(error):
                    callback((false, error.description))
                }
            }
        } catch {
            callback((false, "经链上计算，账户余额不足以支付手续费".localized()))
        }
    }

    func selectFee(index: Int) {
        selectFeeIndex = index
    }

    func recordLocalTx(txhash: String) {
        let localModel = LocalTxModel(txHash: txhash,
                                      from: wallet.address,
                                      to: address,
                                      value: amount,
                                      fee: getfee(),
                                      note: note,
                                      assetID: wallet.assetID)

        LocalTxPool.pool.insertLocalTx(localTx: localModel, asset: wallet.asset)
    }

    private func getfee() -> String {
        var fee = ""
        switch selectFeeIndex {
        case 0:
            fee = "\(getBtcFee(sat: btcfee!.fastestFee))"
        case 1:
            fee = "\(getBtcFee(sat: btcfee!.halfHourFee))"
        case 2:
            fee = "\(getBtcFee(sat: btcfee!.hourFee))"
        default:
            break
        }
        return fee
    }
}

extension UTXOTransViewModel {
    func getTotalAmount() -> NSNumber {
        let fee = getBtcFee(sat: feePrice[selectFeeIndex]).doubleValue
        let num = NSDecimalNumber(string: String(format: "%.8f", Double(amount)! + fee))
        return num
    }

    func getBtcFeeDesc(sat: String) -> String {
        return "\(getBtcFee(sat: sat))" + " BTC" + "≈ \(BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: getBtcFee(sat: sat).doubleValue))"
    }

    func getBtcFee(sat: String) -> NSNumber {
        do {
            let feeInSatoshi = try calculateFee(fee: sat)
            return NSDecimalNumber(string: String(format: "%.15f", Double(BitcoinConverter(satoshi: feeInSatoshi).inBitcoin)))
        } catch {
            return NSDecimalNumber(string: String(format: "%.15f", Double(sat)! / 100000000.0 * 226))
        }
    }

    func calculateFee(fee: String) throws -> UInt64 {
        let utxoSelector = UtxoCalculater(feePerByte: UInt64(Float(fee)!), dustThreshhold: 2730)
        let selectedTx = try utxoSelector.select(from: utxo, targetValue: BitcoinConverter(bitcoin: Double(amount) ?? 0).inSatoshi)
        return selectedTx.fee
    }

    // 获取小数位数
    func getdigitNumber(value: String) -> Int {
        if let range = value.range(of: ".") {
            let number = String(value[range.upperBound...]).count
            return number
        }
        return 0
    }

    func createRawTx() throws -> String {
        let privateKey = PrivateKey(pk: wallet!.privateKey, coin: wrapCoin(coin: .bitcoin))!
        let utxoSelector = UtxoSelector(feePerByte: UInt64(Float(feePrice[selectFeeIndex])!), dustThreshhold: 2730)
        let utxoWallet = UTXOWallet(privateKey: privateKey,
                                    utxoSelector: utxoSelector,
                                    utxoTransactionBuilder: UtxoTransactionBuilder(),
                                    utoxTransactionSigner: UtxoTransactionSigner())
        let address = try LegacyAddress(self.address, coin: wrapCoin(coin: .bitcoin))
        return try utxoWallet.createTransaction(to: address, amount: BitcoinConverter(bitcoin: Double(amount) ?? 0).inSatoshi, utxos: utxo)
    }
}

extension Sequence where Element == UnspentTransaction {
    func sum() -> UInt64 {
        return reduce(UInt64()) { $0 + $1.output.value }
    }
}

extension UtxoResponce {
    var unspendTx: UnspentTransaction {
        let lockingScript: Data = Data(hex: scriptPubKey)
        let txidData: Data = Data(hex: String(txid))
        let txHash: Data = Data(txidData.reversed())
        let output = TransactionOutput(value: UInt64(satoshis), lockingScript: lockingScript)
        let outpoint = TransactionOutPoint(hash: txHash, index: UInt32(vout))
        return UnspentTransaction(output: output, outpoint: outpoint)
    }
}
