//
//  CryptoWallet+Coin.swift
//  TOPCore
//
//  Created by Jax on 5/14/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation
import EssentiaBridgesApi


public extension CryptoWallet {
    func utxoWallet(coin: ChainType) -> UtxoWalletUnterface {
        switch coin {
        case .bitcoin:
            return bitcoin
        case .bitcoinCash:
            return bitcoinCash
        case .litecoin:
            return litecoin
        case .dash:
            return dash
        default:
            fatalError("No such Utxo wallet!")
        }
    }
}
