//
//  AddressTableViewCell.swift
//  HiWallet
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var commonUsed: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonUsed.text = "常用".localized()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
