//
//  AccountPickerCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AccountPickerCell: UITableViewCell {
    var titleLabel = UILabel().then {
        $0.textColor = App.Color.cellTitle
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    var messageLabel = UILabel().then {
        $0.textColor = App.Color.cellInfo
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.lineBreakMode = .byTruncatingMiddle
    }
    
    var infoLabel = UILabel().then {
        $0.textColor = App.Color.cellInfo
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 8
    }
    
    var checkView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_check_account")
        $0.isHidden = true
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
        self.layout()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(infoLabel)
        addSubview(checkView)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview().offset(-10)
            $0.width.equalToSuperview().offset(0.5)
        }
        
        messageLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.height.equalTo(17)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        infoLabel.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.top.equalTo(titleLabel.snp.top)
            $0.height.equalTo(20)
            $0.width.equalToSuperview().offset(0.45)
        }
        
        checkView.snp.makeConstraints {
            $0.bottom.equalTo(messageLabel.snp.bottom)
            $0.right.equalTo(-22)
            $0.height.equalTo(8)
            $0.width.equalTo(12)
        }
    }
}
