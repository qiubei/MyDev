//
//  UIColor+Extension.swift
//  HiWallet
//
//  Created by apple on 2019/5/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex:String,alpha:CGFloat = 1.0){
        
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        let v = hexString.map { String($0) } + Array(repeating: "0", count: max(6 - hexString.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
        
        
        var hex: String {
            let components = cgColor.components!
            let red = Float(components[0])
            let green = Float(components[1])
            let blue = Float(components[2])
            
            return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        }
    }
    
    static func random() -> UIColor {
        let randomR = CGFloat(arc4random() % 255) / 255.0
        let randomG = CGFloat(arc4random() % 255) / 255.0
        let randomB = CGFloat(arc4random() % 255) / 255.0
        
        return UIColor(displayP3Red: randomR, green: randomG, blue: randomB, alpha: 1.0)
    }
}
