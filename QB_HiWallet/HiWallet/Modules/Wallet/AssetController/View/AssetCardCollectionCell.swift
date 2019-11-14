//
//  AssetCardCollectionCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/2.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import SnapKit
import TOPCore

class AssetCardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var coinNumLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var flashImageview: UIImageView!
    @IBOutlet weak var cardNumimageView: UIImageView!
    @IBOutlet weak var managerButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!

    var colors: [CGColor] = [ #colorLiteral(red: 0.6352941176, green: 0.5215686275, blue: 0.1921568627, alpha: 1).cgColor, #colorLiteral(red: 0.7764705882, green: 0.6901960784, blue: 0.2392156863, alpha: 1).cgColor] {
        didSet {
            addGridientColors() 
        }
    }
    
    private var isAddGradientLayer = false
    private let gradientLayer = CAGradientLayer()
    private func addGridientColors() {
        if isAddGradientLayer {
            gradientLayer.colors = colors
            return
        }
        isAddGradientLayer = true
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        backgroundColor = .clear
        
        contentView.cornerRadius = 10
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.16
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        sendButton.setTitle("发送".localized(), for: .normal)
        receiveButton.setTitle("接收".localized(), for: .normal)
    }
}

extension AssetCardCollectionCell {
    func setupWith(wallet: ViewWalletInterface, index: Int) {
        self.assetNameLabel.text = wallet.name
        self.addressLabel.text = wallet.address
        self.cardNumimageView.image = { () -> UIImage in
            switch index {
            case 0:
                return #imageLiteral(resourceName: "img_asset_num_1")
            case 1:
                return #imageLiteral(resourceName: "img_asset_num_2")
            case 2:
                return #imageLiteral(resourceName: "img_asset_num_3")
            default:
                return #imageLiteral(resourceName: "img_asset_num_1")
            }
        }()
        self.coinNumLabel.text = wallet.formattedBalance
        
        let aAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 24)!,
                           NSAttributedString.Key.foregroundColor: UIColor.white]
        let bAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 12)!,
        NSAttributedString.Key.foregroundColor: UIColor.white]
        let balanceString = "≈ " +  wallet.formattedBalanceInCurrentCurrencyWithSymbol
        self.coinNumLabel.attributedText = CryptoFormatter.attributeString(amount: wallet.formattedBalance,
                                                                           aAttributes: aAttributes, balance: balanceString, bAttributes: bAttributes)

    }
}
