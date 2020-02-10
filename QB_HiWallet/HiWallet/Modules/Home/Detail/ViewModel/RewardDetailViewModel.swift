//
//  RewardDetailViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import TOPCore

// 空投明细
struct RewardDetail {
    var id: Int64
    var text: String
    var dateStr: String
    var detail: NSAttributedString
    
    var interval: Double = 0
}

// 空投余额
struct RewardBalance {
    var accumulate: String // 累积空投总额
    var balance: String // 当前空投余额
}

class RewardDetailViewModel {
    
    var isEndOfPageIndex = false // 是否是分页数据的最后一页
    var datalist: [RewardDetail] = []
    var rewardBalance = RewardBalance(accumulate: "0", balance: "0")
    
    private(set) var selectedSegmentIndex: Int = 0
    private var _datalist: Set<RewardDetail> = []
    private var isShowNetError = false // 网络错误只提示一次
    
    func loadBalance(callback: @escaping (ResultAction) -> ()) {
        TOPNetworkManager<UserSerivices, UserInfo>.requestModel(.getUserInfo, success: { model in
            self.rewardBalance.accumulate = "\(model.airdrop)"
            self.rewardBalance.balance = "\(model.balance)"
            callback(.success)
        }) { error in
            self.rewardBalance.accumulate = "0"
            self.rewardBalance.balance = "0"
            callback(.failure(!self.isShowNetError))
            self.isShowNetError = true
            DLog("request user info failed: \(error)")
        }
    }
    
    func loadData(pageIndex: Int, segmentIndex: Int, callback: @escaping (ResultAction) -> ()) {
        if pageIndex == 1 {
            isEndOfPageIndex = false
        }
        selectedSegmentIndex = segmentIndex
        var type: RewardListType
        switch segmentIndex {
        case 1:
            type = .REWARD
        case 2:
            type = .SPEND
        default:
            type = .ALL
        }
        
        self.requestDetailList(type: type,pageIndex: pageIndex, callback: callback)
    }
    
    private let pageSize = 20 // 分页请求每页的请求数量
    private func requestDetailList(type: RewardListType, pageIndex: Int, callback: @escaping (ResultAction) -> ()) {
        TOPNetworkManager<UserSerivices, RewardDetailModel>.requestModelList(.rewordHistoryList(type: type, pageIndex: pageIndex, pageSize: pageSize), success: { (list, _) in
            if pageIndex == 1 {
                self._datalist = []
                self.datalist = []
            }
            let _datalist = list?.map { $0.mappper() }
            
            if let array = _datalist, array.count < self.pageSize {
                self.isEndOfPageIndex = true
            }
            
            //按时间排序的列表
            self._datalist = self._datalist.union(_datalist ?? [])
            self.datalist = Array(self._datalist).sorted { $0.interval > $1.interval }
            
            callback(.success)
        }) { error in
            self.datalist = []
            callback(.failure(!self.isShowNetError))
            self.isShowNetError = true
            DLog("request reward detail error \(error)")
        }
    }
}
 
extension RewardDetail: Hashable {
    public static func == (lhs: RewardDetail, rhs: RewardDetail) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

fileprivate extension RewardDetailModel {
    func mappper() -> RewardDetail {
        let formate = "yyyy-MM-dd HH:mm"
        let interval = TimeInterval(receiveTime)! / 1000
        let dateStr = Date.init(timeIntervalSince1970: interval).string(custom: formate)
        let detail = balanceAttributeString(type: amountType, amount: "\(amount)", unit: unit)
        var model = RewardDetail(id: rewardId,
                                 text: type,
                                 dateStr: dateStr,
                                 detail: detail)
        model.interval = interval
        return model
    }
}

private func balanceAttributeString(type: AmountDetailType, amount: String, unit: String) -> NSAttributedString {
    var color = App.Color.mainColor
    var prefix = "+"
    if type == .output {
        color = App.Color.titleColor
        prefix = "-"
    }
    return CryptoFormatter.attributeString(amount: prefix + amount,
                                           balance: unit,
                                           aFontSize: 16,
                                           aColor: color,
                                           bFontSize: 10,
                                           bColor: color)
}
