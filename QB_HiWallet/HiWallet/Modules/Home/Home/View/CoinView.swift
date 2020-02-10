//
//  CoinView.swift
//  HiWallet
//
//  Created by Jax on 2020/1/8.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

class CoinView: UIView {
    @IBOutlet var numLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var bgImageView: UIImageView!

    var coinInfo: CoinInfo!

    class func create() -> CoinView {
        let coinView = Nib.load(name: "CoinView").view as! CoinView
        return coinView
    }

    public func setData(coinInfo: CoinInfo) {
        self.coinInfo = coinInfo
        numLabel.text = "\(coinInfo.amount)"
        symbolLabel.text = coinInfo.unit
        descLabel.text = coinInfo.type

        if !coinInfo.canReceive {
            bgImageView.alpha = 0.5
            numLabel.alpha = 0.5
            symbolLabel.alpha = 0.5
        } else {
            bgImageView.alpha = 1
            numLabel.alpha = 1
            symbolLabel.alpha = 1
        }
    }

    public func startAnimation() {
        let momAnimation = CABasicAnimation(keyPath: "position.y")
        momAnimation.fromValue = NSNumber(value: Double(y * 1.4))
        momAnimation.toValue = NSNumber(value: Double(y * 1.4 + 10))
        momAnimation.duration = 1
        momAnimation.repeatCount = HUGE //无限重复
        momAnimation.autoreverses = true //动画结束时执行逆动画
        momAnimation.isRemovedOnCompletion = false //切出此界面再回来动画不会停止
        momAnimation.fillMode = .forwards
        layer.add(momAnimation, forKey: "centerLayer")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
