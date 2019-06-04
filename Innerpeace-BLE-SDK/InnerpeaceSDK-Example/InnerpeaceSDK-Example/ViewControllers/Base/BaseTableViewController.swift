//
//  BaseTableViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/11.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    /// handle methods
    func start() {}
    func end() {}
    func startRawdataListen() {}
    func stopRawdataListen() {}
    func startProcessingListen() {}
    func stopProcessingListen() {}

    func createAccessoryView(indexPath: IndexPath) -> UIView {
        let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        switchView.tag = indexPath.row + 100
        switchView.addTarget(self, action: #selector(self.update(sender:)), for: .valueChanged)
        return switchView
    }

    @objc func update(sender: UISwitch) {}
    @objc func finishHandleWith(notification: Notification) {}

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.end()
    }

    deinit {
        let name = NSStringFromClass(object_getClass(self)!)
        print("deinit \(name)")
    }
}

extension BaseTableViewController {

}
