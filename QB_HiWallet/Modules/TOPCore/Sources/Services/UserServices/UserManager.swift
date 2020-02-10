//
//  UserManager.swift
//  TOPCore
//
//  Created by Jax on 2020/1/10.
//  Copyright © 2020 TOP. All rights reserved.
//  本类是管理服务器用户的user

import Foundation

public class UserManager {
    public static let shared = UserManager()
    public var registered: Bool { //服务器是否注册
        return TOPStore.shared.currentUser.registered
    }

    //注册
    public func register(callBack: @escaping EmptyBlock) {
        if registered { return }
        TOPNetworkManager<UserSerivices, EmptyResult>.requestModel(.register, success: { _ in

            (inject() as UserStorageServiceInterface).update({ user in
                user.registered = true
                callBack()
            })

        }) { _ in
        }
    }

    //领取奖励
    public func uploadAward(awardID: String) {
        TOPNetworkManager<UserSerivices, EmptyResult>.requestModel(.uploadReward(rewardId: awardID))
    }
}
