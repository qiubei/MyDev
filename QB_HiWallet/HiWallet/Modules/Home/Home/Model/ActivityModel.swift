//
//  ActivityModel.swift
//  HiWallet
//
//  Created by Jax on 2020/1/10.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import HandyJSON

class ActivityModel: HandyJSON {
    var activityUrl: String = "" //活动地址
    var aid: String = "" //活动id
    var backgroundUrl: String = "" //景图片url
    var desc: String = "" //活动描述
    var record: String = "" //活动历史分数
    var ticketPrice: String = "" //门票价格
    var timeDesc: String = "" //完成人数次数描述
    var title: String = "" //活动标题
    var unit: String = "" //单位

    required init() {}
}
