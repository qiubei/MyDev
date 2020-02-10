//
//  CoinInfo.swift
//  HiWallet
//
//  Created by Jax on 2020/1/10.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import HandyJSON

class CoinInfo: HandyJSON {
    var amount: String = "" //可领取数量
    var canReceive: Bool = false //是否可以收取
    var countDown: String = "" //倒计时
    var rewardId: String = "" //奖励id
    var side: String = "" //记录方向，扣费/奖励
    var type: String = "" //奖励类型
    var unit: String = "" //奖励单位
    required init() {}
}
