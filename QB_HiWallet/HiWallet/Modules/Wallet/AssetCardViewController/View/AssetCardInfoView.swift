//
//  AssetCardInfoView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

private let cardRatio: CGFloat = 170.0/343
private let cardWidth: CGFloat = screenWidth - 32

class AssetCardInfoView: UIView {
    let card: AssetCard = AssetCard(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardWidth * cardRatio))
    let tableview = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableview.backgroundColor = .white
        tableview.separatorStyle = .none
    }
    
    func setup() {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: card.bounds.height + 20))
        headerview.addSubview(card)
        headerview.backgroundColor = .clear
        card.center = headerview.center
        tableview.tableHeaderView = headerview
        addSubview(tableview)
    }
    
    func layout() {
        tableview.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension AssetCardInfoView {
    func setupCard(name: String,
                   address: String,
                   amount: String,
                   balance: String) {
        card.nameLabel.text = name
        card.addressLabel.text = address
        card.amountLabel.text = amount
        card.balanceLabel.text = balance
    }
}
