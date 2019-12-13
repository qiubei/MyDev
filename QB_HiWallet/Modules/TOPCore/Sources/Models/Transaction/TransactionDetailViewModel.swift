//
//  TransactionDetailViewModel.swift
//  TOPCore
//
//  Created by Jax on 2019/11/14.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit

public struct DetailCellModel {
    var title: String
    var detail: String
    var imageName: String?
}

public struct TransactionDetailViewModel {
    //原始属性
    private var historyTxModel: HistoryTxModel
    public var datalist: [DetailCellModel] = []

    public init(historyModel: HistoryTxModel) {
        historyTxModel = historyModel

        let amountMoel = DetailCellModel(title: "金额".localized(), detail: ammountWithSymbol, imageName: nil)
        let gasModel = DetailCellModel(title: "手续费".localized(), detail: fee, imageName: nil)
        let sendTitle = isSend ? "发送到".localized() : "对方账户".localized()
        let sendModel = DetailCellModel(title: sendTitle, detail: otherAddress, imageName: "icon_copy")
        let hashModel = DetailCellModel(title: "交易号".localized(), detail: txID, imageName: "icon_copy")
        datalist.append(amountMoel)
        datalist.append(gasModel)
        datalist.append(sendModel)
        datalist.append(hashModel)
        if let note = note {
            let noteModel = DetailCellModel(title: "备注tx".localized(), detail: note, imageName: nil)
            datalist.append(noteModel)
        }
    }

    //数量显示
    public var ammountStr: NSAttributedString {
        return CryptoFormatter.formattedAmmount(amount: historyTxModel.ammount, type: historyTxModel.type, asset: historyTxModel.asset)
    }

    public var ammountWithSymbol: String {
        return CryptoFormatter.formattedAmmountNoDropSymbol(amount: historyTxModel.ammount, type: historyTxModel.type, asset: historyTxModel.asset)
    }

    //时间
    public var time: String {
        return Date(timeIntervalSince1970: historyTxModel.date).string(custom: "yyyy/MM/dd HH:mm:ss")
    }

    //交易hash
    public var txID: String {
        return historyTxModel.txhash
    }

    //交易备注
    public var note: String? {
        if let noteStr = historyTxModel.note {
            let result = String(data: noteStr.hexStringToData(), encoding: .utf8) ?? ""
            return (result.count > 0 ? result : nil)
        }
        return nil
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
            }
        //发送
        case .send:
            switch historyTxModel.status {
            case .failure:
                return "发送失败"
            case .pending:
                return "正在发送中"
            case .success:
                return "出账成功"
            }
        //接收
        case .recive:
            switch historyTxModel.status {
            case .failure:
                return "接收失败"
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

    private var isContactTx: Bool {
        return historyTxModel.isContactTx
    }

    public var detailURL: String {
        switch historyTxModel.asset {
        case is Token:
            return "https://cn.etherscan.com/tx/" + txID
        case let coin as ChainType:
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
