//
//  BackupSourceType.swift
//  TOPModel
//
//  Created by Jax on 3/1/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation

public enum BackupSourceType: Int {
    case app

    public var shouldCrateWalletsWhenCreate: Bool {
        return true
    }
}
