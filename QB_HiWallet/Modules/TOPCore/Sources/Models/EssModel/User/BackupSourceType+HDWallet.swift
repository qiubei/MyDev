//
//  BackupSourceType+HDWallet.swift
//  TOPCore
//
//  Created by Jax on 3/1/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation


public extension BackupSourceType {
    //     m/44/coin/account/change/address_index
    func derivationNodesFor(coin: Coin) -> [DerivationNode] {
        switch coin {
        case .bitcoin, .topnetwork:
            return [.hardened(44), .hardened(0), .hardened(0), .notHardened(0), .notHardened(0)]
        case .ethereum:
            return [.hardened(44), .hardened(60), .hardened(0), .notHardened(0), .notHardened(0)]
        case .litecoin:
            return [.hardened(44), .hardened(2), .hardened(0), .notHardened(0), .notHardened(0)]
        case .bitcoinCash:
            return [.hardened(44), .hardened(145), .hardened(0), .notHardened(0), .notHardened(0)]
        case .dash:
            return [.hardened(44), .hardened(5), .hardened(0), .notHardened(0), .notHardened(0)]
        }
    }
}
