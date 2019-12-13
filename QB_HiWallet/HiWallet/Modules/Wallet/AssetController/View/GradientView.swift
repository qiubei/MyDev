//
//  GradientView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/5.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.startPoint = CGPoint(x: 0, y: 0)
        self.layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.colors = colors
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.startPoint = CGPoint(x: 0, y: 0)
        self.layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.colors = colors
    }
    
    var colors =  [#colorLiteral(red: 0.3215686275, green: 0.4274509804, blue: 0.9803921569, alpha: 1).cgColor, #colorLiteral(red: 0.2196078431, green: 0.6588235294, blue: 1, alpha: 1).cgColor] {
        didSet {
            self.layer.colors = colors
        }
    }
    
    var showVertical = false {
        didSet {
            if showVertical {
                self.layer.startPoint = CGPoint(x: 0, y: 0)
                self.layer.endPoint = CGPoint(x: 0, y: 1)
            } else {
                self.layer.startPoint = CGPoint(x: 0, y: 0)
                self.layer.endPoint = CGPoint(x: 1, y: 0)
            }
        }
    }
    
    override final class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
}
