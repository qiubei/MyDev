//
//  WalletMainHeaderView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/4.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class WalletMainHeaderView: UIView {
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var assetTypesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assetLabel.text = "总资产".localized()
        assetTypesLabel.text = "资产".localized()
    }
}

