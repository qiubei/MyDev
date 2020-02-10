//
//  PushMessage.swift
//  TOPCore
//
//  Created by Jax on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import UIKit
//消息类型
public enum MessageType: String, HandyJSONEnum {
    case AWAKEN //唤醒
    case TRANSACTION //交易类型
    case NOTICE_ALL //公告全部，不需要调用接口显示详情
    case ACTIVITY //活动，需要跳转H5
    case NOTICE_SIMPLE //公告简略，需要调接口展示详情
}

//推送消息模型
public class PushMessage: HandyJSON {
    public var title = ""
    public var id = ""
    public var desc = ""
    public var time = "" // 毫秒为单位
    public var type: MessageType = .AWAKEN
    public var txhash: String? = ""
    public var isRead = false
    public var url: String? = ""

    public required init() {}

    init(localMessage: LocalNoticationMessage) {
        title = localMessage.title
        id = localMessage.id
        time = localMessage.time
        type = MessageType(rawValue: localMessage.type) ?? .AWAKEN
        isRead = localMessage.isRead
        txhash = localMessage.txhash
        url = localMessage.url
        desc = localMessage.desc
    }
}
