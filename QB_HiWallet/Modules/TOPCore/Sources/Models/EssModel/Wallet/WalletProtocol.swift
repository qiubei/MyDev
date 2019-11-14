//
//  WalletInterface.swift
//  TOP
//
//  Created by Jax on 17.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public protocol WalletProtocol {
    
    var accountIndex: Int32 { get }
    var address: String { get }
    var privateKey: String { get }
    var asset: AssetInterface { get }
    var name: String { get set }
    var createTime: Double { get }
    var fullName: String { get }

}