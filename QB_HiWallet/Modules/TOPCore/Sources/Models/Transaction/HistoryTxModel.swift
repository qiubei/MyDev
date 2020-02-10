//
//  txHistoryViewModel.swift
//  TOPCore
//
//  Created by Jax on 2019/11/13.
//  Copyright © 2019 TOP. All rights reserved.
//  历史记录交易viewmodel

import Foundation

public struct HistoryTxModel {
    public var chainType: String  //symbol
    public var txhash: String
    public var toAddress: String //对方的地址
    public var fromAddress: String //对方的地址
    public var myAddress: String //我的的地址
    public var ammount: Double //数量
    public var status: TransactionStatus
    public var type: TransactionType
    public var date: TimeInterval
    public var fee: String
    public var note: String? //token和btc要设置为nil，以太坊设置为空字符串
    public var asset: AssetInterface

    public init(chainType: String,
                asset: AssetInterface,
                txhash: String,
                toAddress: String,
                fromAddress: String,
                myAddress: String,
                ammount: Double,
                status: TransactionStatus,
                type: TransactionType,
                date: TimeInterval,
                fee: String,
                note: String? = nil) {
        self.chainType = chainType
        self.txhash = txhash
        self.toAddress = toAddress
        self.fromAddress = fromAddress
        self.myAddress = myAddress
        self.ammount = ammount
        self.status = status
        self.type = type
        self.date = date
        self.fee = fee
        self.note = note
        self.asset = asset
    }

    //是否是发送
    public var isSend: Bool {
        return type == .send
    }

    //显示地址
    public var otherAdress: String {
        return isSend ? toAddress : fromAddress
    }

    public var isContactTx: Bool {
        return type == .contract
    }
}
