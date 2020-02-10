//
//  Currencies.swift
//  TOP
//
//  Created by Jax on 24.08.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public enum FiatCurrency: String, Codable, Equatable, Hashable {
    case usd
    case cny
    case none
    
    public var symbol: String {
        switch self {
        case .usd:
            return "$ "
        case .cny:
            return "¥ "
        case .none:
            return ""
        }
    }
    
    public var name: String {
        switch self {
        case .usd:
            return "USD"
        case .cny:
            return "CNY"
        case .none:
            return ""
        }
    }
    
    
    public static var cases: [FiatCurrency] {
        return [.usd, .cny]
    }
}
