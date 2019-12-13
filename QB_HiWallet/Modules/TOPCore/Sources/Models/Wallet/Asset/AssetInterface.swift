//
//  AssetInterface.swift
//  TOP
//
//  Created by Jax on 13.09.18
//  Copyright © 2018 TOP. All rights reserved.
//

import RealmSwift
import UIKit

public enum CryptoType {
    case coin
    case token
}

public enum CurrencyType {
    case fiat
    case crypto

    public var another: CurrencyType {
        switch self {
        case .fiat:
            return .crypto
        case .crypto:
            return .fiat
        }
    }
}

//资产属性
public protocol AssetInterface {
    var name: String { get }
    var symbol: String { get }
    var chainSymbol: String { get }
    var iconUrl: String { get }
    var type: CryptoType { get }
    var minimumTransactionAmmount: Double { get }
    var assetID: String { get }
    func isValidAddress(_ address: String) -> Bool
}

//public func== (lhs: AssetInterface, rhs: AssetInterface) -> Bool {
//    return lhs.name == rhs.name && lhs.type == rhs.type && lhs.localizedName == rhs.localizedName
//}
