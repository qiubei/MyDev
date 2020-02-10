//
//  BannerCell.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/22.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
    let imageview = UIImageView().then {
        $0.contentMode = .scaleToFill
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
        addSubview(imageview)
    }
    
    private func layout() {
        imageview.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
}
