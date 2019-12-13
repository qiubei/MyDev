//
//  PopViewModelProvider.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/2.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import TOPCore

struct TxFeeLevel {
    typealias FeeType = (waitTime: String, amount: String, feeInCurrency: String)
    var fastest: FeeType
    var fast: FeeType
    var normal: FeeType
}

struct PopViewModelProvider {
    init() {}
    
    var from = SendPopViewModel(title: "发送账户".localized(), topDesc: "", bottomDesc: "")
    var to = SendPopViewModel(title: "发送到".localized(), topDesc: "", bottomDesc: "")
    var process = SendPopViewModel(title: "到账时间".localized(), topDesc: "", bottomDesc: "")
    var total = SendPopViewModel(title: "总计".localized(), topDesc: "", bottomDesc: "")
    var memo = SendPopViewModel(title: "备注tx".localized(), topDesc: "", bottomDesc: "")
    var fee: SendPopViewModel {
        var model = process
        model.title = "交易费".localized()
        return model
    }
    
    /// create a pop view data list with the info contain time and fee .
    /// - Parameter txLevel: A model data  contain tx fee info
    func createTxFeeList(txLevel: TxFeeLevel?) -> [NormalPopModel] {
        guard let txLevel = txLevel else { return [] }
        let fastestDesc = String(format: "预计 %@ 分钟内".localized(), txLevel.fastest.waitTime)
        let fastDesc = String(format: "预计 %@ 分钟内".localized(), txLevel.fast.waitTime)
        let normalDesc = String(format: "预计 %@ 分钟内".localized(), txLevel.normal.waitTime)
        
        return createPopDatalist(fastestTitle: fastestDesc,
                                 fastTitle: fastDesc,
                                 normalTitle: normalDesc,
                                 txLevel: txLevel)
    }
    
    /// create a pop view data list with the info contain level (3 level: express, fast, normal) and fee .
    /// - Parameter txLevel: A model data contain tx fee info
    func createTxLevelList(txLevel: TxFeeLevel?) -> [NormalPopModel] {
        guard let txLevel = txLevel else { return [] }
        return createPopDatalist(fastestTitle: "加速".localized(),
                                 fastTitle: "快速".localized(),
                                 normalTitle: "正常".localized(),
                                 txLevel: txLevel)
    }
    
    private func createPopDatalist(fastestTitle: String,
                                   fastTitle: String,
                                   normalTitle: String,
                                   txLevel: TxFeeLevel) -> [NormalPopModel] {
        let fastestFee = txLevel.fastest.feeInCurrency
        let fastFee = txLevel.fast.feeInCurrency
        let normalFee = txLevel.normal.feeInCurrency
        
        // 速度
        let fastImage = UIImage.init(named: "icon_tx_speed_fast")
        let fastSpeed = NormalPopModel(speedDesc: fastestTitle, Fee: fastestFee, image: fastImage)
        let fastImage2 = UIImage.init(named: "icon_tx_speed_normal")
        let fastSpeed2 = NormalPopModel(speedDesc: fastTitle, Fee: fastFee, image: fastImage2)
        let fastImage3 = UIImage.init(named: "icon_tx_speed_slow")
        let fastSpeed3 = NormalPopModel(speedDesc: normalTitle, Fee: normalFee, image: fastImage3)
        return [fastSpeed, fastSpeed2, fastSpeed3]
    }
}
