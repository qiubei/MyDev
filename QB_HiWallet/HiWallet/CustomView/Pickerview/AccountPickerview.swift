//
//  AccountPickerview.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

struct AccountPickerModel {
    var name: String
    var address: String
    var amount: Double
}

protocol AccountPickerViewActions: class {
    func closeAction()
    func selectedRow(indexPath: IndexPath)
}

class AccountPickerview: BasePopview {
    var datalist: [AccountPickerModel] = []
    weak var uiActions: AccountPickerViewActions!

    private var selectRow = -1
    private let tableview = UITableView(frame: .zero, style: .grouped)
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

        rightButton.isHidden = false
        rightButton.bk_(whenTapped: { [weak self] in
            if self?.uiActions == nil { return }
            self?.uiActions.closeAction()
        })
        submitButton.isHidden = true
        tableview.isScrollEnabled = false
        tableview.backgroundColor = .white
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}

extension AccountPickerview: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "top.cell.identifier.asset"

        let cell: AccountPickerCell
        if let re_cell = tableview.dequeueReusableCell(withIdentifier: identifier) as? AccountPickerCell {
            cell = re_cell
        } else {
            cell = AccountPickerCell(reuseIdentifier: identifier)
        }

        let model = datalist[indexPath.row]
        cell.titleLabel.text = model.name
        cell.messageLabel.text = model.address
        cell.infoLabel.text = "\(model.amount) TOP"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! AccountPickerCell
        cell.checkView.isHidden = false
        if uiActions == nil { return }
        uiActions.selectedRow(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AccountPickerCell
        cell.checkView.isHidden = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
