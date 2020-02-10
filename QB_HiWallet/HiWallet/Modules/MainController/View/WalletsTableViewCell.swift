//
//  WalletsTableViewCell.swift
//  HiWallet
//
//  Created by apple on 2019/6/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class WalletsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var noteName: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var fatherImageView: UIImageView!  //父类图标
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
