//
//  SegmentItem.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class SegmentItem: UIView {
    
    var isSelected = false {
        didSet {
            if isSelected {
                titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    let titleLabel = BaseLabel.init(frame: .zero, textInsets: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)).then {
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15)
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
        addSubview(titleLabel)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.right.equalTo(0)
        }
    }
}
