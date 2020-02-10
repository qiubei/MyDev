//
//  NotificationInfoCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class NotificationInfoCell: UITableViewCell {
    
    var haveRead = false {
        didSet {
            if haveRead {
                redDotView.isHidden = true
            } else {
                redDotView.isHidden = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    let infoLabel = UILabel().then {
        $0.textColor = App.Color.createCard
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    let disclosureView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_disclosure_light")
        $0.contentMode = .scaleAspectFit
    }
    
    let redDotView = UIView().then {
        $0.backgroundColor = .red
        $0.cornerRadius = 3
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(infoLabel)
        addSubview(disclosureView)
        addSubview(redDotView)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.bottom.equalTo(snp.centerY)
            $0.width.equalTo(snp.width).multipliedBy(0.6)
            $0.height.equalTo(22)
        }
        
        dateLabel.snp.makeConstraints {
            $0.right.equalTo(-38)
            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.width.greaterThanOrEqualTo(72)
            $0.height.equalTo(18)
        }
        
        infoLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.width.equalTo(snp.width).multipliedBy(0.8)
            $0.height.equalTo(16)
        }
        
        disclosureView.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.right.equalTo(-18)
            $0.centerY.equalToSuperview()
        }
        
        redDotView.snp.makeConstraints {
            $0.width.height.equalTo(6)
            $0.centerY.equalTo(dateLabel.snp.centerY).offset(-10)
            $0.right.equalTo(-15)
        }
    }
}
