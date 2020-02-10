//
//  UIImage+Extension.swift
//  HiWallet
//
//  Created by Jax on 2019/11/5.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

extension UIImage {
    
   class func getChainImageWithChainSymbol(chainSymbol: String) -> UIImage {
        return UIImage(named: chainSymbol.uppercased() + "_icon") ?? UIImage()
    }
}
