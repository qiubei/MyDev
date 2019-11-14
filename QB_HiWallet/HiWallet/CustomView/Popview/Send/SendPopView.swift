//
//  SendPopView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

protocol PopActionService: class {
    func tableviewDidSelected(_ popView: BasePopview, indexpath: IndexPath)
}

class SendPopView: BasePopview {
    // add a model
    weak var actionDelegate: PopActionService!

    let balanceLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 3
    }

    let tipLabel = UILabel().then {
        $0.textColor = App.Color.subHeader
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 10)
    }

    private let tableview = UITableView()
    private let tableviewHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 72))

    override func setup() {
        super.setup()
        rightButton.isHidden = false
        tableviewHeaderView.addSubview(balanceLabel)
        tableviewHeaderView.addSubview(tipLabel)
        tableview.isScrollEnabled = false
        tableview.tableHeaderView = tableviewHeaderView
        tableview.dataSource = self
        tableview.delegate = self
    }

    override func layout() {
        super.layout()
        balanceLabel.snp.makeConstraints {
            $0.top.equalTo(-8)
            $0.left.greaterThanOrEqualTo(50)
            $0.centerX.equalToSuperview()
        }

        tipLabel.snp.makeConstraints {
            $0.top.equalTo(self.balanceLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
            $0.bottom.equalTo(0)
        }
    }

    override var contentView: UIView {
        get {
            return tableview
        }
        
        set {
            super.contentView = newValue
        }
    }
    
    func reloadData(list: [SendPopViewModel]) {
        datalsit = list
        tableview.reloadData()
    }

    /// you can coustom data with the dictionary list,
    /// the element formate: dic["title"], dic["info"], dic["message"]
    var datalsit: [SendPopViewModel] = []
}

extension SendPopView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalsit.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "no_use_id"
        let cell: PopViewSendCell

        if let reusecell = tableView.dequeueReusableCell(withIdentifier: id) as? PopViewSendCell {
            cell = reusecell
        } else {
            cell = PopViewSendCell(reuseIdentifier: id)
        }
        let model = datalsit[indexPath.row]
        cell.titleLabel.text = model.title
        cell.infoLabel.text = model.topDesc
        cell.messageLabel.text = model.bottomDesc
        if (model.nextList != nil) {
            cell.accessoryType = .disclosureIndicator
        }
        cell.selectionStyle = model.nextList == nil ? .default : .none
        
        //去掉最后一根线
        if indexPath.row == self.datalsit.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.width, bottom: 0, right: 0)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = datalsit[indexPath.row]
        if (model.nextList != nil)  {
            guard actionDelegate != nil else { return }
            actionDelegate.tableviewDidSelected(self, indexpath: indexPath)
        }
    }
}
