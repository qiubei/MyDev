//
//  GeneratingWalletInfo.swift
//  TOP
//
//  Created by Jax on 17.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class GeneratingWalletInfo: Object {
    
    @objc public dynamic var name: String = "" // 起的名字
    @objc public dynamic var accountIndex: Int32 = 0
    @objc public dynamic var privateKey: String = ""
    @objc public dynamic var address: String = ""
    @objc public dynamic var lastBalance: Double = 0
    @objc public dynamic var createTime: Double = 0
    @objc public dynamic var hidden: Bool = false
    @objc private dynamic var privateCoin: String = ""
    public dynamic var localTx: List<LocalTxModel> = List()

    // 币种
    public var mainCoinType: MainCoin {
        set { privateCoin = newValue.rawValue }
        get {
            return MainCoin(rawValue: privateCoin)!
        }
    }

    public convenience init(name: String, coin: MainCoin, privateKey: String, address: String, accountIndex: Int32, lastBalance: Double) {
        self.init()
        self.name = name
        self.accountIndex = accountIndex
        self.lastBalance = lastBalance
        self.privateKey = privateKey
        self.address = address
        createTime = Date().timeIntervalSince1970
        privateCoin = coin.rawValue
    }

    public static func == (lhs: GeneratingWalletInfo, rhs: GeneratingWalletInfo) -> Bool {
        return lhs.mainCoinType == rhs.mainCoinType && lhs.accountIndex == rhs.accountIndex
    }
}
