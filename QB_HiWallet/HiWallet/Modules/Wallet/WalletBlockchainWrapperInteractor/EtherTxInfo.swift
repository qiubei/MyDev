//
//  EtherTxInfo.swift
//  TOP
//
//  Created by Jax on 11/14/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public struct EtherTxInfo {
    var address: String
    var ammount: SelectedTransacrionAmmount
    var data: String
    var fee: Double //换算成货币的价值，不用了
    var gasPrice: Int
    var gasLimit: Int
}
