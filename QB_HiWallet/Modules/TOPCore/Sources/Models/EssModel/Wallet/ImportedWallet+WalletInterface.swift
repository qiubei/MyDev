//
//  ImportedWallet.swift
//  TOPCore
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import CryptoSwift

extension ImportedWallet: WalletProtocol, ViewWalletInterface {
    public var chainType: ChainType {
        return ChainType.getTypeWithSymbol(symbol: symbol)
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


    //导入的帐号索引都是0
    public var accountIndex: Int32 {
        return 0
    }

    public var chainSymbol: String {
        return mainChainType.symbol
    }

    public var fullName: String {
        return mainChainType.fullName
    }

    public var isShow: Bool {
        return !hidden
    }

    public var isMainCoin: Bool {
        return true
    }

    public var logoUrl: String {
        return iconUrl
    }

    public convenience init?(coin: ChainType, privateKey: String, name: String, lastBalance: Double) {
        let hdCoin: Coin = wrapCoin(coin: coin)
        let rawPrivateKey = PrivateKey(pk: privateKey, coin: hdCoin)
        guard let address = rawPrivateKey?.publicKey.address else { return nil }
        self.init(address: address, coin: coin, privateKey: privateKey, name: name, lastBalance: lastBalance)
    }

    public var symbol: String {
        return mainChainType.symbol
    }

    public var asset: AssetInterface {
        return mainChainType
    }
}
