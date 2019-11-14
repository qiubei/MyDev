//
//  UserStorageInterface.swift
//  EssStore
//
//  Created by Jax on 1/22/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation


public protocol UserStorageServiceInterface {
    func update(_ updateBlock: @escaping (User) -> Void)
//    func get(_ user: @escaping (User) -> Void)
    func remove(userID:String)
}
