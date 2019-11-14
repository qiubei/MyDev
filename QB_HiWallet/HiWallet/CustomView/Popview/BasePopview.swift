//
//  BasePopview.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import SnapKit

class BasePopview: UIView {
    
    let rightButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
    }
    
    let leftButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "navigation_left_back"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.06666666667, green: 0.0862745098, blue: 0.1294117647, alpha: 1)
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
    }
    
    var contentView: UIView = UIView()
    
    var submitButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.5803921569, blue: 1, alpha: 1)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.titleLabel?.textColor = .white
        $0.cornerRadius = 25
        $0.setTitle("确认".localized(), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setup()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        layout()
    }
    
    func setup() {
        rightButton.isHidden = true
        leftButton.isHidden = true
        self.addSubview(rightButton)
        self.addSubview(leftButton)
        self.addSubview(titleLabel)
        self.addSubview(contentView)
        self.addSubview(submitButton)
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(rightButton.snp.centerY)
        }

        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.right.equalTo(-4)
            $0.top.equalTo(8)
        }
        
        leftButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.top.equalTo(rightButton.snp.top)
            $0.left.equalTo(4)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(rightButton.snp.bottom).offset(8)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(self.submitButton.snp.top).offset(-5)
        }
        
        submitButton.snp.makeConstraints {
            $0.left.equalTo(32)
            $0.right.equalTo(-32)
            $0.height.equalTo(50)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
    }
}
