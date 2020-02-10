//
//  BaseLabel.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/9.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    private let textInsets: UIEdgeInsets
    
    init(frame: CGRect, textInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)) {
        self.textInsets = textInsets
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
