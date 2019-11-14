//
//  BackupType.swift
//  TOPModel
//
//  Created by Jax on 12/26/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation
import RealmSwift

public enum AuthType {
    case login
    case backup
}

@objc
public class CurrentlyBackup: Object {
    private var currentlyBackuped: List<Int> = List()
    
    public func add(_ type: BackupType) {
        if !currentlyBackuped.contains(type.rawValue) {
            currentlyBackuped.append(type.rawValue)
        }
    }
    
    public func remove(_ type: BackupType) {
        if let index = currentlyBackuped.firstIndex(of: type.rawValue) {
            currentlyBackuped.remove(at: index)
        }
    }
    
    public func get() -> [BackupType] {
        return currentlyBackuped.map { return BackupType(rawValue: $0)! }
    }
    
    public func contain(_ type: BackupType) -> Bool {
        return currentlyBackuped.contains(type.rawValue)
    }
    
    public var isSecured: Bool {
        return currentlyBackuped.count == 3
    }
    //是否备份，助记词和私钥二选一
    public var isBackup:Bool{
        return currentlyBackuped.count >= 2
    }
    
    public var secureLevel: Int {
        return currentlyBackuped.count
    }
    
    public var isConfirmed: Bool {
        return !currentlyBackuped.isEmpty
    }
    
    public func clear() {
        currentlyBackuped = List<Int>()
    }
}

public enum BackupType: Int {
    case mnemonic
    case seed
    case keystore
}
