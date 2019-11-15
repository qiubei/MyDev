//
//  ViewWalletInterface.swift
//  TOP
//
//  Created by Jax on 10/1/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import RealmSwift
import UIKit

public protocol ViewWalletInterface: WalletProtocol, ThreadConfined {
    var assetID: String { get }
    var logoUrl: String { get }
    var symbol: String { get }
    var isMainCoin: Bool { get }
    var chainSymbol: String { get }
    var formattedBalance: String { get }
    var lastBalance: Double { get set}

    func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double
    func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double  //暂时不用
    func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String 
}

public struct ViewWalletObject: Hashable {
    public static func == (lhs: ViewWalletObject, rhs: ViewWalletObject) -> Bool {
        return lhs.address == rhs.address && lhs.name == rhs.name
    }

    public var address: String
    public var name: String
}

extension ViewWalletInterface {
    public var viewWalletObject: ViewWalletObject {
        return ViewWalletObject(address: address, name: name)
    }
}
