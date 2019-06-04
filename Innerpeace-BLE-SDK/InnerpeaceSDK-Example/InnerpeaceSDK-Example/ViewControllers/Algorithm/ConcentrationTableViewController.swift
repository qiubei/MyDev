//
//  ConcentrationTableViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/11.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import BLESDK
import BLESDK_Concentration

class ConcentrationTableViewController: BaseTableViewController {

    private let concentrationIterms = [lang("开始体验"), lang("原始数据监听"), lang("实时数据分析监听"), lang("眨眼信号监听")]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concentrationIterms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "concentration_cell", for: indexPath)
        cell.textLabel?.text = self.concentrationIterms[indexPath.row]
        cell.accessoryView = self.createAccessoryView(indexPath: indexPath)
        return cell
    }

    @objc
    override func update(sender: UISwitch) {
        switch (sender.tag % 100) {
        case 0:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: lang("开始体验"))
                self.start()
            } else {
                SVProgressHUD.showInfo(withStatus: lang("结束体验"))
                self.end()
            }
        case 1:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: lang("开启原始脑波监听"))
                self.startRawdataListen()
            } else {
                SVProgressHUD.showInfo(withStatus: lang("关闭原始脑波监听"))
                self.stopRawdataListen()
            }
        case 2:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: lang("开启实时数据处理监听"))
                self.startProcessingListen()
            } else {
                SVProgressHUD.showInfo(withStatus: lang("关闭实时数据处理监听"))
                self.stopProcessingListen()
            }
        case 3:
            if sender.isOn {
                SVProgressHUD.showInfo(withStatus: lang("开启眨眼信号监听"))
                self.startBlinkListen()
            } else {
                SVProgressHUD.showInfo(withStatus: lang("关闭眨眼信号监听"))
                self.stopBlinkListen()
            }
        default:
            print("default")
        }
    }

    /// override handle methods
    override func start() {
        do {
            try Innerpeace.start(algorithm: .concentration)
        } catch(let error) {
            SVProgressHUD.showError(withStatus: lang("开始体验异常:") + "\(error)")
        }
    }

    override func end() {
        Innerpeace.end()
    }

    override func startRawdataListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRawdataWith(notification:)), name: NotificationName.bleBrainwaveData.name, object: nil)
    }

    @objc private func handleRawdataWith(notification: Notification) {
        let info = notification.userInfo
        let rawdata = info?[NotificationKey.bleBrainwaveKey] as? Data
        if let data = rawdata {
            SVProgressHUD.showInfo(withStatus: "rawData: \(data.copiedBytes)")
        } else {
            SVProgressHUD.showError(withStatus: lang("数据异常"))
        }
    }

    override func stopRawdataListen() {
        NotificationCenter.default.removeObserver(self, name: NotificationName.bleBrainwaveData.name, object: nil)
    }

    override func startProcessingListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConcentrationProcessingWith(notification:)), name: NotificationName.concentrationData.name, object: nil)
    }

    @objc private func handleConcentrationProcessingWith(notification: Notification) {
        let info = notification.userInfo
        let processData = info?[NotificationKey.concentrationDataKey] as? ConcentrationData
        if let data = processData {
            SVProgressHUD.showInfo(withStatus: lang("实时注意力分析数据: \n") + "\(data)")
        } else {
            SVProgressHUD.showError(withStatus: lang("数据分析异常"))
        }
    }

    override func stopProcessingListen() {
        NotificationCenter.default.removeObserver(self, name:NotificationName.concentrationData.name, object: nil)
    }

    private func startBlinkListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleBlinkDataWith(notification:)), name: NotificationName.concentrationBlink.name, object: nil)
    }

    @objc private func handleBlinkDataWith(notification: Notification) {
        let info = notification.userInfo
        let blinkData = info?[NotificationKey.concentrationBlinkKey] as? Bool
        if let flag = blinkData, flag {
            SVProgressHUD.showInfo(withStatus: lang("检测到眨眼信号"))
            
        } else {
//            SVProgressHUD.showInfo(withStatus: lang("检测到眨眼信号"))
        }
    }

    private func stopBlinkListen() {
        NotificationCenter.default.removeObserver(self, name: NotificationName.concentrationBlink.name, object: nil)
    }
}
