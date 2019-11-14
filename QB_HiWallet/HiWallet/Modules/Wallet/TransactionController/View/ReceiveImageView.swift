//
//  ReceiveImageView.swift
//  HiWallet
//
//  Created by apple on 2019/6/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class ReceiveImageView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var walletIconview: UIImageView!
    @IBOutlet weak var walletName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRect(x: 0, y: 0, width: 375, height: 624)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipLabel.font = UIFont.systemFont(ofSize: 20)
    }

    class func loadImageView() -> ReceiveImageView {
        return  Bundle.main.loadNibNamed("ReceiveImageView", owner: nil, options: nil)?.first as! ReceiveImageView
    }
    
    func getImageFromView() ->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
        
    }
}
