//
//  RealmUserStorage.swift
//  EssStore
//
//  Created by Jax on 1/20/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import RealmSwift

import Foundation

fileprivate struct Constants {
    static var storageFolder = "Users"
    static var keyStoreFolder = "Keystore"
    static let DB_Version: UInt64 = 19
}

public class RealmUserStorage: UserStorageServiceInterface {
    private let userID: String
    private let config: Realm.Configuration

    public required convenience init(user: User, password: String) throws {
        do {
            try self.init(seedHash: user.id, password: password)
            try autoreleasepool {
                let realm = try! Realm(configuration: config)
                try realm.write {
                    realm.add(user)
                }
            }
            let index = ViewUserStorageService().freeIndex
            let passwordHash = password.sha512().sha512()
            let viewUser = ViewUser(id: user.id, index: index, name: user.profile?.name ?? "", icon: user.profile?.imageData, passwordHash: passwordHash)
            ViewUserStorageService().add(viewUser)
        }
    }

    public required init(seedHash: String, password: String) throws {
        LocalFilesService().createFolder(path: .final(Constants.storageFolder))
        userID = seedHash
        let key = Data(hex: password.sha512())
        let defaultConfig = Realm.Configuration.defaultConfiguration
        guard let defaultUrl = defaultConfig.fileURL else {
            throw TOPError.dbError(.databaseNotFound)
        }
        let url = defaultUrl.deletingLastPathComponent().appendingPathComponent(Constants.storageFolder).appendingPathComponent("\(seedHash).realm")
        config = Realm.Configuration(fileURL: url, encryptionKey: key, readOnly: false, schemaVersion: Constants.DB_Version, migrationBlock: { _, oldSchemaVersion in
            if oldSchemaVersion < Constants.DB_Version {
                if oldSchemaVersion < 16 {
                    DLog("需要删除")
                    UserDefaults.standard.set(true, forKey: "NeedClearDB")
                }
                DLog("更新数据库》》》》》》》》》》》》》》》》》")
            }
        })
        _ = try Realm(configuration: config)
    }

    public var getOnly: User {
        let realm = try! Realm(configuration: config)
        return realm.object(ofType: User.self, forPrimaryKey: userID)!
    }

    public func get(_ user: @escaping (User) -> Void) {
        autoreleasepool {
            user(self.get())
        }
    }

    private func get() -> User {
        let realm = try! Realm(configuration: config)
        return realm.object(ofType: User.self, forPrimaryKey: userID)!
    }

    public func remove(userID: String) {
        let realm = try! Realm(configuration: config)
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            DLog(error)
        }
        // delete DataBase

        try? LocalFilesService().removeFile(at: .final(Constants.storageFolder), with: "\(userID).realm")
        try? LocalFilesService().removeFile(at: .final(Constants.storageFolder), with: "\(userID).realm.lock")
        try? LocalFilesService().removeFile(at: .final(Constants.storageFolder), with: "\(userID).realm.management")

        // delete KeyStore
        try? LocalFilesService().removeFile(at: .final(Constants.keyStoreFolder), with: userID)
    }

    public func update(_ updateBlock: @escaping (User) -> Void) {
        do {
            try autoreleasepool {
                let realm = try! Realm(configuration: config)
                try realm.write {
                    updateBlock(self.get())
                }
            }
        } catch {
        }
    }

    public func realmQueue(_ block: @escaping () -> Void) {
        DispatchQueue(label: Constants.storageFolder).async {
            block()
        }
    }

    public func close() {
    }
}
