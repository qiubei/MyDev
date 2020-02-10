//
//  GeneratedWallet+WalletInterface.swift
//  TOPCore
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation

extension GeneratingWalletInfo: WalletProtocol, ViewWalletInterface {
    
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
 

    public var fullName: String {
        return mainChainType.fullName
    }

    public var chainSymbol: String {
        return mainChainType.symbol
    }

    public var isShow: Bool {
        return !hidden
    }

    public var isMainCoin: Bool {
        return true
    }

    public var logoUrl: String {
        return mainChainType.iconUrl
    }

    public convenience init(name: String, coin: ChainType, accountIndex: Int32, seed: String, sourseType: BackupSourceType) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
        var walletDerivationNode = sourseType.derivationNodesFor(coin: wrapCoin(coin: coin))
        walletDerivationNode[2] = .hardened(UInt32(accountIndex))
        let account = wallet.generateAccount(at: walletDerivationNode)

        self.init(name: name, coin: coin, privateKey: account.rawPrivateKey, address: account.address, accountIndex: accountIndex, lastBalance: 0)
        mainChainType = coin
        self.accountIndex = accountIndex
        lastBalance = 0
    }

    public convenience init(coin: ChainType, sourceType: BackupSourceType, seed: String) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
        var coinDerivationNode = sourceType.derivationNodesFor(coin: hdwalletCoin)
        coinDerivationNode.append(.notHardened(UInt32(0)))
        let account = wallet.generateAccount(at: coinDerivationNode)
        let index = coinDerivationNode.last!.index
        self.init(name: "", coin: coin, privateKey: account.rawPrivateKey, address: account.address, accountIndex: Int32(index), lastBalance: 0)
        mainChainType = coin
        lastBalance = 0
    }

    public var symbol: String {
        return mainChainType.symbol
    }

    public func isValidAddress(address: String) -> Bool {
        return mainChainType.isValidAddress(address)
    }

    public var asset: AssetInterface {
        return mainChainType
    }
}

// - Make single Coin model
public func wrapCoin(coin: ChainType) -> Coin {
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
