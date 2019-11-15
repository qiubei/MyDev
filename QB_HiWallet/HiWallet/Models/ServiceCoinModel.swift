//
//  SearchCoin.swift
//  TOPModel
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import UIKit

public class ServiceCoinModel: BaseModel {
    // 是否是主链
    private var mainChain: Bool = true
    // fullName
    public var englishName: String = ""
    // 中文名
    public var chineseName: String?
    // 合约地址
    public var contractAddress: String?
    // 介绍
    public var introduce: String = ""
    // 后台数据库索引id
    public var id: Int = 0
    // icon
    public var iconUrl: String = ""
    // 精度
    public var decimals: Int?
    // 代币的详情地址
    public var infoURL: String?
    // symbol
    public var symbol: String = ""
    // 主链类型
    public var chainType: String = ""

    public var isMainChain: Bool {
        return mainChain
    }
}
