//
//  UserWallet+UniqueAsset.swift
//  TOPCore
//
//  Created by Jax on 1/9/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation

extension UserWallet {
    public var uniqueAssets: [AssetInterface] {
        var allAssets: [AssetInterface] = []
        var unique: [AssetInterface] = []

        allAssets.append(contentsOf: importedWallets.filter({ !$0.hidden }).map({ $0.coin }))
        allAssets.append(contentsOf: generatedWalletsInfo.filter({ !$0.hidden }).map({ $0.mainCoinType }))
        allAssets.append(contentsOf: tokenWallets.filter({ !$0.hidden }).compactMap({ $0.token }))
        for asset in allAssets {
            guard !unique.contains(where: { $0.name == asset.name }) else { continue }
            unique.append(asset)
        }
        return unique
    }

    public func open(wallet: ViewWalletInterface) {
        switch wallet {
        case let generated as GeneratingWalletInfo:
            generated.hidden = false
        case let imported as ImportedWallet:
            imported.hidden = false
        case let token as TokenWallet:
            token.hidden = false
        default:
            return
        }
    }

    //TODO: 用 remove 是不是不太好，open 对应 close 或者直接用 hidden？？？
    /// 隐藏钱包
    public func remove(wallet: ViewWalletInterface) {
        switch wallet {
        case let generated as GeneratingWalletInfo:
            generated.hidden = true
        case let imported as ImportedWallet:
            imported.hidden = true
        case let token as TokenWallet:
            token.hidden = true
        default:
            return
        }
    }

    public func delete(wallet: ViewWalletInterface) {
        switch wallet {
        case let generated as GeneratingWalletInfo:
            realm?.delete(generated)
        case let imported as ImportedWallet:
            realm?.delete(imported)
        case let token as TokenWallet:
            realm?.delete(token)
        default:
            return
        }
    }
}
