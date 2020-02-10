//
//  WalletInteractor.swift
//  TOP
//
//  Created by Jax on 06.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import RealmSwift

public class WalletInteractor: WalletInteractorInterface {
    public func openERC20TOPTokenWallet() {
        let wallets = TOPStore.shared.currentUser.wallet?.tokenWallets.filter { $0.symbol == ChainType.topnetwork.symbol && ($0.asset as! Token).chainType == ChainType.ethereum.symbol } ?? []
        wallets.forEach { token in
            (inject() as UserStorageServiceInterface).update({ _ in
                token.hidden = false
            })
            (inject() as CurrencyRankDaemonInterface).update()
        }
    }

    public func getERC20TOPTokenWallet() -> [ViewWalletInterface] {
        return TOPStore.shared.currentUser.wallet?.tokenWallets.filter {
            $0.symbol == ChainType.topnetwork.symbol && ($0.asset as! Token).chainType == ChainType.ethereum.symbol && $0.hidden == false
        } ?? []
    }

    public func getHiddenWalletWithAssetID(assetID: String) -> [ViewWalletInterface] {
        return allHiddenViewWallets.filter { $0.asset.assetID == assetID }
    }

    public func getWalletWithAssetID(assetID: String) -> [ViewWalletInterface] {
        return allViewWallets.filter { $0.asset.assetID == assetID }
    }

    public func getAllWalletGroup() -> [[ViewWalletInterface]] {
        return viewWalletsGroup
    }

    public func nameIsExist(for name: String, coin: ChainType) -> Bool {
        let currentlyAddedWallets = TOPStore.shared.currentUser.wallet?.generatedWalletsInfo
        let currentCoinAssets = currentlyAddedWallets!.filter({ $0.mainChainType == coin })
        let result = currentCoinAssets.filter {
            $0.name == name
        }
        return result.count > 0
    }

    public func getAllWallet() -> [ViewWalletInterface] {
        return allViewWallets
    }

    public init() {}

    public func isValidWallet(_ wallet: ImportedWallet) -> Bool {
        guard let importdAssets = TOPStore.shared.currentUser.wallet?.importedWallets else {
            return true
        }
        let alreadyContainWallet = importdAssets.contains {
            $0.privateKey == wallet.privateKey && $0.mainChainType == wallet.mainChainType
        }
        return !alreadyContainWallet
    }

    public func getCoinsList() -> [ChainType] {
        return ChainType.supportChains
    }

    public func createTempEthWallet(privateKey: String, address: String) -> ViewWalletInterface {
        let wallet = GeneratingWalletInfo(name: "temp", coin: .ethereum, privateKey: privateKey, address: address, accountIndex: 0, lastBalance: 0)
        return wallet
    }

    public func addTokenWallet(_ token: Token, nickName: String?, wallet: @escaping (TokenWallet) -> Void) {
        let mainCoin = ChainType.getTypeWithSymbol(symbol: token.chainType)
        let index = freeTokenIndex(for: token.contractAddress)
        let seed = TOPStore.shared.currentUser.seed
        let sourseType = BackupSourceType.app
        let walletInfo = GeneratingWalletInfo(name: mainCoin.fullName,
                                              coin: mainCoin,
                                              accountIndex: index,
                                              seed: seed,
                                              sourseType: sourseType)

        (inject() as UserStorageServiceInterface).update({ user in
            let tokenAsset = TokenWallet(name: nickName ?? "", token: token, privateKey: walletInfo.privateKey, address: walletInfo.address, accountIndex: index, lastBalance: 0)
            user.wallet?.tokenWallets.append(tokenAsset)
            wallet(tokenAsset)
        })
        (inject() as CurrencyRankDaemonInterface).update()
    }

    public func addCoinsToWallet(_ assets: [AssetInterface], nickName: String?, wallet: @escaping (GeneratingWalletInfo) -> Void) {
        guard let coins = assets as? [ChainType], let currentlyAddedWallets = TOPStore.shared.currentUser.wallet?.generatedWalletsInfo else {
            return
        }

        coins.forEach { coin in

            let index = freeIndex(for: coin)
            let seed = TOPStore.shared.currentUser.seed
            let sourseType = BackupSourceType.app
            let walletInfo = GeneratingWalletInfo(name: coin.fullName,
                                                  coin: coin,
                                                  accountIndex: index,
                                                  seed: seed,
                                                  sourseType: sourseType)
            (inject() as UserStorageServiceInterface).update({ _ in
                //                let address = walletInfo.address
                let generatedName = nickName != nil ? nickName! : walletInfo.name + " " + "\(index)"
                walletInfo.name = generatedName
                currentlyAddedWallets.append(walletInfo)
            })
            wallet(walletInfo)
        }
        (inject() as UserStorageServiceInterface).update({ user in
            user.wallet?.generatedWalletsInfo = currentlyAddedWallets
        })
        (inject() as CurrencyRankDaemonInterface).update()
    }

    public func addTokensToWallet(_ assets: [AssetInterface], for wallet: ViewWalletInterface) {
        guard let tokens = assets as? [Token] else { return }
        let copyTokens = tokens.map({ token -> Token in

            Token(id: token.id,
                  contractAddress: token.contractAddress,
                  symbol: token.symbol,
                  fullName: token.name,
                  decimals: token.decimals,
                  iconUrl: token.iconUrl,
                  webURL: token.webURL,
                  chainType: token.chainType
            )
        })
        
        copyTokens.forEach { token in
            (inject() as UserStorageServiceInterface).update({ user in
                let tokenAsset = TokenWallet(name: token.fullName, token: token, privateKey: wallet.privateKey, address: wallet.address, accountIndex: wallet.accountIndex, lastBalance: 0)
                user.wallet?.tokenWallets.append(tokenAsset)
            })
            (inject() as CurrencyRankDaemonInterface).update()
        }
    }

    public func getGeneratedWallets() -> [GeneratingWalletInfo] {
        return TOPStore.shared.currentUser.wallet?.generatedWalletsInfo.filter { $0.hidden == false } ?? []
    }

    public func getImportedWallets() -> [ImportedWallet] {
        return TOPStore.shared.currentUser.wallet?.importedWallets.filter { $0.hidden == false } ?? []
    }

    public func getTokenWallets() -> [TokenWallet] {
        return TOPStore.shared.currentUser.wallet?.tokenWallets.filter { $0.hidden == false } ?? []
    }
    public var allHiddenViewWallets: [ViewWalletInterface] {
        var wallets: [ViewWalletInterface] = TOPStore.shared.currentUser.wallet?.generatedWalletsInfo.filter { $0.hidden == true } ?? []
        wallets.append(contentsOf: TOPStore.shared.currentUser.wallet?.importedWallets.filter { $0.hidden == true } ?? [])
        wallets.append(contentsOf: TOPStore.shared.currentUser.wallet?.tokenWallets.filter { $0.hidden == true } ?? [])
        return wallets
    }

    public var allViewWallets: [ViewWalletInterface] {
        var wallets: [ViewWalletInterface] = getGeneratedWallets()
        wallets.append(contentsOf: getImportedWallets())
        wallets.append(contentsOf: getTokenWallets())
        return wallets.sorted { $0.createTime < $1.createTime }
    }

    public var viewWalletsGroup: [[ViewWalletInterface]] {
        let set = NSMutableSet()
        for wallet in allViewWallets {
            set.add(wallet.asset.assetID)
        }
        var group = Array<[ViewWalletInterface]>()
        set.enumerateObjects { assetID, _ in
            let array = allViewWallets.filter { $0.asset.assetID == assetID as! String  }
            group.append(array)
        }
        return group
    }
}

// MARK: - Index

extension WalletInteractor {
    public func freeIndex(for coin: ChainType) -> Int32 {
        guard let currentlyAddedWallets = TOPStore.shared.currentUser.wallet?.generatedWalletsInfo else { return 0 }
        let currentCoinAssets = currentlyAddedWallets.filter({ $0.mainChainType == coin })
        var index: Int32 = 0
        while index < Int32.max {
            if currentCoinAssets.contains(where: { $0.accountIndex == index }) {
                index += 1
                continue
            }
            return index
        }
        return index
    }

    public func freeTokenIndex(for contractAddress: String) -> Int32 {
        guard let currentlyAddedWallets = TOPStore.shared.currentUser.wallet?.tokenWallets else {
            return 0
        }
        let currentCoinAssets = currentlyAddedWallets.filter({ $0.token!.contractAddress == contractAddress })
        var index: Int32 = 0
        while index < Int32.max {
            if currentCoinAssets.contains(where: { $0.accountIndex == index }) {
                index += 1
                continue
            }
            return index
        }
        return index
    }
}

extension WalletInteractor {
    public func getBalanceChangePer24Hours(result: @escaping (Double) -> Void) {
        let yesterdayBalance = getYesterdayTotalBalanceInCurrentCurrency()
        let todayBalance = getTotalBalanceInCurrentCurrency()
        let balanceChange = getBalanceChanging(olderBalance: yesterdayBalance, newestBalance: todayBalance)
        result(balanceChange)
    }

    public func getBalanceChanging(olderBalance: Double, newestBalance: Double) -> Double {
        let dif = olderBalance - newestBalance
        guard olderBalance != 0 else { return 0 }
        return dif / olderBalance
    }

    public func getTotalBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allViewWallets.forEach { wallet in
            currentBalance += wallet.balanceInCurrentCurrency
        }
        return currentBalance
    }

    public func getYesterdayTotalBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allViewWallets.forEach { wallet in
            currentBalance += wallet.yesterdayBalanceInCurrentCurrency
        }
        return currentBalance
    }
}
