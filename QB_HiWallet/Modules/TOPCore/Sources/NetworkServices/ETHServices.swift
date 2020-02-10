//
//  EthServices.swift
//  TOPCore
//
//  Created by Jax on 2019/7/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Alamofire
import Foundation
import Moya

public enum ETHServices {
    case getFeeList
    case getNonce(address: String)
    case getBalance(address: String)
    case sendTransaction(hexValue: String)
    case getERC20Balance(address: String, contract: String)
    case getETHTransactionhistory(address: String, pageNum: Int, pageSize: Int)
    case getEthTokenTxHistory(address: String, action: String, contractAddress: String, pageIndex: Int = 1, pageSize: Int = 1000)
}

extension ETHServices: TargetType {
    public var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }

    public var path: String {
        switch self {
        case .getBalance(address:):
            return "/v1/app/eth/query_balance"
        case .getERC20Balance:
            return "/v1/app/eth/query_erc20_balance"
        case .getNonce:
            return "/v1/app/eth/get_eth_nonce"
        case .sendTransaction:
            return "/v1/app/eth/send_transaction"
        case .getETHTransactionhistory:
            return "/v1/app/eth/get_eth_transaction_list_by_account"
        case .getFeeList:
            return "/v1/app/eth/get_gas_list"
        case .getEthTokenTxHistory:
            return "/v1/app/eth/query_tx_list"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        var params: Parameters = [:]
        switch self {
        case let .getBalance(address):
            params["address"] = address
        case let .getERC20Balance(address, contract):
            params["address"] = address
            params["contract"] = contract
        case let .getNonce(address):
            params["address"] = address
        case let .sendTransaction(hexValue):
            params["hexValue"] = hexValue
        case let .getETHTransactionhistory(address, pageNum, pageSize):
            params["address"] = address
            params["pageIndex"] = pageNum
            params["pageSize"] = pageSize
        case let .getEthTokenTxHistory(address, action, contractAddress, pageIndex, pageSize):
            params["action"] = action
            params["contractAddress"] = contractAddress
            params["pageSize"] = pageSize
            params["address"] = address
            params["pageIndex"] = pageIndex
        default:
            break
        }

        return .requestData(params.encodeBodyToBase64String().data(using: .utf8) ?? Data())
    }
}
