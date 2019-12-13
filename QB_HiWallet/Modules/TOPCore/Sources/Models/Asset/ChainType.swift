//
//  Coin.swift
//  TOP
//
//  Created by Jax on 10.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import UIKit

public enum ChainType: String, Equatable {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash
    case dash
    case topnetwork = "top network"
    case unknowCoin

    public static var supportChains: [ChainType] {
        return [.bitcoin, .ethereum, .bitcoinCash, litecoin, dash] // [.ethereum,.topnetwork]
    }

    public static var supportChainNames: Array<String> {
        var array: [String] = []
        for coin in supportChains {
            array.append(coin.symbol.lowercased())
        }
        return array
    }

    public var minimumTransactionAmmount: Double {
        switch self {
        case .bitcoin:
            return 0.000_005_46
        case .litecoin:
            return 0.000_01
        case .dash:
            return 0.000_01
        case .bitcoinCash:
            return 0.000_01
        default:
            return 0
        }
    }

    public static func isSupportCoin(name: String) -> Bool {
        guard let coin = ChainType(rawValue: name.lowercased()) else {
            return false
        }
        return ChainType.supportChains.contains(coin)
    }

    public static func isSupportCoin(symbol: String) -> Bool {
        return ChainType.supportChains.contains(getTypeWithSymbol(symbol: symbol))
    }

    public static func getTypeWithSymbol(symbol: String) -> ChainType {
        switch symbol.lowercased() {
        case "btc":
            return .bitcoin
        case "eth":
            return .ethereum
        case "ltc":
            return .litecoin
        case "bch":
            return .bitcoinCash
        case "dash":
            return .dash
        case "top":
            return .topnetwork
        default:
            return .unknowCoin
        }
    }

    public func isValidAddress(_ address: String) -> Bool {
        switch self {
        case .bitcoin, .litecoin, .dash, .bitcoinCash:
            return BTCAddressValidator(address: address, chainType: self).isValid
        case .ethereum:
            return ETHAddressValidator(address: address).isValid
        case .topnetwork:
            return address.hasPrefix("T-")
        case .unknowCoin:
            return false
        }
    }
}
