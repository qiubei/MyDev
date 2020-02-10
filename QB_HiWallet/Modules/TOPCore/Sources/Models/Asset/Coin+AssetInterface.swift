//
//  Coin+Localization.swift
//  TOP
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import UIKit

extension ChainType: AssetInterface {
    public var contractAddress: String {
        return ""
    }

    public var chainSymbol: String {
        return symbol
    }

    public var name: String {
        return fullName
    }

    public var assetID: String {
        return chainSymbol.uppercased() + symbol.uppercased()
    }

    public var fullName: String {
        switch self {
        case .bitcoin:
            return "Bitcoin"
        case .ethereum:
            return "Ethereum"
        case .litecoin:
            return "Litecoin"
        case .bitcoinCash:
            return "Bitcoin Cash"
        case .dash:
            return "Dash"
        case .topnetwork:
            return "TOP Network"
        case .unknowCoin:
            return "unknowCoin"
        }
    }

    public var symbol: String {
        switch self {
        case .bitcoin:
            return "BTC"
        case .ethereum:
            return "ETH"
        case .litecoin:
            return "LTC"
        case .bitcoinCash:
            return "BCH"
        case .dash:
            return "DASH"
        case .topnetwork:
            return "TOP"
        case .unknowCoin:
            return "unknowCoin"
        }
    }

    public static var allCases: [ChainType] {
        return [.bitcoin, .ethereum, .litecoin, .bitcoinCash]
    }

    public var safeConfirmationCount: Int {
        switch self {
        case .bitcoin:
            return 3
        case .ethereum:
            return 7
        default:
            return 10
        }
    }

    public var type: CryptoType {
        return .coin
    }

    public func isSafeTransaction(confirmations: Int) -> Bool {
        return safeConfirmationCount < confirmations
    }

    public var iconUrl: String {
        if fullName == ChainType.topnetwork.fullName {
            return CoinIconsUrlFormatter(name: "top", size: .x128).url.absoluteString
        }
        return CoinIconsUrlFormatter(name: fullName, size: .x128).url.absoluteString
    }
}
