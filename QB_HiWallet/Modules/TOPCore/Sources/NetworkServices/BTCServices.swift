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
}

extension BTCServices: TargetType {
    public var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }

    public var path: String {
        switch self {
        case .getFeeList:
            return "btc/get_btc_fee"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getFeeList:
            return .post
        }
    }

    public var task: Task {
        let params: Parameters = [:]
        switch self {
        case .getFeeList:

            return .requestData(params.encodeBodyToBase64String().data(using: .utf8) ?? Data())
        }
    }
}
