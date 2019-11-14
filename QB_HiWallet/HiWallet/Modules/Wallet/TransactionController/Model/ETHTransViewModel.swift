//
//  ETHTransViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore
import HDWalletKit

class ETHTransViewModel: TranstonInterface {
    // 转账需要的参数
    var address: String = ""
    var amount: String = ""
    var note: String = ""
    var selectFeeIndex: Int = 0
    var gasLimit: Int = 100000
    var gasPrice: Int = 0

    var wallet: ViewWalletInterface!
    var ethFee: GasSpeed! // 以太坊gas

    var feeList: [NormalPopModel]! // 以太坊gas
    var feePrice: [String]! // 以太坊gas
    var dataList: [SendPopViewModel]!

    private lazy var chainWrapper: WalletBlockchainWrapperInteractorInterface = inject()

    func loadFeeData(callback: @escaping (Bool) -> Void) {
        TOPNetworkManager<ETHServices, GasSpeed>.requestModel(.getFeeList, success: { gasSpeedModel in
            self.ethFee = gasSpeedModel
            callback(true)

        }) { _ in
            callback(false)
        }
    }

    func loadData(callback: (Bool) -> Void) {
    }

    func sendTranstion(callback: @escaping ((Bool, String)) -> Void) {
        let txInfo = EtherTxInfo(address: address,
                                 ammount: SelectedTransacrionAmmount(inCrypto: amount, inCurrency: "0"),
                                 data: note.toHexString(),
                                 fee: 0, // 换算成货币的价值，不用了
                                 gasPrice: gasPrice,
                                 gasLimit: gasLimit)

        do {
            try chainWrapper.sendEthTransaction(wallet: wallet!, transacionDetial: txInfo, result: {
                Toast.hideHUD()
                switch $0 {
                case let .success(txHash):
                    callback((true, txHash))

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

    func validInput() -> ValidInputMessageType {
        if let amountValue = Double(amount) {
            // 数量大于余额（不包含fee）
            guard wallet.lastBalance >= amountValue else {
                return ValidInputMessageType.toast("ETH 余额不足".localized())
            }
            // 地址无效
            guard address.count > 0 && wallet.asset.isValidAddress(address) else {
                return ValidInputMessageType.toast("请输入有效地址".localized())
            }

            // 小数点位数
            guard getdigitNumber(value: amount) <= 8 else {
                return ValidInputMessageType.toast("小数点不能超过8位！".localized())
            }
            return ValidInputMessageType.success

        } else {
            return ValidInputMessageType.toast("输入金额有误".localized())
        }
    }

    func confirmVerify(callback: @escaping (ValidInputMessageType) -> Void) {
        if getTotalAmount().doubleValue > wallet.lastBalance {
            callback(ValidInputMessageType.toast("ETH 余额不足".localized()))
        } else {
            callback(ValidInputMessageType.success)
        }
    }

    init(walletInfo: ViewWalletInterface) {
        wallet = walletInfo
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

        // 时间
        let processingModel = SendPopViewModel(title: "到账时间".localized(), topDesc: fastSpeed2.speedDesc, bottomDesc: fastSpeed2.Fee, nextList: feeList)

        let totalModel = SendPopViewModel(title: "总计".localized(), topDesc: "\(getTotalAmount())" + "ETH", bottomDesc: BalanceFormatter.getCurreyPrice(value: getTotalAmount().doubleValue))
        let memoModel = SendPopViewModel(title: "备注tx".localized(), topDesc: note, bottomDesc: "")

        dataList = [fromModel, toModel, processingModel, totalModel, memoModel]

        // 默认选中中间
        selectFeeIndex = 1

        dataList = reloadPopDataWithIndex(index: selectFeeIndex)

        return dataList
    }

    func reloadPopDataWithIndex(index: Int) -> [SendPopViewModel] {
        let speed = feeList[index]
        selectFee(index: index)
        // 更新选择
        let processingModel = SendPopViewModel(title: "到账时间".localized(), topDesc: speed.speedDesc, bottomDesc: speed.Fee, nextList: feeList)
        dataList[2] = processingModel

        // 更新总额度
        let totalModel = SendPopViewModel(title: "总计".localized(), topDesc: "\(getTotalAmount())" + "ETH", bottomDesc: BalanceFormatter.getCurreyPrice(value: getTotalAmount().doubleValue))
        dataList[3] = totalModel

        gasPrice = Int(Double(feePrice[index])! / 10 * pow(10, 9))

        return dataList
    }
}

extension ETHTransViewModel {
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

    // 获取小数位数
    func getdigitNumber(value: String) -> Int {
        if let range = value.range(of: ".") {
            let number = String(value[range.upperBound...]).count
            return number
        }
        return 0
    }

    func getTotalAmount() -> NSNumber {
        let fee = getETHGas(gas: Double(feePrice[selectFeeIndex])! / 10).doubleValue
        let num = NSDecimalNumber(string: String(format: "%.8f", Double(amount)! + fee))
        return num

//        return "\(total)" + " ETH"// + "≈ \(BalanceFormatter.getCurreyPrice(value: total))"
    }
}
