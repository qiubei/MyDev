//
//  BitcoinConverter.swift
//  TOPCore
//
//  Created by Jax on 3/18/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation

//public typealias Satoshi = UInt64
//public typealias Bitcoin = Double
public var satoshiesInBitcoin: Double = 100_000_000

public class BitcoinConverter {
    private let value: UInt64
    
    public init(satoshi: UInt64) {
        self.value = satoshi
    }
    
    public init(bitcoin: Double) {
        self.value = UInt64(bitcoin * satoshiesInBitcoin)
    }
    
    public convenience init(bitcoinString: String) {
        self.init(bitcoin: Double(bitcoinString) ?? 0)
    }
    
    public convenience init(satoshiString: String) {
        self.init(satoshi: UInt64(satoshiString) ?? 0)
    }
    
    public var inSatoshi: UInt64 {
        return value
    }
    
    public var inBitcoin: Double {
        return Double(value) / satoshiesInBitcoin
    }
}
