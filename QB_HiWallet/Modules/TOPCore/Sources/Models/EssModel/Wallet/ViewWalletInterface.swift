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
    var logoUrl: String { get }
    var symbol: String { get }
    var name: String { get set }
    var fullName: String { get }
    var formattedBalance: String { get }
    var lastBalance: Double { get set }

    func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double
    func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double //暂时不用
    func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String
}
