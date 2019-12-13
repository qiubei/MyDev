//
//  NormalService.swift
//  TOPCore
//
//  Created by Anonymous on 2019/10/14.
//  Copyright © 2019 TOP. All rights reserved.
//

import Alamofire
import HandyJSON
import Moya

/// 普通接口
public enum CommonServices {
    case getStakingSwitch
    case checkAppUpdate
    // 资产管理
    case hotCoinSpecies
    case searchCoin(
        coinName: String,
        pageIndex: Int = 1,
        pageSize: Int = 10)
}

extension CommonServices: TargetType {
    public var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }

    public var path: String {
        switch self {
        case .getStakingSwitch:
            return "get_staking_switch"
        case .checkAppUpdate:
            return "check_update"
        case .hotCoinSpecies:
            return "find_hot_coin_species"
        case .searchCoin:
            return "find_coin_species"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        var params: Parameters = [:]
        switch self {
        case .getStakingSwitch:
            params["platform"] = 1
            params["version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        case .checkAppUpdate:
            params["platform"] = 1
            params["version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        case let .searchCoin(name, pageIndex, pageSize):
            params["chainType"] = ChainType.supportChainNames
            params["coinName"] = name
            params["language"] = LocalizationLanguage.systemLanguage == .chinese ? 0 : 1
            params["pageIndex"] = pageIndex
            params["pageSize"] = pageSize

        case .hotCoinSpecies:
            params["chainType"] = ChainType.supportChainNames
            params["language"] = LocalizationLanguage.systemLanguage == .chinese ? 0 : 1
            params["pageSize"] = 100

        }

        return .requestData(params.encodeBodyToBase64String().data(using: .utf8) ?? Data())
    }
}
