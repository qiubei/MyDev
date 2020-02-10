//
//  UserBackup.swift
//  TOP
//
//  Created by Jax on 06.09.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class UserBackup: Object {
    dynamic public var currentlyBackup: CurrentlyBackup? = CurrentlyBackup()
    dynamic public var keystorePath: String?
}
