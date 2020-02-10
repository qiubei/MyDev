//
//  AssetAddCard.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetAddCard: UIView {
    private let iconImageview = UIImageView().then {
        $0.image = UIImage.init(named: "icon_aseet_add")
    }
    
    private let textLabel = UILabel().then {
        $0.textColor = App.Color.createCard
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textLabel.text = "创建新的账户".localized()
        addSubview(iconImageview)
        addSubview(textLabel)
    }
    
    private func layout() {
        iconImageview.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.bottom.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageview.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow(radius: 10)
        setRadiusAndShadow(radius: 8, effect: 6)
    }
}
