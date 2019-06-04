//
//  DeviceInfoViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import NaptimeBLE
import BLESDK

class DeviceInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let Reuse_Cell_Identifier = "Reuse_Cell_Identifier"

    @IBOutlet weak var tableview: UITableView!

    private lazy var infoItems: [(key: String, value: String)] = {
        let deviceName = Innerpeace.ble.deviceInfo.name
        let hardVersion = Innerpeace.ble.deviceInfo.hardware
        let fireware = Innerpeace.ble.deviceInfo.firmware
        let mac = Innerpeace.ble.deviceInfo.mac
        return [(lang("设备名称"), deviceName),(lang("硬件版本"), hardVersion),(lang("固件版本"), fireware),(lang("Mac 地址"), mac)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }

    /// tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reuseCell = tableview.dequeueReusableCell(withIdentifier: self.Reuse_Cell_Identifier) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: self.Reuse_Cell_Identifier)
        }

        cell.textLabel?.text = self.infoItems[indexPath.row].key
        cell.detailTextLabel?.text = self.infoItems[indexPath.row].value

        return cell
    }

    /// tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    deinit {
        print("deinit device info ")
    }
}
