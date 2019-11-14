//
//  AssetSwitchCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetSwitchCell: UITableViewCell {
    var switchAction: ((_ open: Bool) -> Void)?
    @IBOutlet weak var iconimageView: UIImageView!
    @IBOutlet weak var chainImageview: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var assetSwitch: UISwitch!

    @IBAction func switchAction(_ sender: UISwitch) {
        if let callback = switchAction {
            callback(sender.isOn)
        }
    }

    let showStakingLabel = UILabel().then {
        $0.backgroundColor = UIColor.init(hex: "#EBF2FE")
        $0.textAlignment = .center
        $0.textColor = App.Color.mainColor
        $0.text = "节点投票".localized()
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.cornerRadius = 2
    }
    var showStakingFlag: Bool = false {
        didSet {
            if showStakingFlag {
                addSubview(showStakingLabel)
                showStakingLabel.snp.makeConstraints {
                    $0.left.equalTo(symbolLabel.snp.right).offset(10)
                    $0.centerY.equalTo(symbolLabel.snp.centerY)
                    $0.width.equalTo(60)
                    $0.height.equalTo(20)
                }
            } else {
                showStakingLabel.removeFromSuperview()
            }
        }
    }
}
