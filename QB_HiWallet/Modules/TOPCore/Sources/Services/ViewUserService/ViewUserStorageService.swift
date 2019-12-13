//
//  UserService.swift
//  TOP
//
//  Created by Jax on 15.08.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

import RealmSwift

public class ViewUserStorageService: ViewUserStorageServiceInterface {
    let realm: Realm
    let Version: UInt64 = 21

    public init() {
        let config = Realm.Configuration(schemaVersion: Version, migrationBlock: { _, _ in

        })
        realm = try! Realm(configuration: config)
    }

    public func add(_ user: ViewUser) {
        try? realm.write {
            realm.add(user)
        }
    }

    public func remove(_ user: ViewUser) {
        try? realm.write {
            realm.delete(user)
        }
    }

    public var users: [ViewUser] {
        return realm.objects(ViewUser.self).map({ $0 })
    }

    public var current: ViewUser? {
        return realm.objects(ViewUser.self).filter({ (user) -> Bool in
            user.id == TOPStore.shared.currentUser.id
        }).first
    }

    public func update(_ updateBlock: (ViewUser) -> Void) {
        let currentUserId = TOPStore.shared.currentUser.id
        let viewUser = users.first {
            $0.id == currentUserId
        }
        guard let user = viewUser else { return }
        try? realm.write {
            updateBlock(user)
        }
    }
}
