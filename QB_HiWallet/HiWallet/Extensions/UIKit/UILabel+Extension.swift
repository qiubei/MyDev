//
//  UILabel+Ex.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/18.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 设置行间距和字体
    /// - Parameters:
    ///   - space: 行间距
    ///   - font: 字体大小
    func setLine(space: CGFloat, font: UIFont) {
        guard let txt = self.text else { return }
        let attributeString = NSMutableAttributedString(string: txt, attributes: [NSAttributedString.Key.font: font])
        let attributeStyle = NSMutableParagraphStyle()
        attributeStyle.lineSpacing = space
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: attributeStyle, range:NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
        self.sizeToFit()
    }
}
