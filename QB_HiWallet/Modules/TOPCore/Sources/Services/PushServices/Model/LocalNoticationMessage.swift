//
//  LocalNoticationMessage.swift
//  TOPCore
//
//  Created by Jax on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import RealmSwift
import UIKit

//数据库存储类型
class LocalNoticationMessage: Object {
    public required init() {
    }

    @objc dynamic var title = ""
    @objc dynamic var id = ""
    @objc dynamic var desc = ""
    @objc dynamic var time = ""
    @objc dynamic var type = ""
    @objc dynamic var isRead = false
    @objc dynamic var txhash = ""
    @objc dynamic var url = ""

    init(model: PushMessage) {
        title = model.title
        id = model.id
        time = model.time
        type = model.type.rawValue
        isRead = model.isRead
        txhash = model.txhash ?? ""
        url = model.url ?? ""
        desc = model.desc
    }

//    @objc public override class func primaryKey() -> String? { return "id" }
}
