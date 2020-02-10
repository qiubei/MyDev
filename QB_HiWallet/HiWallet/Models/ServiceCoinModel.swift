//
//  SearchCoin.swift
//  TOPModel
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import RealmSwift
import UIKit

public class ServiceCoinModel: Object, HandyJSON {
    // 是否是主链
    @objc private dynamic var mainChain: Bool = true
    // fullName
    @objc public dynamic var englishName: String = ""
    // 中文名
    @objc public dynamic var chineseName: String?
    // 合约地址
    @objc public dynamic var contractAddress: String?
    // 介绍
    @objc public dynamic var introduce: String = ""
    // 后台数据库索引id
    @objc public dynamic var id: Int32 = 0
    // icon
    @objc public dynamic var iconUrl: String = ""
    // 精度
    @objc public dynamic var decimals: Int = 0
    // 代币的详情地址
    @objc public dynamic var infoURL: String?
    // symbol
    @objc public dynamic var symbol: String = ""
    // 主链类型
    @objc public dynamic var chainType: String = ""

    public var isMainChain: Bool {
        return mainChain
    }


    public  func copy() -> ServiceCoinModel {
        let model = ServiceCoinModel()
        model.mainChain = mainChain
        model.englishName = englishName
        model.chineseName = chineseName
        model.contractAddress = contractAddress
        model.introduce = introduce
        model.id = id
        model.iconUrl = iconUrl
        model.decimals = decimals
        model.infoURL = infoURL
        model.symbol = symbol
        model.chainType = chainType
        return model
    }
}
