//
//  TokenWallet+WalletInterfce.swift
//  TOPCore
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation

extension TokenWallet: WalletProtocol, ViewWalletInterface {
    public var chainType: ChainType {
        return ChainType.getTypeWithSymbol(symbol: chainSymbol)
    }

    public var isUTXOWallet: Bool {
        switch mainChainType {
        case .bitcoinCash:
            return true
        case .litecoin:
            return true
        case .dash:
            return true
        case .bitcoin:
            return true
        default:
            return false
        }
    }


    public var chainSymbol: String {
        return token!.chainType
    }

    public var fullName: String {
        return token!.fullName
    }

    public var isShow: Bool {
        return !hidden
    }

    public var isMainCoin: Bool {
        return false
    }

    public var logoUrl: String {
        return token!.iconUrl
    }

    public var symbol: String {
        return token!.symbol
    }

    public var asset: AssetInterface {
        return token!
    }
}
