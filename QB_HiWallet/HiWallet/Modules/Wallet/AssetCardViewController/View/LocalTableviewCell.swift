//
//  LocalTableviewCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class LocalTableviewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconView = UIImageView()
    let titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    
    private let disclosureView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_disclosure")
    }
    
    var rightView: UIView? {
        didSet {
            guard let view = rightView else {
                return
            }
            addSubview(view)
            view.snp.makeConstraints {
                $0.right.equalTo(disclosureView.snp.left).offset(-6)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(18)
                $0.width.greaterThanOrEqualTo(18)
            }
        }
    }
    
    private func setup() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(disclosureView)
    }
    
    private func layout() {
        iconView.snp.makeConstraints {
            $0.left.equalTo(26)
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.width.greaterThanOrEqualTo(64)
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        disclosureView.snp.makeConstraints {
            $0.right.equalTo(-22)
            $0.width.height.equalTo(14)
            $0.centerY.equalToSuperview()
        }
    }
}
