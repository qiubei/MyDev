//
//  BrainMusicTableViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/11.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import BLESDK
import BLESDK_NapMusic

class NapMusicTableviewController: BaseTableViewController {

    private let napMusicIterms = [lang("开始体验"), lang("实时脑波分析监听")]

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return napMusicIterms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nap_cell", for: indexPath)

        cell.textLabel?.text = self.napMusicIterms[indexPath.row]
        cell.accessoryView = self.createAccessoryView(indexPath: indexPath)
        return cell
    }

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
                self.startProcessingListen()
            } else {
                SVProgressHUD.showInfo(withStatus: lang("关闭原始脑波监听"))
                self.stopProcessingListen()
            }
        default:
            break
        }
    }

    override func start() {
        do {
            try Innerpeace.start(algorithm: .napMusic)
        } catch(let error) {
            SVProgressHUD.showInfo(withStatus: lang("开始体验异") + " \(error)")
        }
    }

    override func end() {
        Innerpeace.end()
    }

    override func startProcessingListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNapMusicProcessingWith(notification:)), name: NotificationName.napMusicData.name, object: nil)
    }

    @objc private func handleNapMusicProcessingWith(notification: Notification) {
        let info = notification.userInfo
        let napMusicData = info?[NotificationKey.napMusicCommandKey] as? NapMusic.NapMusicCommand
        if let data = napMusicData {
            SVProgressHUD.showInfo(withStatus: lang("实时脑波音乐分析数据：") + "\(data)")
        } else {
            SVProgressHUD.showError(withStatus: lang("数据分析异常"))
        }
    }

    override func stopProcessingListen() {
        NotificationCenter.default.removeObserver(self, name: NotificationName.napMusicData.name, object: nil)
    }
}
