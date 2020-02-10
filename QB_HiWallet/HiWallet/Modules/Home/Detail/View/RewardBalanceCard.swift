//
//  RewardBalanceCard.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/6.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit
import Then
import SnapKit

class RewardBalanceCard: BaseCard {
    let textlabel = UILabel().then {
        $0.textColor = UIColor.init(white: 1, alpha: 0.8)
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = "空投账户余额".localized()
    }
    
    let amountLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = UIFont(name: "DIN Alternate", size: 24)
    }
    
    let accumulateLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "累计空投".localized()
    }
    
    let accumulateAmountLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = UIFont(name: "DIN Alternate", size: 12)
    }
    
    let cashLabel = BaseLabel.init(frame: .zero).then {
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = UIColor.init(hex: "#DEDEDE")
        $0.textColor = UIColor.init(hex:"#B2B2B2")
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .center
        $0.text = "提现".localized()
        $0.cornerRadius = 16.5
    }
    
    let tipLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.text = "即将开放".localized()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        set(radius: 6, bgColors: App.Color.rewardDetailsBgColors)
        addSubview(textlabel)
        addSubview(amountLabel)
        addSubview(accumulateLabel)
        addSubview(accumulateAmountLabel)
        addSubview(cashLabel)
        addSubview(tipLabel)
    }
    
    private func layout() {
        textlabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.height.equalTo(20)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.bottom.equalTo(amountLabel.snp.top).offset(-10)
        }
        
        amountLabel.snp.makeConstraints {
            $0.left.equalTo(textlabel.snp.left).offset(-1)
            $0.height.equalTo(26)
            $0.right.equalTo(textlabel.snp.right)
            $0.bottom.equalTo(snp.centerY).offset(11)
        }
        
        accumulateLabel.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(16)
            $0.left.equalTo(textlabel.snp.left)
            $0.width.greaterThanOrEqualTo(50)
            $0.height.equalTo(16)
        }
        
        accumulateAmountLabel.snp.makeConstraints {
            $0.left.equalTo(accumulateLabel.snp.right).offset(6)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.centerY.equalTo(accumulateLabel.snp.centerY)
        }
        
        cashLabel.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.height.equalTo(33)
            $0.centerY.equalTo(amountLabel.snp.centerY)
            $0.width.greaterThanOrEqualTo(66)
        }
        
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(cashLabel.snp.bottom).offset(6)
            $0.height.equalTo(16)
            $0.centerX.equalTo(cashLabel.snp.centerX)
            $0.width.greaterThanOrEqualTo(41)
        }
    }
}
