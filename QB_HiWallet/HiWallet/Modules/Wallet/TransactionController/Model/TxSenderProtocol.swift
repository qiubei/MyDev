//
//  TxSenderProtocol.swift
//  HiWallet
//
//  Created by Jax on 2019/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//
import Foundation
import TOPCore

enum ValidInputMessageType {
    case success
    case toast(String)
    case alert(String)
}

struct SendTxInputInfo {
    var amount: String
    var to: String
    var note: String?
    
    /// ETH 需要配置该参数， BTC 不需要。
    var gasLimit = 100000
}


protocol TxSenderProtocol {
    
    /// 上层传进来的输入数据结构
    var txInputInfo: SendTxInputInfo! { get set }
    
    /// 加载数据，该方法是用来预加载一些耗时数据
    func loadData(callback: @escaping (_ result: Bool) -> Void)
    
    /// 通过链校验的输入信息，返回错误提示。
    /// 注意：关于输入的格式检验已经在上层做过，在这个方法里面不需要做校验。
    func checkInputInChain(_ inputInfo: SendTxInputInfo, callback: @escaping (_ result: ValidInputMessageType) -> Void)
    
    /// 根据选中的交易费档次索引生成业务数据（弹窗数据：输入信息、交易费和总额等数据）。
    func getPopDatalist(feeIndex: Int) -> [SendPopViewModel]
    
    /// 确认交易，回调交易包校验结果。
    func confirmVerify(callback: @escaping (_ result: ValidInputMessageType) -> Void)
    
    /// 发送交易，回调发送交易结果。
    func sendTranstion(callback: @escaping (_ result: (Bool, String)) -> Void)
    
    /// 交易总额
    func totalAmount(with amount: Double, feePrice: String) -> String
}

//Tool
extension TxSenderProtocol {
    // 获取小数位数
    func getdigitNumber(value: String) -> Int {
        if let range = value.range(of: ".") {
            let number = String(value[range.upperBound...]).count
            return number
        }
        return 0
    }
    
    func getAmountStringWith(_ amount: String, _ wallet: ViewWalletInterface) -> String {
        var amountStr = amount + " \(wallet.symbol)"
        var balanceStr = BalanceFormatter.getCurreyPrice(fullName: wallet.fullName, value: Double(amount) ?? 0)
        if !wallet.isMainCoin {
            amountStr = amount + "\(wallet.chainSymbol)"
            balanceStr = BalanceFormatter.getCurreyPrice(fullName: ChainType.ethereum.fullName, value: Double(amount) ?? 0)
        }
        
        return amountStr + balanceStr
    }
}

extension TxSenderProtocol {
    // 交易成功后需上报奖励: 只上报不处理逻辑
    func uploadRewead(txID: String) {
        TOPNetworkManager<UserSerivices, EmptyResult>.requestModel(.uploadTx(txHash: txID))
    }
}
