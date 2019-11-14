//
//  ImportedWallet.swift
//  TOPCore
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import CryptoSwift
import HDWalletKit

extension ImportedWallet: WalletProtocol, ViewWalletInterface {
    //导入的帐号索引都是0
    public var accountIndex: Int32 {
        return 0
    }

    public var chainSymbol: String {
        return coin.symbol
    }

    public var fullName: String {
        return coin.fullName
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

    public convenience init?(coin: MainCoin, privateKey: String, name: String, lastBalance: Double) {
        let hdCoin: HDWalletKit.Coin = wrapCoin(coin: coin)
        let rawPrivateKey = PrivateKey(pk: privateKey, coin: hdCoin)
        guard let address = rawPrivateKey?.publicKey.address else { return nil }
        self.init(address: address, coin: coin, privateKey: privateKey, name: name, lastBalance: lastBalance)
    }

    public var symbol: String {
        return coin.symbol
    }

    public var asset: AssetInterface {
        return coin
    }
}
