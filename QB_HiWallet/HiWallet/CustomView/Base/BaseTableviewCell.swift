//
//  BaseTableviewCell.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/3.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class BaseTableviewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    func layoutViews() {
        
    }
}
