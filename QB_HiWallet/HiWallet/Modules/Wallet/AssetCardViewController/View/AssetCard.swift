//
//  AssetCard.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetCard: UIView {
    
    var colors: [CGColor] = App.Color.eosColors {
        didSet {
            setupShadowAndcornerRadius(colors: colors)
        }
    }
    var copyActionBlock: EmptyAction?
    
    let nameLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    let addressLabel = UILabel().then {
        $0.textColor = UIColor.init(white: 1.0, alpha: 0.9)
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingMiddle
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    let amountLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.font = UIFont(name: "DIN Alternate", size: 24)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let balanceLabel = UILabel().then {
        $0.textColor = UIColor.init(white: 1.0, alpha: 0.9)
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    let copyImageView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_copy_white")
        $0.contentMode = .center
    }
    
    let bgIconview = UIImageView().then {
        $0.contentMode = .scaleAspectFit
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
    
    private let iconView = UIView()
    private func setup() {
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(copyImageView)
        addSubview(amountLabel)
        addSubview(balanceLabel)
        addSubview(iconView)
        iconView.addSubview(bgIconview)
        iconView.cornerRadius = 10
        iconView.clipsToBounds = true
        copyImageView.isHidden = true
    }
    
    private func layout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(20 * App.heightRatio)
            $0.left.equalTo(20)
            $0.right.greaterThanOrEqualTo(20)
            $0.bottom.equalTo(addressLabel.snp.top).offset(-8 * App.heightRatio)
            $0.height.equalTo(22)
        }
        
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.left)
            $0.right.equalTo(copyImageView.snp.left).offset(8)
            $0.height.equalTo(17)
            $0.width.equalTo(180)
        }
        
        copyImageView.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.centerY.equalTo(addressLabel.snp.centerY)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(20 * App.heightRatio)
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
        
        iconView.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(84)
            $0.right.bottom.equalToSuperview()
        }
        
        bgIconview.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(100)
        }
        
        iconView.backgroundColor = .clear
        iconView.clipsToBounds = true
    }
    
    private func addEvent() {
        self.addressLabel.bk_(whenTapped: {[weak self] in
            self?.copyActionBlock?()
        })
        self.copyImageView.bk_(whenTapped: { [weak self] in
            self?.copyActionBlock?()
        })
    }
}

// 样式设置
extension AssetCard {
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadowAndcornerRadius(colors: colors)
    }
    
    private func setupShadowAndcornerRadius(colors: [CGColor]) {
        addBGGradient(radius: 10, colors: colors)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
    }
    
    func setupWith(name: String,
                   address: String,
                   amount: String,
                   balance: String,
                   iconImage: UIImage) {
        nameLabel.text = name
        addressLabel.text = address
        amountLabel.text = amount
        balanceLabel.text = balance
        bgIconview.image = iconImage
    }
    
    func enableCopyAction(_ enable: Bool) {
        copyImageView.isHidden = !enable
        addressLabel.isUserInteractionEnabled = enable
        copyImageView.isUserInteractionEnabled = enable
    }
}
