//
//  DIStorageInterface.swift
//  TOP
//
//  Created by Jax on 16.07.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

protocol StorageInterface {
    func add(object: RegisteredObject, key: String)
    func object(key: String) -> RegisteredObject?
    func remove(key: String)
    func all() -> [RegisteredObject]
}
