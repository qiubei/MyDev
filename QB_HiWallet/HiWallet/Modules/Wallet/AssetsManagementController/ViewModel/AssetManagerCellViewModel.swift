//
//  AssetViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/11/18.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

class AssetManagerCellViewModel {
    var isOn = false
    var symbol = ""
    var desc = ""
    var assetID = ""
    var dataModel: ServiceCoinModel?
    var isMainCoin: Bool
    var iconUrl: String = ""
    var chainType: String = ""

    var isShowStakingFlag: Bool {
        return (Preference.stakingSwitch ?? false) && assetID == TOPConstants.erc20TOP_AssetID
    }

    init(hotCoinModel: ServiceCoinModel) {
        isOn = false

        symbol = hotCoinModel.symbol
        desc = hotCoinModel.englishName
        dataModel = hotCoinModel.copy()
        isMainCoin = hotCoinModel.isMainChain
        iconUrl = hotCoinModel.iconUrl
        chainType = hotCoinModel.chainType
        if isMainCoin {
            assetID = hotCoinModel.chainType + hotCoinModel.symbol.uppercased()
        } else {
            assetID = hotCoinModel.chainType + hotCoinModel.symbol.uppercased() + dataModel!.contractAddress!.uppercased()
        }
    }

    init(hotCoinModel: ViewWalletInterface) {
        isOn = true
        assetID = hotCoinModel.asset.assetID
        symbol = hotCoinModel.symbol
        desc = hotCoinModel.fullName
        dataModel = nil
        isMainCoin = hotCoinModel.isMainCoin
        chainType = hotCoinModel.chainSymbol
        iconUrl = hotCoinModel.iconUrl
    }
}
