//
//  NumberView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class NumberView: UILabel {
    
    
//    private let numberLabel = UILabel().then {
//        $0.textColor = UIColor.white
//        $0.textAlignment = .center
//        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//    }
    
    let number: Int
    init(number: Int) {
        self.number = number
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
        layer.cornerRadius = 9
        layer.backgroundColor = App.Color.numberColor?.cgColor
        textColor = .white
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 12, weight: .medium)
        text = number > 99 ? " 99+ " : "\(number)"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func layout() {
//        addSubview(numberLabel)
//        numberLabel.snp.makeConstraints {
//            $0.width.greaterThanOrEqualTo(snp.height)
//            $0.height.equalToSuperview()
//            $0.center.equalToSuperview()
//        }
//    }
}
