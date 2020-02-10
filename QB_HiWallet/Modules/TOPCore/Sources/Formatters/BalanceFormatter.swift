//
//  BalanceFormatter.swift
//  TOP
//
//  Created by Jax on 10/12/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

fileprivate enum CurrencySimpolPosition {
    case prefix
    case suffix
}

public final class BalanceFormatter {
    private let balanceFormatter: NumberFormatter
    private var currencySymbol: String
    private var symbolPossition: CurrencySimpolPosition
    private var rank: Double

    public convenience init(currency: FiatCurrency) {
        self.init()
        balanceFormatter.maximumFractionDigits = 2
        symbolPossition = .prefix
        currencySymbol = currency.symbol
    }

    public convenience init(asset: AssetInterface) {
        self.init()
        currencySymbol = asset.symbol
        rank = TOPStore.shared.ranks.getRank(for: asset, on: TOPStore.shared.currentUser.profile?.currency ?? .cny) ?? 0
        symbolPossition = .suffix
        balanceFormatter.minimumFractionDigits = 0
        balanceFormatter.maximumFractionDigits = 8
        balanceFormatter.roundingMode = .down
    }

    private init() {
        balanceFormatter = NumberFormatter()
        balanceFormatter.numberStyle = .currency
//        balanceFormatter.currencyGroupingSeparator = ","
        balanceFormatter.currencySymbol = ""
        balanceFormatter.usesGroupingSeparator = false
        symbolPossition = .prefix
        currencySymbol = ""
        rank = 0
        balanceFormatter.decimalSeparator = "."
    }

    public func  formattedAmmountWithSymbol(amount: Double?) -> String {
        let formatted = formattedAmmount(amount: amount)
        switch symbolPossition {
        case .prefix:
            return currencySymbol + formatted
        case .suffix:
            return formatted + " " + currencySymbol.uppercased()
        }
    }

    public func formattedAmmountWithSymbol(amount: String) -> String {
        return formattedAmmountWithSymbol(amount: Double(amount))
    }

    public func formattedAmmount(amount: Double?) -> String {
        let amount = amount ?? 0
        return balanceFormatter.string(for: amount) ?? "0"
    }

    public func formattedAmmount(amount: String) -> String {
        return formattedAmmount(amount: Double(amount))
    }

    public class func getCurreyPrice(fullName:String ,value: Double) -> String {
        let symble = TOPStore.shared.currentUser.profile?.currency ?? .cny
        let formatter = BalanceFormatter(currency: TOPStore.shared.currentUser.profile?.currency ?? .cny)

        guard let currency = TOPStore.shared.currentUser.profile?.currency,
            let rank = TOPStore.shared.ranks.getRank(for: fullName, on: currency) else {
            return symble.symbol + "0.00"
        }
        return " ≈ " + formatter.formattedAmmountWithSymbol(amount: value * rank)
    }
}
