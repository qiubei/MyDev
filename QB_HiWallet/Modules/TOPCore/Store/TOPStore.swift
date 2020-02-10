//
//  TOPStore.swift
//  TOP
//
//  Created by Jax on 23.08.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public class TOPStore: NSObject {
    public static var shared: TOPStore = TOPStore()
    public var currentUser: User = User()
    public var currentUserID: String = ""
    public var ranks: AssetRank = AssetRank()
    public var currentLangugale: LocalizationLanguage = .english

    public func setUser(_ user: User) {
        ranks = AssetRank()
        currentUser = user
        currentUserID = currentUser.userID
        currentLangugale = currentUser.profile?.language ?? .english
        CurrencyRankDaemon().update()
    }
}
