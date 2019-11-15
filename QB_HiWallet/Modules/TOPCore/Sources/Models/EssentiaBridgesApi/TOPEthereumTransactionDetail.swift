//
//  TOPEthereumTransactionDetail.swift
//  TOPCore
//
//  Created by Anonymous on 2019/9/21.
//  Copyright © 2019 TOP. All rights reserved.
//

import EssentiaBridgesApi
import Foundation
import HDWalletKit

public struct TOPEthereumTransactionDetail: Codable {
    public var blockHash: String
    public var blockNumber: String
    public var confirmations: String
    public var contractAddress: String
    public var cumulativeGasUsed: String
    public var from: String
    public var gas: String
    public var gasPrice: String
    public var hash: String
    public var input: String
    public var isError: String?
    public var nonce: String
    public var timeStamp: String
    public var to: String
    public var transactionIndex: String
    public var txreceipt_status: String?
    public var gasUsed: String
    public var value: String
}

public extension TOPEthereumTransactionDetail {
    var fee: String {
        let gas = BInt(gasPrice)! * BInt(gasUsed)!
        let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(gas)")
        let fee = NSDecimalNumber(string: String(format: "%.15f", gasValue))
        return "\(fee)"
    }

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
