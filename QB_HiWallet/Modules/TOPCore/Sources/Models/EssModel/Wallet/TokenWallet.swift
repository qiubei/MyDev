//
//  TokenWallet.swift
//  TOP
//
//  Created by Jax on 17.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import RealmSwift
import UIKit

@objc
public class TokenWallet: Object {
    @objc public dynamic var name: String = ""
    @objc public dynamic var token: Token? = Token()
    @objc public dynamic var privateKey: String = ""
    @objc public dynamic var address: String = ""
    @objc public dynamic var lastBalance: Double = 0
    @objc public dynamic var createTime: Double = 0
    @objc public dynamic var hidden: Bool = false
    @objc public dynamic var accountIndex: Int32 = 0

    public var mainChainType: ChainType {
        return ChainType.getTypeWithSymbol(symbol: token!.chainType)
    }

    public convenience init(name: String, token: Token, privateKey: String, address: String, accountIndex: Int32, lastBalance: Double) {
        self.init()
        self.name = name
        self.token = token
        self.privateKey = privateKey
        self.address = address
        self.lastBalance = lastBalance
        self.accountIndex = accountIndex
        createTime = Date().timeIntervalSince1970
    }
}
