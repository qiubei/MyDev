//
//  AssetCard.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetCard: UIView {
    
    var copyActionBlock: EmptyAction?
    
    let nameLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    let addressLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingMiddle
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    let amountLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.font = UIFont(name: "DIN Alternate", size: 22)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let balanceLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    let copyImageView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_copy_white")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
        addEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(copyImageView)
        addSubview(amountLabel)
        addSubview(balanceLabel)
    }
    
    private func layout() {
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.greaterThanOrEqualTo(20)
            $0.bottom.equalTo(addressLabel.snp.top).offset(-6)
            $0.height.equalTo(22)
        }
        
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.left)
            $0.right.equalTo(copyImageView.snp.left).offset(-4)
            $0.height.equalTo(17)
            $0.width.equalTo(180)
            $0.bottom.equalTo(snp.centerY).multipliedBy(0.85)
        }
        
        copyImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.centerY.equalTo(addressLabel.snp.centerY)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(4)
            $0.left.equalTo(nameLabel.snp.left)
            $0.right.equalTo(-20)
            $0.height.equalTo(28)
        }
        
        balanceLabel.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(6)
            $0.left.equalTo(nameLabel.snp.left)
            $0.height.equalTo(18)
            $0.right.equalTo(-20)
        }
    }
    
    private func addEvent() {
        self.addressLabel.isUserInteractionEnabled = true
        self.addressLabel.bk_(whenTapped: {[weak self] in
            self?.copyActionBlock?()
        })
        self.copyImageView.isUserInteractionEnabled = true
        self.copyImageView.bk_(whenTapped: { [weak self] in
            self?.copyActionBlock?()
        })
    }
}

// 样式设置
extension AssetCard {
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadowAndcornerRadius()
    }
    
    private func setupShadowAndcornerRadius() {
        addBGGradient(radius: 10, colors: App.Color.eosColors)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 6
    }
    
    func setupWith(name: String,
                   address: String,
                   amount: String,
                   balance: String) {
        nameLabel.text = name
        addressLabel.text = address
        amountLabel.text = amount
        balanceLabel.text = balance
    }
}
