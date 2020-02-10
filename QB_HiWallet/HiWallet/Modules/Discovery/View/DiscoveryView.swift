//
//  DiscoveryView.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/21.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class DiscoveryView: UIView {
    var images: [UIImage] = [] {
        didSet {
            bannerView.images = images
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableview = UITableView(frame: .zero, style: .grouped)
    let bannerView = BannerView(frame: .zero).then {
        $0.cornerRadius = 5
    }
    func setup() {
        let headerview = UIView.init(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: screenWidth,
                                                   height: 144.0 * screenWidth / 343 + 32))
        headerview.addSubview(bannerView)
        bannerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(screenWidth - 32)
            $0.height.equalTo(bannerView.snp.width).multipliedBy(144.0/343)
        }
        tableview.tableHeaderView = headerview
        tableview.tableFooterView = UIView()
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor.white
        addSubview(tableview)
    }
    
    func layout() {
        tableview.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
    }
}
