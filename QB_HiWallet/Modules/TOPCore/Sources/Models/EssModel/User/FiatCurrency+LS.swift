//
//  FiatCurrency+LS.swift
//  TOP
//
//  Created by Jax on 1/10/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation


extension FiatCurrency {
    public var titleString: String {
        switch self {
        case .usd:
            return "Currency.usd"
//        case .eur:
//            return "Currency.eur"
//        case .krw:
//            return "Currency.krw"
        case .cny:
            return "Currency.cny"
        case .none:
            return ""
        }
    }
}
