//
//  RewardDetailCell.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/3.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class RewardDetailCell: BaseTableviewCell {
    var titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    var dateLabel = UILabel().then {
        $0.textColor = App.Color.createCard
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    var amountLabel = UILabel().then {
        $0.textColor = App.Color.mainColor
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(amountLabel)
    }
    
    override func layoutViews() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.height.equalTo(22)
            $0.bottom.equalTo(snp.centerY)
            $0.width.equalTo(snp.width).multipliedBy(0.6)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.left.equalTo(titleLabel.snp.left)
            $0.height.equalTo(18)
            $0.width.equalTo(titleLabel.snp.width)
        }
        
        amountLabel.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(snp.width).multipliedBy(0.3)
        }
    }
}
