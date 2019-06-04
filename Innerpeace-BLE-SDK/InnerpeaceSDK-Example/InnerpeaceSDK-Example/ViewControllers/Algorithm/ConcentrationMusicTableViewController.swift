//
//  ConcentrationMusicTableViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/11.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import SVProgressHUD
import BLESDK
import BLESDK_ConcentrationMusic

class ConcentrationMusicTableViewController: BaseTableViewController {
    private let concentrationMusicIterms = [lang("开始体验"), lang("注意力谱曲监听")]

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return concentrationMusicIterms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "concentration_music_cell", for: indexPath)
        cell.textLabel?.text = self.concentrationMusicIterms[indexPath.row]
        cell.accessoryView = self.createAccessoryView(indexPath: indexPath)
        return cell
    }

    override func update(sender: UISwitch) {
        switch (sender.tag % 100)  {
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
                SVProgressHUD.showInfo(withStatus: lang("开启注意力谱曲监听"))
                self.startProcessingListen()
            } else {
                SVProgressHUD.showInfo(withStatus: lang("关闭注意力谱曲监听"))
                self.stopProcessingListen()
            }
        default:
            print("default")
        }
    }


    /// <#Description#>
    override func start() {
        do {
            try Innerpeace.start(algorithm: .concentrationMusic)
            NotificationCenter.default.addObserver(self, selector: #selector(self.finishHandleWith(notification:)), name: NotificationName.concentrationMusicFinishData.name, object: nil)
        } catch(let error) {
            SVProgressHUD.showError(withStatus: lang("开始体验异常:") + " \(error)")
        }
    }


    /// 在调用 Innerpeace.end() 后，底层会触发 NotificationName.concentrationMusicFinishData.name 通知
    override func end() {
        Innerpeace.end()
        NotificationCenter.default.removeObserver(self, name: NotificationName.concentrationMusicFinishData.name, object: nil)
    }

    override func startProcessingListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleConcentrationMusicProcessingWith(notification: )), name: NotificationName.concentrationMusicData.name, object: nil)
    }


    /// 注意力音乐通知监听：根据通知携带上来的信息做相应的处理。注意：注意力的结束不是不是不是通过
    /// ConcentrationMusic.ProcessData.process.state = end 来触发的
    /// - Parameter notification: 根据参数 notification 携带上来的做相应的逻辑处理。
    @objc private func handleConcentrationMusicProcessingWith(notification: Notification) {
        let info = notification.userInfo
        let processData = info?[NotificationKey.concentrationMusicKey] as? ConcentrationMusic.MusicProcessData
        if let data = processData {
            SVProgressHUD.showInfo(withStatus: lang("实时注意力谱曲分析数据：") + "\(data)")
        } else {
            SVProgressHUD.showError(withStatus: lang("数据分析异常"))
        }
    }

    override func stopProcessingListen() {
        NotificationCenter.default.removeObserver(self, name: NotificationName.concentrationMusicData.name, object: nil)
    }


    /// 注意力音乐体验结束生成的报表数据。由上面的 Innerpeace.end() 触发。
    ///
    /// - Parameter notification: 根据参数 notification 携带上来的做相应的逻辑处理。
    override func finishHandleWith(notification: Notification) {
        let info = notification.userInfo
        let finishData = info?[NotificationKey.concentrationFinishDataKey] as? ConcentrationMusic.Result
        if let data = finishData {
            SVProgressHUD.showInfo(withStatus: "\(data)")
        } else {
            SVProgressHUD.showInfo(withStatus: lang("结束本体体验异常： 没有数据"))
        }
    }
}
