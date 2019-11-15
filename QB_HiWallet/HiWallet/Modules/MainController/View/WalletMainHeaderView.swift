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
    @IBOutlet var eyeButton: UIButton!
    
    @IBOutlet var stakingRouteView: UIView!
    @IBOutlet var stakingTopInfoLabel: UILabel!
    @IBOutlet var stakingTopIncomeLabel: UILabel!
    @IBOutlet var stakingHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assetLabel.text = "总资产".localized()
        assetTypesLabel.text = "资产".localized()
        
        stakingTopInfoLabel.text = "为 Top Network 节点投票，赚取高额收益".localized()
        stakingTopIncomeLabel.text = "赚收益".localized()
    }
}

