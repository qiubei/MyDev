//
//  TOPService.swift
//  TOPCore
//
//  Created by apple on 2019/6/17.
//  Copyright © 2019 TOP. All rights reserved.
//

import Moya

public enum TOPService {
    case getBalance(address: String)
}

extension TOPService: TargetType {
    public var sampleData: Data {
        return Data()
    }
    
    public var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .getBalance(address:):
            return "top/getTopBalance"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getBalance:
            return .get

        }
    }
    
    public var task: Task {
        switch self {
        case let .getBalance(address):
            return .requestParameters(parameters: ["address": address], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}


