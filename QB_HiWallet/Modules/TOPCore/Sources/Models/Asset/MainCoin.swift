//
//  Coin.swift
//  TOP
//
//  Created by Jax on 10.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import UIKit

public enum MainCoin: String, Equatable {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash
    case dash
    case topnetwork = "top network"
    case unknowCoin

    public static var fullySupportedCoins: [MainCoin] {
        return [.bitcoin, .ethereum] // [.ethereum,.topnetwork]
    }

    public static var fullySupportedCoinsName: Array<String> {
        var array: [String] = []
        for coin in fullySupportedCoins {
            array.append(coin.symbol.lowercased())
        }
        return array
    }

    public func isValidPK(_ pk: String) -> Bool {
        return !pk.isEmpty
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
            return 1 / pow(10, 18)
        }
    }

    public static func isSupportCoin(name: String) -> Bool {
        guard let coin = MainCoin(rawValue: name.lowercased()) else {
            return false
        }
        return MainCoin.fullySupportedCoins.contains(coin)
    }

    public static func isSupportCoin(symbol: String) -> Bool {
        return MainCoin.fullySupportedCoins.contains(getTypeWithSymbol(symbol: symbol))
    }

    public static func getTypeWithSymbol(symbol: String) -> MainCoin {
        switch symbol.lowercased() {
        case "btc":
            return .bitcoin
        case "eth":
            return .ethereum
        case "lit":
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
            return BTCAddressValidator(address: address).isValid
        case .ethereum:
            return ETHAddressValidator(address: address).isValid
        case .topnetwork:
            return address.hasPrefix("T-")
        case .unknowCoin:
            return false
        }
    }
}
