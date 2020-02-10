//
//  UserInfo.swift
//  HiWallet
//
//  Created by Jax on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import HandyJSON

class UserInfo: HandyJSON {
    var airdrop: String = "" //累计空投
    var balance: String = "" //余额

    required init() {}
}
