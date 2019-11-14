//
//  User.swift
//  TOP
//
//  Created by Jax on 15.08.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import RealmSwift
import UIKit

@objc
public class User: Object {
    @objc public dynamic var id: String = ""
    @objc public dynamic var profile: UserProfile? = UserProfile()
    @objc public dynamic var backup: UserBackup? = UserBackup()
    @objc public dynamic var userEvents: UserEvents? = UserEvents()
    @objc public dynamic var wallet: UserWallet? = UserWallet() // 本地钱包（包含各种币钱包的集合）
    @objc public dynamic var seed: String = ""
    @objc public dynamic var mnemonic: String?
    @objc public dynamic var rootPrivateKey: String = ""
    public dynamic var addressBook: List<Contacts> = List()

    public convenience init(id: String, seed: String, name: String) {
        self.init()
        profile = UserProfile(name)
        self.id = id
        self.seed = seed
    }

    public override class func primaryKey() -> String? {
        return "id"
    }
}
