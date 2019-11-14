//
//  Preference.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static var hasTopVotedKey: DefaultsKey<Bool> {
        return .init("hasTopVotedKey", defaultValue: false)
    }
    static var stakingSwitchKey = DefaultsKey<Bool?>("stakingSwitchKey")
}

class Preference {
    static var hasTopVoted: Bool {
        get {
            return Defaults[.hasTopVotedKey]
        }

        set {
            Defaults[.hasTopVotedKey] = newValue
        }
    }
}

// app web config
extension Preference {
    static var stakingSwitch: Bool? {
        get {
            if Defaults.hasKey(.stakingSwitchKey) {
                return Defaults[.stakingSwitchKey]
            }

            return nil
        }

        set {
            if Defaults[.stakingSwitchKey] != newValue {
                Defaults[.stakingSwitchKey] = newValue
                NotificationCenter.default.post(name: Notification.Name.init(NotificationConst.stakingSwitchEvent), object: nil)
            }
        }
    }
}


extension App {
    static var isLogined = false
}
