//
//  UIButton+Extension.swift
//  HiWallet
//
//  Created by apple on 2019/6/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

 extension UIButton{
    
    
    
    @IBInspectable var underline: Bool {
        set {
            
            guard let text = self.titleLabel?.text else { return }
            
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
            
            self.setAttributedTitle(attributedString, for: .normal)
        
        }
        get {
          return false
        }
    }
    
}
