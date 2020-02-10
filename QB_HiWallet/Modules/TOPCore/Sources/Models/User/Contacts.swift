//
//  UserAddressBook.swift
//  TOPCore
//
//  Created by Jax on 2019/8/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class Contacts: Object {
    public dynamic var address: String = ""
    public dynamic var symble: String = ""
    public dynamic var note: String = ""
    public dynamic var commonlyUsed: Bool = false
    public dynamic var id: String = ""

    public convenience init(address: String, symble: String, note: String, commonlyUsed: Bool) {
        self.init()
        id = NSUUID().uuidString
        self.address = address
        self.symble = symble
        self.note = note
        self.commonlyUsed = commonlyUsed
    }

   public func delete() {
        realm?.delete(self)
    }
}
