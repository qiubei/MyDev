//
//  WebSharedViewCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/8.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class WebSharedViewCell: UITableViewCell {
    
   static let identifier = "top.cell.identifier.shared"
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    let accessoryImageview = UIImageView()
    let lineView = UIView()
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.remakeConstraints {
            $0.left.equalTo(28)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(accessoryImageview)
        accessoryImageview.snp.makeConstraints {
            $0.right.equalTo(-30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        addSubview(lineView)
        lineView.backgroundColor = App.Color.lineColor
        lineView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
