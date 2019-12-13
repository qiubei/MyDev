//
//  Token+Localization.swift
//  TOP
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import UIKit

extension Token: AssetInterface {
    
    public var chainSymbol: String {
        return chainType
    }

    public var name: String {
        return fullName
    }

    public var minimumTransactionAmmount: Double {
        return 1.0 / pow(10.0, Double(decimals))
    }

    public var assetID: String {
        return chainSymbol + symbol + contractAddress.uppercased()
    }

    public var type: CryptoType {
        return .token
    }

    public func isValidAddress(_ address: String) -> Bool {
        return address.count == 40 || address.count == 42
    }

}
