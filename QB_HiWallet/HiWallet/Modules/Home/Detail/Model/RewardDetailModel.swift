//
//  RewardDetailModel.swift
//  TOPCore
//
//  Created by Anonymous on 2020/1/9.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import HandyJSON

public enum AmountDetailType: String {
    case input = "REWARD"
    case output = "SPEND"
}

/// 空投明细 Model
public class RewardDetailModel: HandyJSON {
    public required init() {}
    
    public var amount: Double = 0 // 明细的数量
    public var receiveTime: String = "" // 领取时间（时间戳:毫秒）
    public var rewardId: Int64 = 0 // 明细 ID
    public var side: String = "" // 明细类型： 收入或者支出
    public var type: String = "" // 空投类型：register、transfer、game等
    public var unit: String = "" // 空投币的种类的计量单位（如：TOP）
    
    public var amountType: AmountDetailType {
        get {
            return AmountDetailType(rawValue: side)!
        }
    }
}
