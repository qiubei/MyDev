//
//  PopViewSendCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import SnapKit
import UIKit

class PopViewSendCell: UITableViewCell {
    var titleLabel = UILabel().then {
        $0.textColor = App.Color.title
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }

    var infoLabel: UILabel = UILabel().then {
        $0.textColor = App.Color.cellTitle
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.lineBreakMode = .byTruncatingMiddle
    }

    var messageLabel: UILabel = UILabel().then {
        $0.textColor = App.Color.cellInfo
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .right
        $0.lineBreakMode = .byTruncatingMiddle
    }

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        layout()
    }

    let lineView = UIView()
    private func setup() {
        addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(lineView)
    }

    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(26)
            $0.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(40)
            if self.accessoryType != .none {
                $0.right.equalTo(0)
            } else {
                $0.right.equalTo(-20)
            }
            $0.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let text = messageLabel.text, text.count > 0 {
            infoLabel.snp.remakeConstraints {
                $0.left.equalTo(titleLabel.snp.right).offset(80)
                $0.centerY.equalToSuperview().offset(-10)
                if self.accessoryType != .none {
                    $0.right.equalTo(-4)
                } else {
                    $0.right.equalTo(-20)
                }
            }
            
            messageLabel.snp.remakeConstraints {
                $0.left.equalTo(titleLabel.snp.right).offset(80)
                $0.top.equalTo(infoLabel.snp.bottom).offset(4)
                $0.right.equalTo(infoLabel.snp.right)
            }
        }
    }
}
