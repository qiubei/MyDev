//
//  CurrencyRankDaemon.swift
//  TOP
//
//  Created by Jax on 10/5/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

fileprivate struct Defaults {
    static var queue = "CurrencyRank"
}

public class CurrencyRankDaemon: CurrencyRankDaemonInterface {
    var assets: [AssetInterface] = []
    private lazy var converterService = CurrencyConverterService()

    public init() {}

    public func update() {
        updateRanks()
    }

    public func update(callBack: @escaping () -> Void) {
        updateRanks(callBack: callBack)
    }

    private func updateRanks(callBack: (() -> Void)? = nil) {
        let user = TOPStore.shared.currentUser

        assets = user.wallet?.uniqueAssets ?? []
        let currency = user.profile?.currency ?? .cny // moren
        let group = DispatchGroup()
        group.notify(queue: .main, execute: {
            callBack?()
        })
        
        //TODO: enter 两次不够优雅。需要优化。（问题是 info 回调底层给了两次）
        assets.forEach { asset in
            group.enter()
            group.enter()
            self.converterService.getCoinInfo(from: asset, to: currency, info: { info in
                let yesterdayPrice = info.currentPrice + info.priceChange24h
                TOPStore.shared.ranks.setRank(for: currency, and: asset, rank: info.currentPrice, yesterdayPrice: yesterdayPrice)
                group.leave()
            })
        }
    }
}
