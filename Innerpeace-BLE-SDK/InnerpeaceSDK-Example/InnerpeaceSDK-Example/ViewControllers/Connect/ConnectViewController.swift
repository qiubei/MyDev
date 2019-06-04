//
//  ConnectViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/8.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import BLESDK
import SVProgressHUD
import Files

class ConnectViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var currentTipLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBAction func nextAction(_ sender: UIButton) {
        if !Innerpeace.ble.state.isConnected {
            self.findDevice()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateImageWithState(notification:)), name: NotificationName.bleStateChanged.name, object: nil)
        self.findDevice()
        self.helpButton.setTitle(lang("无法连接设备？"), for: .normal)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        Innerpeace.ble.disconnect()
    }

    private func findDevice() {
//        self.currentTipLabel.text = "正在搜索设备..."
        try? Innerpeace.ble.findAndConnect(identifier: 1234) { (isOK) in
            if isOK {
                self.button.isHidden = false
                self.currentTipLabel.text = lang("连接成功，开始使用吧！")
                self.button.setTitle(lang("一切就绪，开始使用！"), for: .normal)
                self.imageview.image = UIImage(named: "img_connect_succeeded")
                print(lang("连接成功"))
            }
        }
    }

    @objc private func updateImageWithState(notification: Notification) {
        let info = notification.userInfo
        let stateData = info?[NotificationKey.bleStateKey] as? BLEState
        if let state = stateData {
            print(state)
            switch state {
            case .searching:
                self.button.isHidden = true
                self.helpButton.isHidden = true
                self.currentTipLabel.text = lang("正在搜索设备...")
                self.detailLabel.text = lang("请确保设备在手机附近。")
                self.imageview.image = UIImage(named: "img_connect_near_it")
            case .connecting:
                self.currentTipLabel.text = lang("已找到设备，正在连接...")
                self.detailLabel.text = lang("请确保设备在手机附近。")
            case .connected:
                self.currentTipLabel.text = lang("连接成功，开始使用吧！")
                self.detailLabel.text = lang("了解基本信息，从而更好地使用设备。")
            case .disconnected:
                self.button.isHidden = false
                self.helpButton.isHidden = false
                self.currentTipLabel.text = lang("连接失败，请重新尝试。")
                self.detailLabel.text = lang("请确保设备在手机附近。")
                self.button.setTitle(lang("重新连接设备"), for: .normal)
                self.imageview.image = UIImage(named: "img_connect_failed")
            }
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "connect_help_id" {
            return true
        }
        if Innerpeace.ble.state.isConnected {
            return true
        }
        return false
    }
}

