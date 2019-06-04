//
//  NapViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/8.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import BLESDK
import BLESDK_NapMusic
import SVProgressHUD

class NapViewController: BaseTableViewController {
    private var napCommandIterms = [lang("开始体验"), lang("原始脑波监听"), lang("实时脑波分析的数据监听")]

    /// tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return napCommandIterms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "nap_cell", for: indexPath)
        cell.textLabel?.text = self.napCommandIterms[indexPath.row]
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
        default:
            print("default")
        }
    }

    /// Commands
    override func start() {
        isFinished = false
        do {
            try Innerpeace.start(algorithm: AlgorithmOptions.nap)
            NotificationCenter.default.addObserver(self, selector: #selector(self.finishHandleWith(notification:)), name: NotificationName.napFinishData.name, object: nil)
        } catch (let error) {
            SVProgressHUD.showError(withStatus: lang("开始体验异常") + " \(error)")
        }
    }

    private var isFinished = false

    override func end() {
        // ugly fix
        guard !isFinished else { return }
        isFinished = true
        Innerpeace.end()
        // TODO: 是否需要延迟
        NotificationCenter.default.removeObserver(self, name: NotificationName.napFinishData.name, object: nil)
    }

    override func startRawdataListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleListenBrainwaveRawValue(notification:)), name: NotificationName.bleBrainwaveData.name, object: nil)
    }

    override func stopRawdataListen() {
        NotificationCenter.default.removeObserver(self, name: NotificationName.bleBrainwaveData.name, object: nil)
    }

    @objc
    private func handleListenBrainwaveRawValue(notification: Notification) {
        let info = notification.userInfo
        let brainData = info?[NotificationKey.bleBrainwaveKey] as? Data
        if let data = brainData {
            SVProgressHUD.showInfo(withStatus: lang("原始脑波：") + "\n \(data.copiedBytes)")
        }
    }

    override func startProcessingListen() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.processdHandle(notification:)), name: NotificationName.napProcessData.name, object: nil)
    }

    override func stopProcessingListen() {
        NotificationCenter.default.removeObserver(self, name: NotificationName.napProcessData.name, object: nil)
    }

    @objc
    private func processdHandle(notification: Notification) {
        guard let info = notification.userInfo, let processData = info[NotificationKey.napProcessDataKey] as? NapMusic.NapProcessData else { return }
        print("nap process data  \(processData)")
        SVProgressHUD.showInfo(withStatus: lang("分析后数据：") + "\n\(processData)")
    }

    override func finishHandleWith(notification: Notification) {
        let info = notification.userInfo
        let finishData = info?[NotificationKey.napFinishDataKey] as? NapMusic.NapFinishData
        print("\(finishData!.sleepCurveData!.copiedBytes)")
        if let data = finishData {
            SVProgressHUD.showInfo(withStatus: lang("本次体验结果：") + "\n \(data)")
        } else {
            SVProgressHUD.showInfo(withStatus: lang("数据异常：数据为空"))
        }
    }
}
