//
//  AddressAuthPopView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/9.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

protocol AddressAuthPopViewActions: class {
    func closeAction()
    func confirmAction()
}

class AddressAuthPopView: BasePopview {
    
    var datalist: [NormalPopModel] = [] {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    weak var uiActions: AddressAuthPopViewActions!
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
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
        tableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableview.backgroundColor = .white
        tableview.dataSource = self
        tableview.delegate = self
        rightButton.isHidden = false
        rightButton.bk_(whenTapped: { [weak self] in
            if self?.uiActions == nil { return }
            self?.uiActions.closeAction()
        })
        submitButton.isHidden = false
        submitButton.bk_(whenTapped: { [weak self] in
            if self?.uiActions == nil { return }
            self?.uiActions.confirmAction()
        })
    }
    
    override func layout() {
        super.layout()
    }
}

extension AddressAuthPopView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "no_use_id")
        
        let model = datalist[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        cell.textLabel?.textColor = App.Color.title
        cell.textLabel?.text = model.speedDesc
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        cell.detailTextLabel?.textColor = App.Color.cellInfo
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = model.Fee
        
        let lineView = UIView()
        lineView.backgroundColor = App.Color.lineColor
        cell.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.bottom.right.equalTo(0)
            $0.left.equalTo(26)
            $0.height.equalTo(0.5)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}
