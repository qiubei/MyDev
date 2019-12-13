//
//  HistoryViewTransaction.swift
//  TOPCore
//
//  Created by Jax on 2019/11/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

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
        switch historyTxModel.type {
        //合约
        case .contract:
            switch historyTxModel.status {
            case .failure:
                return "合约调用失败"
            case .pending:
                return "合约调用中"
            case .success:
                return "合约调用成功"
            case .unconfirmed:
                return "未确认"
            }
        //发送
        case .send:
            switch historyTxModel.status {
            case .failure:
                return "发送失败"
            case .pending:
                return "正在发送中"
            case .success:
                return "出账"
            case .unconfirmed:
                return "未确认"
            }
        //接收
        case .recive:
            switch historyTxModel.status {
            case .failure:
                return "接收失败"
            case .pending:
                return "正在接收中"
            case .success:
                return "入账"
            case .unconfirmed:
                return "未确认"
            }
        }
    }

    //状态图片
    public var statusImageName: String {
        switch historyTxModel.type {
        //合约
        case .contract:
            switch historyTxModel.status {
            case .failure:
                return "icon_tx_contact_failed"
            case .pending:
                return "icon_tx_pending"
            case .success:
                return "icon_tx_contact_success"
            case .unconfirmed:
                return "icon_tx_pending"
            }
        //发送
        case .send:
            switch historyTxModel.status {
            case .failure:
                return "icon_tx_failed"
            case .pending:
                return "icon_tx_pending"
            case .success:
                return "icon_tx_send"
            case .unconfirmed:
                return "icon_tx_pending"
            }
        //接收
        case .recive:
            switch historyTxModel.status {
            case .failure:
                return "icon_tx_failed"
            case .pending:
                return "icon_tx_pending"
            case .success:
                return "icon_tx_receive"
            case .unconfirmed:
                return "icon_tx_pending"
            }
        }
    }

    private var isContactTx: Bool {
        return historyTxModel.isContactTx
    }
}
