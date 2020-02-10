//
//  NotificationView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        layout()
    }
    
    let imageView = UIImageView().then {
        $0.image = UIImage.init(named: "icon_notification_white")
        $0.contentMode = .scaleAspectFit
    }
    
    let numberView = NumberView(frame: .zero)
    
    private func setup() {
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(numberView)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(snp.width).multipliedBy(0.6)
        }
        
        numberView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(-bounds.width * 0.15)
            $0.width.greaterThanOrEqualTo(18)
            $0.height.equalTo(18)
        }
    }
}
