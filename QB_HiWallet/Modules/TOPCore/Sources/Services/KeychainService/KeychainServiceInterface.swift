//
//  KeychainServiceInterface.swift
//  TOPCore
//
//  Created by Jax on 4/15/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation

public protocol KeychainServiceInterface {
    func storePassword(userId: String, password: String, result: @escaping KeychainOperationUpdate)
    func getPassword(userId: String, result: @escaping KeychainOperationGet)
    func removePassword(userId: String, result: @escaping KeychainOperationUpdate)
}
