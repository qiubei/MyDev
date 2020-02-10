//
//  ToastView.swift
//  HiWallet
//
//  Created by Jax on 2019/9/18.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit

 enum ColorStyle {
     case white
     case main
 }


class ToastView {

    class func showMessage(message: String, style: ColorStyle = .main) {
        
        let showView = UIView()
        showView.isUserInteractionEnabled = false
        showView.backgroundColor = style == .main ? UIColor.init(named: "#369BFF") : UIColor.white
        showView.alpha = 0
        showView.cornerRadius = 5
        UIApplication.shared.keyWindow?.addSubview(showView)

        showView.frame = CGRect(x: 0, y: -navigationHeight, width: screenWidth, height: navigationHeight)

        let label = UILabel(frame: CGRect(x: 0, y: statusHeight, width: screenWidth, height: 44))
        showView.addSubview(label)
        label.text = message
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = style == .main ? UIColor.white : UIColor.black

        UIView.animate(withDuration: 0.5, animations: {
            showView.y = 0
            showView.alpha = 1
        }) { _ in
            
            UIView.animate(withDuration: 0.5, delay: 1, options: .transitionFlipFromTop, animations: {
                
                showView.y = -navigationHeight
                showView.alpha = 0
                
            }) { _ in
              
                showView.removeFromSuperview()
            }
        }
    }
}
