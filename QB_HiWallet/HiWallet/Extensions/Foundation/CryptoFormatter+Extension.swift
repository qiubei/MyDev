//
//  Tool+Ex.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import Foundation
import UIKit

extension CryptoFormatter {
    static func attributeString(amount: String,  balance: String)-> NSAttributedString {
        let color = #colorLiteral(red: 0.06666666667, green: 0.0862745098, blue: 0.1294117647, alpha: 1)
        let attributeString = NSMutableAttributedString(string: amount, attributes: [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 26)!, NSAttributedString.Key.foregroundColor: color])
        let balanceColor = #colorLiteral(red: 0.4274509804, green: 0.4666666667, blue: 0.5411764706, alpha: 1)
        attributeString.append(NSAttributedString(string: " "))
        attributeString.append(NSAttributedString(string: balance, attributes: [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 12)!, NSAttributedString.Key.foregroundColor: balanceColor]))
        
        return attributeString
    }
    
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
}
