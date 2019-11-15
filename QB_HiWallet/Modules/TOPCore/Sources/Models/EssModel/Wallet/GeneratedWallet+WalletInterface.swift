//
//  GeneratedWallet+WalletInterface.swift
//  TOPCore
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation

import HDWalletKit

extension GeneratingWalletInfo: WalletProtocol, ViewWalletInterface {

    
    public var assetID: String {
        return mainCoinType.symbol + "-" + mainCoinType.symbol
    }
    
    public var fullName: String {
        return mainCoinType.fullName
    }

    public var chainSymbol: String {
        return mainCoinType.symbol
    }

    public var isShow: Bool {
        return !hidden
    }

    public var isMainCoin: Bool {
        return true
    }

    public var logoUrl: String {
        return mainCoinType.iconUrl
    }

    public convenience init(name: String, coin: MainCoin, accountIndex: Int32, seed: String, sourseType: BackupSourceType) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
        var walletDerivationNode = sourseType.derivationNodesFor(coin: wrapCoin(coin: coin))
        walletDerivationNode[2] = .hardened(UInt32(accountIndex))
        let account = wallet.generateAccount(at: walletDerivationNode)

        self.init(name: name, coin: coin, privateKey: account.rawPrivateKey, address: account.address, accountIndex: accountIndex, lastBalance: 0)
        self.mainCoinType = coin
        self.accountIndex = accountIndex
        lastBalance = 0
    }

    public convenience init(coin: MainCoin, sourceType: BackupSourceType, seed: String) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
        var coinDerivationNode = sourceType.derivationNodesFor(coin: hdwalletCoin)
        coinDerivationNode.append(.notHardened(UInt32(0)))
        let account = wallet.generateAccount(at: coinDerivationNode)
        let index = coinDerivationNode.last!.index
        self.init(name: "", coin: coin, privateKey: account.rawPrivateKey, address: account.address, accountIndex: Int32(index), lastBalance: 0)
        self.mainCoinType = coin
        lastBalance = 0
    }

    public var symbol: String {
        return mainCoinType.symbol
    }

    public func isValidAddress(address: String) -> Bool {
        return mainCoinType.isValidAddress(address)
    }

    public var asset: AssetInterface {
        return mainCoinType
    }
}

// - Make single Coin model
public func wrapCoin(coin: MainCoin) -> Coin {
    switch coin {
    case .bitcoin:
        return Coin.bitcoin
    case .ethereum:
        return Coin.ethereum
    case .bitcoinCash:
        return Coin.bitcoinCash
    case .litecoin:
        return Coin.litecoin
    case .dash:
        return .dash
    case .topnetwork:
        return Coin.topnetwork
    default:
        return Coin.topnetwork
    }
}
