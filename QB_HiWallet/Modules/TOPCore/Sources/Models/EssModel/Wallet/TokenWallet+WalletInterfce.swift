//
//  TokenWallet+WalletInterfce.swift
//  TOPCore
//
//  Created by Jax on 12/27/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation

extension TokenWallet: WalletProtocol, ViewWalletInterface {
    
    public var assetID: String {
        return token!.chainType + "-" + token!.symbol
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
