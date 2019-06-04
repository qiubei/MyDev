//
//  WearStateViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/22.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import BLESDK

class WearStateViewController: UIViewController {

    @IBOutlet weak var wearStateImageView: UIImageView!

    @IBAction func Close(_ sender: Any) {
        self.popAlertSheet()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.start()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleWear(notification:)), name: NotificationName.bleStateChanged.name, object: nil)
    }

    deinit {
        print("WearState ViewController deint")
    }

    /// 佩戴检查前需开启体验：脑波、脑波音乐、注意力、注意力谱曲中的任意一个即可
    private func start() {
        try? Innerpeace.start(algorithm: .nap)
//        try? Innerpeace.start(algorithm: .napMusic)
//        try? Innerpeace.start(algorithm: .concentration)
//        try? Innerpeace.start(algorithm: .concentrationMusic)
    }

    private func stop() {
        Innerpeace.end()
    }

    /// 佩戴检测通知监听
    ///
    /// - Parameter notification: 根据此变量获取底层传上来的状态变化。
    @objc private func handleWear(notification: Notification) {
        let info = notification.userInfo
        if let dic = info, let state = dic[NotificationKey.bleStateKey] as? BLEState {
            switch state {
            case let .connected(wearState):
                switch wearState {
                case .allWrong:
                    self.wearStateImageView.image = UIImage(named: "wear_all_wrong")
                case .activeWrong:
                    self.wearStateImageView.image = UIImage(named: "wear_not_well")
                case .normal:
                    self.wearStateImageView.image = UIImage(named: "wear_all_right")
                case .referenceWrong:
                    self.wearStateImageView.image = UIImage(named: "wear_not_well")
                }
            default:
                break
            }
        }
    }

    private func popAlertSheet() {
        let sheetController = UIAlertController(title: lang("佩戴检测,确定关闭？"), message: nil, preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: lang("确定"), style: .destructive) { [weak self](action) in
            self?.stop()
            self?.dismiss(animated: true, completion: {
                if let `self` = self {
                    NotificationCenter.default.removeObserver(self)
                }
            })
        }

        let cancelAction = UIAlertAction(title: lang("继续"), style: .cancel, handler: nil)
        sheetController.addAction(alertAction)
        sheetController.addAction(cancelAction)
        self.show(sheetController, sender: self)
    }
}
