//
//  AddressValidator.swift
//  TOPCore
//
//  Created by Jax on 2019/9/24.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import HDWalletKit

public class ETHAddressValidator: Validator {
    public typealias Result = String
    private let address: String
    private let formatRegex = "^(0x)?[0-9a-f]{40}$"

    public init(address: String) {
        self.address = address
    }

    var isFormatValid: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", formatRegex)
        return predicate.evaluate(with: address)
    }

    public var isValid: Bool {
        if !isFormatValid {
            return false
        }
        return true
    }
}

public class BTCAddressValidator: Validator {
    private let address: String

    public init(address: String) {
        self.address = address
    }

    var isValid: Bool {
        do {
            _ = try LegacyAddress(self.address, coin: wrapCoin(coin: .bitcoin))
            return true
        } catch {
            return false
        }
    }
}
