//
//  TransactionDetailCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import SnapKit

class TransactionDetailCell: UITableViewCell {
    
    init(reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        layout()
    }
    
    private func setup() {
        self.textLabel?.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        self.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.detailTextLabel?.textColor = .black
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.detailTextLabel?.numberOfLines = 0
        self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func layout() {
        textLabel?.snp.updateConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
        }
    }
}
