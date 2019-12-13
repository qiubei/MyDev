//
//  Tool+Ex.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit

public extension CryptoFormatter {
    static func balanceAttributeString(text: String, currencyFont: UIFont, amountFont: UIFont) -> NSAttributedString? {
        if text.first == nil { return nil }
        let currencyString = text.first!.description
        let amountString = text.dropFirst().description
        let attributeString = NSMutableAttributedString(string: currencyString, attributes: [NSAttributedString.Key.font: currencyFont])
        attributeString.append(NSAttributedString(string: amountString, attributes: [NSAttributedString.Key.font: amountFont]))
        
        return attributeString
    }
    
    static func attributeString(amount: String,
                                aAttributes: [NSAttributedString.Key : Any],
                                balance: String,
                                bAttributes: [NSAttributedString.Key : Any])-> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: amount, attributes: aAttributes)
        attributeString.append(NSAttributedString(string: " "))
        attributeString.append(NSAttributedString(string: balance, attributes: bAttributes))
        return attributeString
    }
    
    static func attributeString(amount: String,
                                balance: String,
                                aFontSize: CGFloat = 26,
                                aColor: UIColor = #colorLiteral(red: 0.06666666667, green: 0.0862745098, blue: 0.1294117647, alpha: 1),
                                bFontSize: CGFloat = 12,
                                bColor: UIColor = #colorLiteral(red: 0.4274509804, green: 0.4666666667, blue: 0.5411764706, alpha: 1))-> NSAttributedString {
        let aAttributes = [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: aFontSize)!,
                           NSAttributedString.Key.foregroundColor: aColor]
        let bAttributes = [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: bFontSize)!,
                           NSAttributedString.Key.foregroundColor: bColor]
        
        return attributeString(amount: amount,
                               aAttributes: aAttributes,
                               balance: balance,
                               bAttributes: bAttributes)
    }
}
