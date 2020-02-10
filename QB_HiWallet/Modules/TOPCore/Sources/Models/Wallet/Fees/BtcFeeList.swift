//
//  BtcFeeList.swift
//  TOPCore
//
//  Created by Jax on 2019/8/26.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

public class BtcFeeList: Codable {
    public var fastestFee: String = ""
    public var halfHourFee: String = ""
    public var hourFee: String = ""

    public class func defautFee() -> BtcFeeList {
        let fee = BtcFeeList()
        fee.fastestFee = "30"
        fee.halfHourFee = "15"
        fee.hourFee = "1"
        return fee
    }
}
