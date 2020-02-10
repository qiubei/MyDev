//
//  EthereumBalance.swift
//  essentia-bridges-api-ios
//
//  Created by Pavlo Boiko on 11.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public struct BalanceValue: Decodable {
    public let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "balance"
    }
}

public struct EthereumBalance: Decodable {
    public let balance: BalanceValue
    
    enum CodingKeys: String, CodingKey {
        case balance = "result"
    }
}
