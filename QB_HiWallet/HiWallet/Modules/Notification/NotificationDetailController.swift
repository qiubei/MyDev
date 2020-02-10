//
//  NotificationDetailController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore

struct NotificationModel {
    var title: String
    var date: String
    var detail: String
}

class NotificationDetailController: BaseTabViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系统消息".localized()
        setup()
        layout()
    }
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 78))
    let titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = App.Color.createCard
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private var notificationModel: NotificationModel! {
        didSet {
            titleLabel.text = message.title
            dateLabel.text = Date(timeIntervalSince1970: Double(message.time)! / 1000).string(custom: "yyyy/MM//dd")
            tableView.reloadData()
        }
    }
    
    var message: PushMessage! {
        didSet {
            PushManager.shared.readMessage(messageID: message.id)
            NotificationName.changeNotiifcationInfo.emit()
            
            loadData()
        }
    }
    
    private func loadData() {
        switch message.type {
        case .NOTICE_ALL:
            notificationModel = NotificationModel(title: message.title,
                                                  date: message.time,
                                                  detail: message.desc)
        case .NOTICE_SIMPLE:
            TOPNetworkManager<PushServices, DetailMessageModel>.requestModel(.detailMessage(id: Int64(message.id)!), success: { [weak self] model in
                guard let self = self else { return }
                self.notificationModel = NotificationModel(title: self.message.title,
                                                           date: self.message.time,
                                                           detail: model.content)
            }, failure: { (error) in
                //Error handle
                DLog("request detail message failed!")
            })
        default: break
        }
    }
    
    private func setup() {
        headerView.addSubview(titleLabel)
        headerView.addSubview(dateLabel)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(22)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(18)
        }
    }
}

extension NotificationDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "detail_notification")
        
        if notificationModel != nil {
            cell.textLabel?.text = notificationModel.detail
        }
        cell.selectionStyle = .none
        cell.textLabel?.textColor = App.Color.titleColor
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.setLine(space: 7, font:  UIFont.systemFont(ofSize: 14))
    
        return cell
    }
}
