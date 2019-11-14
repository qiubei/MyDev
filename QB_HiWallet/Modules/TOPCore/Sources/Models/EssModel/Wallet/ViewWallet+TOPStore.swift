//
//  ViewWallet+EssStore.swift
//  TOP
//
//  Created by Jax on 1/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

public extension ViewWalletInterface {
    
    var formattedBalanceInCurrentCurrencyWithSymbol: String {
        let currency = TOPStore.shared.currentUser.profile?.currency ?? .cny
    
        guard let rank = TOPStore.shared.ranks.getRank(for: asset, on: currency) else {
                return currency.symbol + "0.00"
        }
        return formattedBalanceInCurrency(currency: currency, with: rank)
    }
    

    var balanceInCurrentCurrency: Double {
        guard let currency = TOPStore.shared.currentUser.profile?.currency,
              let rank = TOPStore.shared.ranks.getRank(for: asset, on: currency) else {
            return 0
        }
        return balanceInCurrency(currency: currency, with: rank)
    }
    
    var yesterdayBalanceInCurrentCurrency: Double {
        guard let currency = TOPStore.shared.currentUser.profile?.currency,
              let rank = TOPStore.shared.ranks.getYesterdayRank(for: asset, on: currency) else {
            return 0
        }
        return balanceInCurrency(currency: currency, with: rank)
    }
}
