//
//  ViewUser.swift
//  EssModel
//
//  Created by Jax on 1/23/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class ViewUser: Object {
    public dynamic var id: String = ""
    public dynamic var index: Int = 0
    public dynamic var name: String = ""
    public dynamic var icon: Data = Data()
    public dynamic var passwordHash: String = ""
    public dynamic var test: String = ""
    public dynamic var biometricLogin: Bool = false // 生物识别登录
    public dynamic var biometricPay: Bool = false // 生物支付

    public convenience init(id: String, index: Int, name: String, icon: Data?, passwordHash: String) {
        self.init()
        self.id = id
        self.index = index
        self.name = name
        self.icon = icon ?? Data()
        self.passwordHash = passwordHash
        test = ""
    }
}
