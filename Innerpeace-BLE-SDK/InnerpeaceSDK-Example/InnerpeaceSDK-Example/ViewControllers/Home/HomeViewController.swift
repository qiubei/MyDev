//
//  HomeViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import BLESDK
import CoreBluetooth

class HomeViewController: UIViewController {

    @IBAction func connect(_ sender: UIButton) {
        if Innerpeace.ble.state.isConnected {
            SVProgressHUD.showInfo(withStatus: lang("已经有设备连接"))
            return
        }
        SVProgressHUD.show(withStatus: lang("正在连接..."))
        try? Innerpeace.ble.findAndConnect(identifier: 1234) { isOK in
            if isOK {
                SVProgressHUD.showInfo(withStatus: lang("连接成功"))
            } else {
                SVProgressHUD.showInfo(withStatus: lang("连接成功"))
            }
        }
    }

    private let cManager = CBCentralManager()
    
    @IBAction func disconnect(_ sender: UIButton) {
        if let connector = Innerpeace.ble.connector, connector.peripheral.isConnected {
            cManager.cancelPeripheralConnection(connector.peripheral.peripheral)
            connector.cancel()
            Innerpeace.ble.disconnect()
        }
        SVProgressHUD.dismiss()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "deviceInfo" || identifier == "dfu" {
            if !Innerpeace.ble.state.isConnected {
                SVProgressHUD.showInfo(withStatus: lang("未检测到设备连接"))
                return false
            }
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.isHidden = false
    }
}
