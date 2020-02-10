//
//  ViewWalletInterface+Default.swift
//  TOPCore
//
//  Created by Jax on 12/28/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation


public extension ViewWalletInterface {
    func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double {
        return lastBalance * rank
    }
    
    func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double {
        return lastBalance * rank
    }
    
    func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String {
        let formatter = BalanceFormatter(currency: currency)
        return  formatter.formattedAmmountWithSymbol(amount: balanceInCurrency(currency: currency, with: rank))
    }
    
    var formattedBalance: String {
        let formatter = BalanceFormatter(asset: asset)
        return formatter.formattedAmmount(amount: lastBalance)
    }
    
    var iconUrl: String {
//        return CoinIconsUrlFormatter(name: asset.name, size: .x128).url
        return logoUrl

    }
    
    var formattedBalanceWithSymbol: String {
        return formattedBalance + " " + asset.symbol
    }
}
