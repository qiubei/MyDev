//
//  TransactionDetailViewModel.swift
//  TOPCore
//
//  Created by Jax on 2019/11/14.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

public struct TransactionDetailViewModel {
    //原始属性
    private var historyTxModel: HistoryTxModel

    public init(historyModel: HistoryTxModel) {
        historyTxModel = historyModel
    }

    //数量显示
    public var ammount: NSAttributedString {
        return CryptoFormatter.formattedAmmount(amount: historyTxModel.ammount, type: historyTxModel.type, asset: historyTxModel.asset)
    }

    //时间
    public var time: String {
        return Date(timeIntervalSince1970: historyTxModel.date).string(custom: "yyyy/MM/dd HH:mm:ss")
    }

    //交易hash
    public var txID: String {
        return historyTxModel.txhash
    }
    //交易hash
     public var note: String? {
         return historyTxModel.note
     }
    //交易hash
     public var fee: String {
        return historyTxModel.fee + " " + historyTxModel.chainType
     }

    //时间
    public var otherAddress: String {
        return historyTxModel.otherAdress
    }

    public var isSend: Bool {
        return historyTxModel.isSend
    }

    //状态描述
    public var statusDesc: String {
        if historyTxModel.isSend {
            switch historyTxModel.status {
            case .failure:
                return "发送失败"
            case .pending:
                return "正在发送中"
            case .success:
                return "出账成功"
            }
        } else {
            switch historyTxModel.status {
            case .failure:
                return "发送失败"
            case .pending:
                return "正在接收中"
            case .success:
                return "入账成功"
            }
        }
    }

    //状态描述
    public var statusImageName: String {
        switch historyTxModel.status {
        case .failure:
            return "icon_tx_state_failed"
        case .success:
            return "icon_tx_state_success"
        case .pending:
            return "icon_tx_state_process"
        }
    }

    public var detailURL: String {
        switch historyTxModel.asset {
        case is Token:
            return "https://cn.etherscan.com/tx/" + txID
        case let coin as MainCoin:
            switch coin {
            case .bitcoin:
                return "https://www.blockchain.com/btc/tx/" + txID
            case .ethereum:
                return "https://cn.etherscan.com/tx/" + txID
            case .topnetwork:
                return""
            case .unknowCoin:
                return""
            default:
                return""
            }
        default:
            return""
        }
    }
}
