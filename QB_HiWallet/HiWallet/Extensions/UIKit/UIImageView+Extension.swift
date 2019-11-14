//
//  UIImageView+Extention.swift
//  HiWallet
//
//  Created by Jax on 2019/10/25.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import SDWebImage
import TOPCore
import UIKit

extension UIImageView {
    
    func setIconWithCoinModel(model: ServiceCoinModel) {
        if model.isMainChain {
            image = getChainImageWithSymbol(chainSymbol: model.symbol)
        } else {
            sd_setImage(with: URL(string: model.iconUrl), completed: nil)
        }
    }

    func setIconWithWallet(model: ViewWalletInterface) {
        if model.isMainCoin {
            image = getChainImageWithSymbol(chainSymbol: model.symbol)
        } else {
            sd_setImage(with: URL(string: model.iconUrl), completed: nil)
        }
    }

    func setChainIconWithWallet(model: ViewWalletInterface) {
        if model.isMainCoin {
            image = getChainImageWithSymbol(chainSymbol: model.symbol)
        } else {
            image = getChainImageWithSymbol(chainSymbol: model.chainSymbol)
        }
    }

    func setChainIconWithCoinModel(model: ServiceCoinModel) {
        image = getChainImageWithSymbol(chainSymbol: model.chainType)
    }

    private func getChainImageWithSymbol(chainSymbol: String) -> UIImage {
        return UIImage.getChainImageWithChainSymbol(chainSymbol:chainSymbol)
    }
}
