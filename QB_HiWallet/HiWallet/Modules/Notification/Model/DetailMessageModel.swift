//
//  DetailMessageModel.swift
//  TOPCore
//
//  Created by Anonymous on 2019/12/20.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import HandyJSON

/*
 "content": "string",
"createId": 0,
"createTime": "2019-12-20T08:41:59.618Z",
"endTime": "2019-12-20T08:41:59.618Z",
"id": 0,
"noticeType": "AWAKEN",
"startTime": "2019-12-20T08:41:59.618Z",
"title": "string",
"updateId": 0,
"updateTime": "2019-12-20T08:41:59.618Z",
"url": "string"
 */

/// 消息详情（通过 message id 获取的详情信息）
/// 目前只用 content 内容
public class DetailMessageModel: HandyJSON {
    public required init() {}
    
    public var content: String = ""
}
