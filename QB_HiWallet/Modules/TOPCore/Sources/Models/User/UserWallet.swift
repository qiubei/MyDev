//
//  UserWallet.swift
//  TOP
//
//  Created by Jax on 12.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class UserWallet: Object {
    public dynamic var importedWallets: List<ImportedWallet> = List()
    public dynamic var generatedWalletsInfo: List<GeneratingWalletInfo> = List()
    public dynamic var tokenWallets: List<TokenWallet> = List()
    public dynamic var sourceType: BackupSourceType = .app

    public var isEmpty: Bool {
        return importedWallets.isEmpty && tokenWallets.isEmpty && generatedWalletsInfo.isEmpty
    }

   public func clearWallet() {
        importedWallets.removeAll()
        generatedWalletsInfo.removeAll()
        tokenWallets.removeAll()
    }
}
