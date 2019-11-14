//
//  Token.swift
//  TOP
//
//  Created by Jax on 15.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import RealmSwift
import UIKit

@objcMembers

public class Token: Object, Codable {
    public dynamic var id: String = ""
    public dynamic var address: String = "" // 合约地址
    public dynamic var symbol: String = ""
    public dynamic var fullName: String = ""
    public dynamic var decimals: Int = 0 // 小数位数
    public dynamic var iconUrl: String = ""
    public dynamic var webURL: String = ""
    public dynamic var chainType: String = "" //主链的symbol

    public dynamic var contractAddress:String {
        return address
    }
    public convenience init(id: String,
                            contractAddress: String,
                            symbol: String,
                            fullName: String,
                            decimals: Int,
                            iconUrl: String,
                            webURL: String,
                            chainType: String) {
        self.init()
        self.id = id
        self.address = contractAddress
        self.symbol = symbol
        self.fullName = fullName
        self.decimals = decimals
        self.iconUrl = iconUrl
        self.webURL = webURL
        self.chainType = chainType
    }
}
