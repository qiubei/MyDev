//
//  SendSpeedPopView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class SendSpeedPopView: BasePopview {
    var feeType = SendSpeedFeeType.normal
    var datalist: [NormalPopModel] = [] {
        didSet {
            self.tableview.reloadData()
        }
    }
    var selectedActionBlock: ActionBlock<IndexPath>?
    private var selectedIndex = 1
    let tableview = UITableView(frame: .zero, style: .grouped)
    
    override var contentView: UIView {
        get {
            return tableview
        }
        
        set {
            super.contentView = newValue
        }
    }

    override func setup() {
        super.setup()
        tableview.separatorStyle = .none
        tableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableview.backgroundColor = .white
        tableview.dataSource = self
        tableview.delegate = self
        leftButton.isHidden = false
        submitButton.isHidden = true
    }

    override func layout() {
        super.layout()
    }
}

extension SendSpeedPopView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PopviewNormalCell(reuseIdentifier: "no_use_id")

        let model = datalist[indexPath.row]
        cell.imageView?.image = model.image
        cell.textLabel?.text = model.speedDesc
        cell.detailTextLabel?.text = model.Fee

        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feeType = SendSpeedFeeType(rawValue: indexPath.row % 3)!
        selectedIndex = indexPath.row
        tableview.reloadData()
        selectedActionBlock?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}
