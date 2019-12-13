//
//  EthereumTransaction+Status.swift
//  TOP
//
//  Created by Jax on 10/26/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import EssentiaBridgesApi


public extension EthereumTransactionDetail {
    var status: TransactionStatus {
        if isError == "1" {
            return .failure
        }
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }
    
    func type(for: String) -> TransactionType {
        switch `for`.uppercased() {
        case to.uppercased():
            return .recive
        case from.uppercased():
            return .send
        default:
            return .recive
        }
    }
}

public extension EthereumTokenTransactionDetail {
    var status: TransactionStatus {
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }
    
    func type(for: String) -> TransactionType {
        switch `for`.uppercased() {
        case to.uppercased():
            return .recive
        case from.uppercased():
            return .send
        default:
            return .send
        }
    }
}
