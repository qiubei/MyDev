//
//  AppConfig.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

class AppConfig {
    static let shared = AppConfig()

    func setUp() {
        getStakingSwitch()
    }

    // MARK: - 获取 staking 的 h5 入口是否显示的开关

    private func getStakingSwitch() {
        TOPNetworkManager<CommonServices, StakingSwitchModel>.requestModel(.getStakingSwitch, success: { model in
            Preference.stakingSwitch = model.open
        }) { _ in
            DLog("get staking failed!!")
        }
    }
}
