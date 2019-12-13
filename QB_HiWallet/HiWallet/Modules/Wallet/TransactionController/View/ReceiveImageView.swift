//
//  ReceiveImageView.swift
//  HiWallet
//
//  Created by apple on 2019/6/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class ReceiveImageView: GradientView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var walletIconview: UIImageView!
    @IBOutlet weak var walletName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var topConstrains: NSLayoutConstraint!
    @IBOutlet weak var middleConstrains: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = UIScreen.main.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipButton.setTitle("打开 Hiwallet 扫一扫".localized(), for: .normal)
        showVertical = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let offSetHeight = UIScreen.main.bounds.height - 450
        topConstrains.constant = 10/25 * offSetHeight
        middleConstrains.constant = 3/25 * offSetHeight
        bottomConstrain.constant = 2/25 * offSetHeight
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
