//
//  HistoryTitleView.swift
//  HiWallet
//
//  Created by Jax on 2019/12/27.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class HistoryTitleView: UITableViewHeaderFooterView {
    private let label = UILabel()
    public var title: String? {
        didSet {
            label.text = title
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        addSubview(label)

        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(named: "#111622")!
        label.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */
}
