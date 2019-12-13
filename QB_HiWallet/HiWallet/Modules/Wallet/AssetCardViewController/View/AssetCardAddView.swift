//
//  AssetCardAddView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetCardAddView: UIView {
    private let iconImageview = UIImageView().then {
        $0.image = UIImage.init(named: "img_asset_add")
    }
    
    private let disclosureView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_asset_disclosure")
    }
    
    private let textLabel = UILabel().then {
        $0.textColor = App.Color.mainColor
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.numberOfLines = 0
        $0.text = "再开通一个工作专属的账户吧".localized()
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
        addSubview(iconImageview)
        addSubview(disclosureView)
        addSubview(textLabel)
    }
    
    private func layout() {
        iconImageview.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.left.equalToSuperview()
        }
        
        disclosureView.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageview.snp.right).offset(15)
            $0.right.equalTo(disclosureView.snp.left).offset(-9)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRadiusAndShadow(radius: 5, effect: 11)
    }
}
