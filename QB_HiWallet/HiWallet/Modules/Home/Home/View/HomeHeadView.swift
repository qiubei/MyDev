//
//  HomeHeadView.swift
//  HiWallet
//
//  Created by Jax on 2020/1/8.
//  Copyright © 2020 TOP. All rights reserved.
//

import Foundation
import TOPCore
import UIKit

protocol homeheadViewDelegate: NSObjectProtocol {
    func takeCoin(awardID: String)
    func loadNewCoin()
    func showHelp()
}

class HomeHeadView: UIView {
    @IBOutlet var cloudSmall: UIImageView!
    @IBOutlet var cloudBig: UIImageView!
    @IBOutlet var AirWing: UIImageView!

    @IBOutlet var balanceLalel: CountingLabel!
    @IBOutlet var SymbolLalel: UILabel!
    @IBOutlet var coinBgView: UIView!
    @IBOutlet var balanceBgView: UIView!
    @IBOutlet var helpImageView: UIImageView!

    var coinViewList: [CoinView] = []
    var oldCoinViewList: [CoinView] = [] //上次展示的位置
    var countNum = 0 //防止递归过多
    weak var delegate: homeheadViewDelegate?

    @IBAction func helpAction(_ sender: Any) {
        delegate?.showHelp()
    }

    func startAnimation() {
        let moveAnim = CABasicAnimation(keyPath: "position")
        moveAnim.fromValue = NSValue(cgPoint: CGPoint(x: screenWidth, y: navigationHeight + 50))
        moveAnim.toValue = NSValue(cgPoint: CGPoint(x: -cloudBig.width, y: navigationHeight + 50))
        moveAnim.duration = 30
        moveAnim.repeatCount = MAXFLOAT
        moveAnim.isCumulative = false
        moveAnim.isRemovedOnCompletion = false
        cloudBig.layer.add(moveAnim, forKey: "moveAnim")
//
        let moveAnim2 = CABasicAnimation(keyPath: "position")
        moveAnim2.fromValue = NSValue(cgPoint: CGPoint(x: screenWidth, y: navigationHeight + 120))
        moveAnim2.toValue = NSValue(cgPoint: CGPoint(x: -cloudSmall.width, y: navigationHeight + 120))
        moveAnim2.duration = 50
        moveAnim2.repeatCount = MAXFLOAT
        moveAnim2.isCumulative = false
        moveAnim2.isRemovedOnCompletion = false
        cloudSmall.layer.add(moveAnim2, forKey: "moveAnim2")
//
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 10
        rotationAnim.autoreverses = false
        rotationAnim.isRemovedOnCompletion = false
        AirWing.layer.add(rotationAnim, forKey: nil)
    }

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        guard coinViewList.count > 0 else {
            return
        }
        let poin = sender.location(in: coinBgView)

        for index in 0 ... coinViewList.count - 1 {
            let view = coinViewList[index]
            if (view.layer.presentation()?.hitTest(poin)) != nil {
                takeCoin(view: view, index: index)
                break
            }
        }
    }

    //收取金币
    func takeCoin(view: CoinView, index: Int) {
        if !view.coinInfo.canReceive {
            return
        }
        delegate?.takeCoin(awardID: view.coinInfo.rewardId)
        UserManager.shared.uploadAward(awardID: view.coinInfo.rewardId)

        coinViewList.remove(at: index)

        let move = CABasicAnimation(keyPath: "position")
        move.toValue = NSValue(cgPoint: CGPoint(x: screenWidth, y: 10))
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = NSNumber(value: 0.3)

        let group = CAAnimationGroup()
        group.duration = 1
        group.repeatCount = 1
        group.animations = [move, scale]
        view.layer.add(group, forKey: "delete")

        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            view.alpha = 0
        }) { _ in

            let value = (Double(self.balanceLalel.text!) ?? 0) + (Double(view.coinInfo.amount) ?? 0)
            self.balanceLalel.animate(fromValue: Double(self.balanceLalel.text!) ?? 0, toValue: value, duration: 0.5)
            view.removeFromSuperview()

            //6个全部领取
            if self.coinViewList.isEmpty {
                self.delegate?.loadNewCoin()
            }
        }
    }

    func stopAnimation() {
    }

    func clearData() {
        balanceLalel.text = "0.00"
        for view in coinViewList {
            view.removeFromSuperview()
        }
        coinViewList.removeAll()
    }

    func reloadCoin(coinInfoList: [CoinInfo]) {
        for view in coinViewList {
            view.removeFromSuperview()
        }
        coinViewList.removeAll()

        for coinInfo in coinInfoList {
            for view in oldCoinViewList {
                if view.coinInfo.rewardId == coinInfo.rewardId {
                    view.setData(coinInfo: coinInfo)
                    coinBgView.addSubview(view)
                    view.startAnimation()
                    coinViewList.append(view)
                }
            }
        }

        for coinInfo in coinInfoList {
            var found = false
            for view in oldCoinViewList {
                if view.coinInfo.rewardId == coinInfo.rewardId {
            
                    found = true
                }
            }

            if !found {
                let coinView = CoinView.create()
                if let posion = getNewPosion() {
                    coinView.center = posion
                    coinView.setData(coinInfo: coinInfo)
                    coinBgView.addSubview(coinView)
                    coinView.startAnimation()
                    coinViewList.append(coinView)
                }
            }
        }
        oldCoinViewList.removeAll()

        for view in coinViewList {
            oldCoinViewList.append(view)
        }
    }

    func getNewPosion() -> CGPoint? {
        countNum += 1

        if countNum > 2000 {
            DLog("算不出来啦")
            return nil
        }

        let x = Float.randomFloatNumber(lower: 25, upper: coinBgView.width - 25)
        let y = Float.randomFloatNumber(lower: 70, upper: coinBgView.height - 70)

        for view in coinViewList {
            if sqrt(pow(view.centerX - x, 2) + pow(view.centerY - y, 2)) < 70 * App.widthRatio {
                return getNewPosion()
            }
        }

        return CGPoint(x: x, y: y)
    }
}

extension Float {
    public static func randomFloatNumber(lower: CGFloat = 0, upper: CGFloat = 100) -> CGFloat {
        return (CGFloat(arc4random()) / CGFloat(UInt32.max)) * (upper - lower) + lower
    }
}
