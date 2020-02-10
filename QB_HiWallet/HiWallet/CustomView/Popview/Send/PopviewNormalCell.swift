//
//  PopviewNormalCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import SnapKit
import UIKit

class PopviewNormalCell: UITableViewCell {
    private let _imageView = UIImageView()
    override var imageView: UIImageView? {
        return _imageView
    }

    private let _textLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = App.Color.cellTitle
    }

    override var textLabel: UILabel? {
        return _textLabel
    }

    private let _detailTextLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = App.Color.cellInfo
    }

    private let lineView = UIView()
    
    override var detailTextLabel: UILabel? {
        return _detailTextLabel
    }

    init(reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        layout()
    }

    private func setup() {
        lineView.backgroundColor = App.Color.lineColor
        addSubview(imageView!)
        addSubview(textLabel!)
        addSubview(detailTextLabel!)
        addSubview(lineView)
    }

    
    private func layout() {
        imageView?.snp.remakeConstraints {
            $0.left.equalTo(15)
            $0.width.equalTo(41)
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
        }

        textLabel?.snp.remakeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.left.equalTo(imageView!.snp.right).offset(10)
        }

        detailTextLabel?.snp.remakeConstraints {
            $0.top.equalTo(self.textLabel!.snp.bottom).offset(4)
            $0.left.equalTo(self.textLabel!.snp.left)
        }
        
        lineView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.right.equalTo(self.snp.right).offset(-20)
            $0.bottom.equalTo(0)
            $0.height.equalTo(0.5)
        }
    }
}
