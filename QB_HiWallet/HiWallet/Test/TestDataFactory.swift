//
//  TestDataFactory.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/4.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore
import EssentiaBridgesApi

class TestDataFactory {
    static let `default` = TestDataFactory()
    private init () {}

    
    func createImportWallet() -> ViewWalletInterface {
        let coin = MainCoin.bitcoin
        let wallet = ImportedWallet(address: "1hvzSofGwT8cjb8JU7nBsCSfEVQX5u9CLp",
                                    coin: coin,
                                    privateKey: "123456",
                                    name: "Bitcoin",
                                    lastBalance: 19882.1)
        
        return wallet
    }
    
    
    func createGeneratedWallet() -> ViewWalletInterface {
        let wallet = GeneratingWalletInfo(name: "USDT",
                                          coin: MainCoin.dash,
                                          privateKey: "123456",
                                          address: "3hvzSofGwT8cjb8JU7nBsCSfEVQX5u9CLp",
                                          accountIndex: 1,
                                          lastBalance: 7.11)
        
        return wallet
    }


    
 
}
