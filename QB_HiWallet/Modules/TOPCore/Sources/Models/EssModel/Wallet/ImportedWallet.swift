//
//  ImportedWallet.swift
//  TOP
//
//  Created by Jax on 11.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import RealmSwift
import UIKit

@objcMembers
public class ImportedWallet: Object {
    public dynamic var privateKey: String = ""
    public dynamic var address: String = ""
    public dynamic var name: String = ""
    public dynamic var lastBalance: Double = 0
    @objc public dynamic var createTime: Double = 0
    @objc public dynamic var hidden: Bool = false
    @objc public dynamic var privateCoin: String = ""

    public var mainChainType: ChainType {
        set { privateCoin = newValue.rawValue }
        get { return ChainType(rawValue: privateCoin)! }
    }

    public convenience init(address: String, coin: ChainType, privateKey: String, name: String, lastBalance: Double) {
        self.init()
        self.address = address
        privateCoin = coin.rawValue
        self.privateKey = privateKey
        self.name = name
        self.lastBalance = lastBalance
        createTime = Date().timeIntervalSince1970
    }
}
