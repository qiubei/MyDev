//
//  TokenTransViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/9/20.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import HDWalletKit
import TOPCore

class TokenTransViewModel: TranstonInterface {
    // 转账需要的参数
    var address: String = ""
    var amount: String = ""
    var note: String = "" //token不需要
    var wallet: ViewWalletInterface!

    var gasLimit: Int = 100000 //智能合约调用是外部传进来的
    private var gasPrice: Int = 100000

    private var selectFeeIndex: Int = 0

    private var ethFee: GasSpeed! // 以太坊gas
    private var feeList: [NormalPopModel]! // 以太坊gas
    private var feePrice: [String]! // 以太坊gas
    private var dataList: [SendPopViewModel]!
    private var ethbalanceModel: BalanceModel?

    init(walletInfo: ViewWalletInterface) {
        wallet = walletInfo
    }

    func loadFeeData(callback: @escaping (Bool) -> Void) {
        TOPNetworkManager<ETHServices, GasSpeed>.requestModel(.getFeeList, success: { gasSpeedModel in
            self.ethFee = gasSpeedModel
            callback(true)

        }) { _ in
            callback(false)
        }

        TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getBalance(address: wallet.address), success: { [unowned self] balance in
            self.ethbalanceModel = balance
        }, failure: { _ in

        })
    }

    func loadData(callback: (Bool) -> Void) {
    }

    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        if let model = ethbalanceModel {
            let balance = Double(model.balance) ?? 0
            let fee = feePrice[self.selectFeeIndex]
            if getFreeWithGas(gasPrice: fee) < balance {
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

    func validInput() -> ValidInputMessageType {
        if let amountValue = Double(amount) {
            // 数量大于余额（不包含fee）
            guard wallet.lastBalance >= amountValue else {
                return ValidInputMessageType.toast("余额不足".localized())
            }

            // 地址无效
            guard address.count > 0 && wallet.asset.isValidAddress(address) else {
                return ValidInputMessageType.toast("请输入有效地址".localized())
            }
        } else {
            return ValidInputMessageType.toast("输入金额有误".localized())
        }
        return ValidInputMessageType.success
    }

    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        let txInfo = EtherTxInfo(address: address,
                                 ammount: SelectedTransacrionAmmount(inCrypto: amount, inCurrency: "0"),
                                 data: "0x",
                                 fee: 0, // 换算成货币的价值，不用了
                                 gasPrice: gasPrice,
                                 gasLimit: gasLimit)

        do {
            try (inject() as WalletBlockchainWrapperInteractorInterface).sendEthTransaction(wallet: wallet!, transacionDetial: txInfo, result: {
                switch $0 {
                case let .success(txID):
                    self.recordLocalTx(txhash: txID)
                    callback((true, ""))

                case let .failure(error):
                    callback((false, error))
                }

            })
        } catch {
            callback((false, error.localizedDescription))
        }
    }

    func selectFee(index: Int) {
        selectFeeIndex = index
    }

    func getPopData() -> [SendPopViewModel] {
        // 本地联系人
        let contact = TOPStore.shared.currentUser.addressBook.filter { $0.address == self.address }.first

        // 发送人
        let fromModel = SendPopViewModel(title: "从".localized(), topDesc: wallet.name, bottomDesc: wallet.address)
        // 接受人
        let toModel = SendPopViewModel(title: "发送到".localized(), topDesc: contact?.note ?? "", bottomDesc: address)

        // 速度
        let fastSpeed = NormalPopModel(speedDesc: String(format: "预计 %@ 分钟内".localized(), ethFee!.fastWait),
                                       Fee: getAmountWithSymble(value: getFreeWithGas(gasPrice: ethFee!.fastest)) + BalanceFormatter.getCurreyPrice(value: getFreeWithGas(gasPrice: ethFee!.fastest)),
                                       image: #imageLiteral(resourceName: "icon_tx_speed_fast"))
        let fastSpeed2 = NormalPopModel(speedDesc: String(format: "预计 %@ 分钟内".localized(), ethFee!.avgWait),
                                        Fee: getAmountWithSymble(value: getFreeWithGas(gasPrice: ethFee!.average)) + BalanceFormatter.getCurreyPrice(value: getFreeWithGas(gasPrice: ethFee!.average)),
                                        image: #imageLiteral(resourceName: "icon_tx_speed_normal"))
        let fastSpeed3 = NormalPopModel(speedDesc: String(format: "预计 %@ 分钟内".localized(), ethFee!.safeLowWait),
                                        Fee: getAmountWithSymble(value: getFreeWithGas(gasPrice: ethFee!.safeLow)) + BalanceFormatter.getCurreyPrice(value: getFreeWithGas(gasPrice: ethFee!.safeLow)),
                                        image: #imageLiteral(resourceName: "icon_tx_speed_slow"))

        feeList = [fastSpeed, fastSpeed2, fastSpeed3]
        feePrice = [ethFee!.fastest, ethFee!.average, ethFee!.safeLow]
        let processingModel = SendPopViewModel(title: "到账时间".localized(), topDesc: "", bottomDesc: "", nextList: feeList)

        dataList = [fromModel, toModel, processingModel]
        // 默认选中中间
        selectFeeIndex = 1
        dataList = reloadPopDataWithIndex(index: selectFeeIndex)
        return dataList
    }

    func reloadPopDataWithIndex(index: Int) -> [SendPopViewModel] {
        let speed = feeList[index]
        selectFeeIndex = index

        // 更新选择
        let processingModel = SendPopViewModel(title: "到账时间".localized(), topDesc: speed.speedDesc, bottomDesc: speed.Fee, nextList: feeList)

        gasPrice = Int(Double(feePrice[index])! / 10 * pow(10, 9))
        dataList[2] = processingModel

        return dataList
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
}

extension TokenTransViewModel {
    func getAmountWithSymble(value: Double) -> String {
        let num2 = NSDecimalNumber(string: String(format: "%.15f", value))
        return String(format: "%@ ETH", num2)
    }

    func getFreeWithGas(gasPrice: String) -> Double {
        return getETHGas(gas: Double(gasPrice)! / 10).doubleValue
    }

    // gas转
    func getETHGas(gas: Double) -> NSNumber {
        let num = Int(gas * pow(10, 9))
        let str = "\(num)"
        let bigInt = BInt(str)! * BInt("21000")! // 计算费用按照21000，发送的时候，sgasLimit设置为1000000
        let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(bigInt)")
        let num2 = NSDecimalNumber(string: String(format: "%.15f", gasValue))
        return num2
    }

    private func getfee() -> String {
        let gas = BInt(gasPrice) * BInt("21000")!
        let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(gas)")
        let fee = NSDecimalNumber(string: String(format: "%.15f", gasValue))
        return "\(fee)"
    }
}
