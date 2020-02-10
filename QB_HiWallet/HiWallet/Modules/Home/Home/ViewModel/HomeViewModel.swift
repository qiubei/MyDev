//
//  HomeViewModel.swift
//  HiWallet
//
//  Created by Jax on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import TOPCore

public class HomeViewModel {
    var activityList: [ActivityModel] = []
    var awardList: [CoinInfo] = []
    var balance: String = "0"

    public func loadData(success: @escaping EmptyBlock) {
        if !App.isLogined { return }

        if !UserManager.shared.registered {
            UserManager.shared.register {
                self.loadData(success: success)
            }
            return
        }

        let group = DispatchGroup()

        group.enter()

        TOPNetworkManager<UserSerivices, ActivityModel>.requestModelList(.getActivityList, success: { list, _ in
            self.activityList = list ?? []
            group.leave()

        }) { _ in
            
            Toast.showToast(text: "网络出走了，请检查网络状态后重试".localized())
            group.leave()
        }
        group.enter()

        TOPNetworkManager<UserSerivices, UserInfo>.requestModel(.getUserInfo, success: { model in
            self.balance = model.balance
            group.leave()

        }) { _ in
            group.leave()
        }
        group.enter()

        TOPNetworkManager<UserSerivices, CoinInfo>.requestModelList(.getRewardList, success: { list, _ in

            //测试

            self.awardList = list ?? []

//            let num3 = Int(arc4random_uniform(UInt32(3)))
//            DLog("新产生了\(num3)个")
//            for i in 0 ... 2 {
//                let coin = CoinInfo()
//                coin.amount = "\(i)"
//
//                let num2 = Int(arc4random_uniform(UInt32(10000)))
//                coin.rewardId = "\(num2)"
//                coin.canReceive = true
//                self.awardList.insert(coin, at: 0)
//            }
            group.leave()

        }) { _ in
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            success()
        }
    }

    public func reloadData(success: @escaping EmptyBlock) {
        getAwardList()
    }

    func getAwardList() {
        TOPNetworkManager<UserSerivices, CoinInfo>.requestModelList(.getRewardList, success: { list, _ in
            self.awardList = list ?? []
            DLog(list)
        }) { _ in
        }
    }

    func takeCoin(awardID: String) {
        awardList.removeAll(where: { $0.rewardId == awardID })
    }

    func getShowCoin() -> [CoinInfo] {
        let showList = [] + awardList.prefix(6)
        return showList
    }
}
