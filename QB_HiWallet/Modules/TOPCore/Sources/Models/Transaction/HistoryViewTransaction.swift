//
//  HistoryViewTransaction.swift
//  TOPCore
//
//  Created by Jax on 2019/11/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

public struct HistoryListViewModel {
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

    //状态描述
    public var statusDesc: String {
        if historyTxModel.isSend {
            switch historyTxModel.status {
            case .failure:
                return "发送失败"
            case .pending:
                return "正在发送中"
            case .success:
                return "出账"
            }
        } else {
            switch historyTxModel.status {
            case .failure:
                return "发送失败"
            case .pending:
                return "正在接收中"
            case .success:
                return "入账"
            }
        }
    }

    //状态描述
    public var statusImageName: String {
        switch historyTxModel.status {
        case .failure:
            return "icon_tx_failed"
        default:
            return historyTxModel.isSend ? "icon_tx_send" : "icon_tx_receive"
        }
    }
}
