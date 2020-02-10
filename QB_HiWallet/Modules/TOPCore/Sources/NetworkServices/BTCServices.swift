//
//  BTCServices.swift
//  TOPCore
//
//  Created by Jax on 2019/8/26.
//  Copyright © 2019 TOP. All rights reserved.
//

import Alamofire
import Moya
import UIKit
public enum BTCServices {
    case getFeeList
    case getBalance(address: String)
}

extension BTCServices: TargetType {
    public var baseURL: URL {
        switch self {
        case .getFeeList:
            return URL(string: NetworkConfig.default.baseURL)!

        case .getBalance:
            return URL(string: TOPConstants.bridgeUrl)!
        }
    }

    public var path: String {
        switch self {
        case .getFeeList:
            return "/v1/app/btc/get_btc_fee"
        case let .getBalance(address):
            return "/bitcoin/wallets/\(address)/balance"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getFeeList:
            return .post
        case .getBalance:
            return .get
        }
    }

    public var task: Task {
        var params: Parameters = [:]
        switch self {
        case .getFeeList:

            return .requestData(params.encodeBodyToBase64String().data(using: .utf8) ?? Data())
        case .getBalance:
            return .requestPlain
        }
    }
}
