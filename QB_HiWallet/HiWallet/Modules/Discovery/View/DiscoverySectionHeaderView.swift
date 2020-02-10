//
//  DiscoverySectionHeaderView.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/21.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class DiscoverySectionHeaderView: UITableViewHeaderFooterView {
    let titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    let actionLabel = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.textColor = App.Color.createCard
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.text = "全部".localized()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(titleLabel)
        addSubview(actionLabel)
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.centerY.equalToSuperview()
        }
        
        actionLabel.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
