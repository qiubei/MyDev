//
//  NotificationListController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore
import LYEmptyView

class NotificationListController: BaseTabViewController {
    var datalist = PushManager.shared.AllMessage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addEvent()
    }
    
    private let emptyViewHeight: CGFloat = 108
    private func setup() {
        title = "通知中心".localized()
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(NotificationInfoCell.self, forCellReuseIdentifier: "notification_info_cell_id")
        tableView.ly_emptyView = LYEmptyView.empty(with: UIImage(named: "noData_icon"), titleStr: "暂无通知".localized(), detailStr: "")
        tableView.ly_emptyView.contentViewOffset = -(navigationHeight + emptyViewHeight) / 2

        addRightBar()
    }
    
    private func addRightBar() {
        let rightBar = UIBarButtonItem(title: "一键已读".localized(),
                                  style: .plain,
                                  target: self,
                                  action: #selector(readAllAction(_:)))
        rightBar.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
        rightBar.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .selected)
        rightBar.tintColor = App.Color.titleColor
        navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc
    private func readAllAction(_ sender: UIBarButtonItem) {
        PushManager.shared.readAllMessage(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.datalist = PushManager.shared.AllMessage
                self.tableView.reloadData()
                NotificationName.changeNotiifcationInfo.emit()
            }
        })
    }
    
    private func addEvent() {
        NotificationName.changeNotiifcationInfo.observe(sender: self, selector: #selector(updateData(_:)))
    }
    
    @objc
    private func updateData(_ notification: Notification) {
        datalist = PushManager.shared.AllMessage
        tableView.reloadData()
    }
}

//MARK: tableview delegate and datasoure
extension NotificationListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification_info_cell_id") as! NotificationInfoCell
        
        let message = datalist[indexPath.row]
        cell.setupCell(message: message)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        datalist[indexPath.row].isRead = true // 缓存设置已读
        tableView.reloadRows(at: [indexPath], with: .automatic)
         
        let message = datalist[indexPath.row]
        switch message.type {
        case .NOTICE_SIMPLE, .NOTICE_ALL:
            let controller = NotificationDetailController()
            controller.message = message
            navigationController?.pushViewController(controller, animated: true)
        case .ACTIVITY:
            WebMannager.showWebViewWithUrl(url: message.url!, controller: self)
            PushManager.shared.readMessage(messageID: message.id)
            NotificationName.changeNotiifcationInfo.emit()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}

extension NotificationInfoCell {
    
    func setupCell(message: PushMessage) {
        titleLabel.text = message.title
        dateLabel.text = Date.init(timeIntervalSince1970: Double(message.time)! / 1000).string(custom: "yyyy/MM/dd")
        infoLabel.text = message.desc
        haveRead = message.isRead
    }
}
