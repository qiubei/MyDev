//
//  UserSerivices.swift
//  TOPCore
//
//  Created by Jax on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import UIKit

//这个枚举类型需要跟后台一致
public enum RewardListType: String {
    case SPEND
    case REWARD
    case ALL
}

public enum UserSerivices {
    case getUserInfo//用户信息获取
    case rewordHistoryList( //奖励领取记录
        type: RewardListType,
        pageIndex: Int,
        pageSize: Int)
    case uploadReward(rewardId: String) //用户上报奖励
    case register//用户注册登
    case getRewardList //待领取
    case getActivityList //活动列表
    case uploadTx(txHash: String) //上报成功交易
}

extension UserSerivices: TargetType {
    public var sampleData: Data {
        return Data()
    }

    public var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }

    public var path: String {
        switch self {
        case .getUserInfo:
            return "/v1/app/user/info"
        case .rewordHistoryList:
            return "/v1/app/user/find_reward_history"
        case .uploadReward:
            return "/v1/app/user/receive_award"
        case .register:
            return "/v1/app/user/register"
        case .getRewardList:
            return "/v1/app/user/reward"
        case .getActivityList:
            return "/v1/app/activity/find_activity_list"
        case .uploadTx:
            return "/v1/app/activity/rec_suc_tran"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        var params: Parameters = [:]

        switch self {
        case .getUserInfo:
            params["uid"] = TOPStore.shared.currentUserID
        case let .rewordHistoryList(rewordListType, pageIndex, pageSize):
            params["uid"] = TOPStore.shared.currentUserID
            params["pageSize"] = pageSize
            params["pageIndex"] = pageIndex
            params["side"] = rewordListType.rawValue

        case let .uploadReward(rewardId):
            params["uid"] = TOPStore.shared.currentUserID
            params["rewardId"] = rewardId

        case .register:
            params["uid"] = TOPStore.shared.currentUserID
            params["deviceId"] = KCID.getKCID()

        case .getRewardList:
            params["uid"] = TOPStore.shared.currentUserID

        case .getActivityList:
            params["uid"] = TOPStore.shared.currentUserID
            break
        case let .uploadTx(txHash):
            params["uid"] = TOPStore.shared.currentUserID
            params["hash"] = txHash
        }

        return .requestData(params.encodeBodyToBase64String().data(using: .utf8) ?? Data())
    }

    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
