//
//  NumberView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/12.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class NumberView: UILabel {
    
    var number: Int = 0 {
        didSet {
            if number == 0 {
                isHidden = true
            } else {
                isHidden = false
                text = number > 99 ? "99+" : "\(number)"
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    let textInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
