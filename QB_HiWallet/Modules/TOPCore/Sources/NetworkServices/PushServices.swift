//
//  PushServices.swift
//  TOPCore
//
//  Created by Jax on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//
import Alamofire
import Moya
import UIKit

public enum PushServices {
    case uploadDevice
    case removeUser
    case removeWallets(assets: [ViewWalletInterface])
    case uploadWallets(assets: [ViewWalletInterface])
    case detailMessage(id: Int64)
}

extension PushServices: TargetType {
    public var sampleData: Data {
        return Data()
    }

    public var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }

    public var path: String {
        switch self {
        case .uploadDevice:
            return "/v2/app/device/device_report"
        case .removeUser:
            return "/v2/app/device/remove_user"
        case .removeWallets:
            return "/v2/app/device/remove_token"
        case .uploadWallets:
            return "/v2/app/device/token_report"
        case .detailMessage:
            return "/v2/app/find_notice_detail"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        var params: Parameters = [:]

        switch self {
        case .uploadDevice:
            params["clientId"] = PushManager.shared.deviceID
            params["registrationId"] = PushManager.shared.deviceToken
            params["userId"] = TOPStore.shared.currentUserID
            params["region"] = "COMMON" //iOS固定

        case .removeUser:
            params["clientId"] = PushManager.shared.deviceID
            params["userId"] = TOPStore.shared.currentUserID
        case let .removeWallets(assets):
            params["clientId"] = PushManager.shared.deviceID
            params["userId"] = TOPStore.shared.currentUserID
            var array: [[String: String]] = []
            for wallet in assets {
                let assetDic = ["address": wallet.address, "chainType": wallet.chainSymbol, "contract": wallet.asset.contractAddress]
                array.append(assetDic)
            }
            params["token"] = array

        case let .uploadWallets(assets):
            params["clientId"] = PushManager.shared.deviceID
            params["userId"] = TOPStore.shared.currentUserID
            var array: [[String: String]] = []
            for asset in assets {
                let token = ["address": asset.address, "chainType": asset.chainSymbol, "contract": asset.asset.contractAddress]
                array.append(token)
            }
            params["token"] = array
        case let .detailMessage(id):
            params["id"] = id
        }
        return .requestData(params.encodeBodyToBase64String().data(using: .utf8) ?? Data())
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
