//
//  AppHandler.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import TOPCore

class AppHandler {
    static let shared = AppHandler()

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
    
    private var isUpdateChecked = false
    private var showNoneAlert = false
    func checkAppUpdate(_ sender: UIViewController) {
        if isUpdateChecked { return }
        
        TOPNetworkManager<CommonServices, UpdateModel>.requestModel(.checkAppUpdate, success: { model in
            
            if model.hasUpdate == "0" {
                if !self.showNoneAlert { return }
                let alert = UIAlertController(title: "暂无新版本!".localized(), message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "确认".localized(), style: .cancel, handler: nil)
                alert.addAction(cancel)
                sender.present(alert, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "有新版本!".localized(), message: model.description, preferredStyle: .alert)
            let action = UIAlertAction(title: "去更新".localized(), style: .default, handler: { _ in
                WebMannager.showInSafariWithUrl(url: model.downloadUrl!, controller: sender)
                self.isUpdateChecked = (model.isForcedUpdates == 0)
                
            })
            let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in
                self.isUpdateChecked = (model.isForcedUpdates == 0)
                
            })
            alert.addAction(action)
            if model.isForcedUpdates == 0 {
                alert.addAction(cancal)
            }
            sender.present(alert, animated: true, completion: nil)
        }, failure: nil)
    }
    
    func checkAppUpdateAlways(_ sender: UIViewController) {
        isUpdateChecked = false
        showNoneAlert = true
        checkAppUpdate(sender)
    }
}
