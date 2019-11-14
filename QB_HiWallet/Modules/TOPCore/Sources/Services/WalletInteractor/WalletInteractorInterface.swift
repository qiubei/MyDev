//
//  WalletInteractorInterface.swift
//  TOP
//
//  Created by Jax on 06.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public protocol WalletInteractorInterface {
    
    func isValidWallet(_ wallet: ImportedWallet) -> Bool
    // 添加主币
    func addCoinsToWallet(_ assets: [AssetInterface], nickName: String?, wallet: @escaping (GeneratingWalletInfo) -> Void)
    // 根据索引创建Token钱包
    func addTokenWallet(_ token: Token, nickName: String?, wallet: @escaping (TokenWallet) -> Void)
    // 添加代币到某个主币下
    func addTokensToWallet(_ assets: [AssetInterface], for wallet: ViewWalletInterface)
    //
    func getCoinsList() -> [MainCoin] // 获取支持的主币列表
    func getAllWallet() -> [ViewWalletInterface] // 获取所有钱包，包括导入的
    func getAllWalletGroup() -> [[ViewWalletInterface]] // 根据钱包类型获得分组
    func getGeneratedWallets() -> [GeneratingWalletInfo]
    func getImportedWallets() -> [ImportedWallet]
    func getTokenWallets() -> [TokenWallet]
    func getTokensByWalleets() -> [ViewWalletObject: [TokenWallet]]
    //
    func getTotalBalanceInCurrentCurrency() -> Double
    func getYesterdayTotalBalanceInCurrentCurrency() -> Double
    func getBalanceChangePer24Hours(result: @escaping (Double) -> Void)
    func getBalanceChanging(olderBalance: Double, newestBalance: Double) -> Double
    
    //
    func nameIsExist(for name: String, coin: MainCoin) -> Bool

    //筛选
    func getWalletWithAssetID(assetID: String) -> [ViewWalletInterface]
    func getHiddenWalletWithAssetID(assetID: String) -> [ViewWalletInterface]
    func getERC20TOPTokenWallet() -> [ViewWalletInterface]
    func openERC20TOPTokenWallet()
    func createTempEthWallet(privateKey: String, address: String) -> ViewWalletInterface
}
