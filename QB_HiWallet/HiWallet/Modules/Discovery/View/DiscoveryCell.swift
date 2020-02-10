//
//  DiscoveryCell.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/21.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class DiscoveryCell: BaseTableviewCell {
    var showLine = false {
        didSet {
            lineView.isHidden = !showLine
        }
    }
    
    let iconView = UIImageView().then {
        $0.cornerRadius = 10
    }
    let titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    let infoLabel = UILabel().then {
        $0.textColor = App.Color.createCard
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = UIColor.init(hex: "#E1E1E1")
    }
    
    override func setupViews() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(lineView)
        lineView.isHidden = !showLine
    }
    
    override func layoutViews() {
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(52)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(16)
            $0.right.equalTo(-16)
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview().offset(-12)
        }
        
        infoLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.height.equalTo(18)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.bottom.equalToSuperview()
        }
    }
}
