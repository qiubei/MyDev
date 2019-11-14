//
//  AssetPrice.swift
//  TOP
//
//  Created by Jax on 10/5/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public struct AssetPrice {
    public var currency: FiatCurrency
    public var asset: AssetInterface
    public var price: Double
    public var yesterdayPrice: Double
}
