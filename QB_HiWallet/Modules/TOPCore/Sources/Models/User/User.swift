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
    
    @objc public dynamic var registered: Bool = false //服务器注册
    public dynamic var addressBook: List<Contacts> = List()

    public convenience init(id: String, seed: String, name: String) {
        self.init()
        profile = UserProfile(name)
        self.id = id
        self.seed = seed
    }

    public var userID: String {
        let btc = GeneratingWalletInfo(name: "", coin: .bitcoin, accountIndex: 0, seed: seed, sourseType: .app)
        return btc.address.sha256()
    }

    public override class func primaryKey() -> String? {
        return "id"
    }
}
