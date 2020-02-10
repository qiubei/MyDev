//
//  MineViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import BlocksKit
import TOPCore
import UIKit


class MineViewController: BaseTabViewController {
    @IBOutlet var feedbackView: UIView!
    @IBOutlet var feedbackLabel: UILabel!
    @IBOutlet var feedbackInfoLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet var walletSettingLabel: UILabel!
    @IBOutlet var wechatLabel: UILabel!
    @IBOutlet var telegramLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    @IBOutlet var facebookLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var wechatPublicLabel: UILabel!
    @IBOutlet var wechatPublicInfoLabel: UILabel!
    @IBOutlet var weiboLabel: UILabel!
    @IBOutlet var weiboInfoLabel: UILabel!
    @IBOutlet weak var notificationView: NotificationView!
    
    @IBOutlet weak var addressCard: UIView!
    @IBOutlet weak var notificationCard: UIView!
    @IBOutlet weak var settingCard: UIView!
    
    
    lazy var language = LocalizationLanguage.systemLanguage

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人中心".localized()
        addEvents()
        localized()
        
        notificationView.imageView.image = UIImage.init(named: "icon_notification_blue")
        
        notificationView.numberView.number = PushManager.shared.unReadCountNum
    }

    private func addEvents() {
        feedbackView.bk_(whenTapped: { [unowned self] in
            WebMannager.showInSafariWithUrl(url: self.language == .chinese ? "https://wj.qq.com/s2/4570313/593d" : "https://wj.qq.com/s2/4570416/0a15", controller: self)
        })
        
        addressCard.bk_(whenTapped: { [weak self] in
            let controller = AddressListViewController.loadFromSettingStoryboard()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        notificationCard.bk_(whenTapped: { [weak self] in
            let controller = NotificationListController()
            self?.navigationController?.pushViewController(controller, animated: true    )
        })
        
        settingCard.bk_(whenTapped: { [weak self] in
            let controller = WalletSettingController.loadFromSettingStoryboard()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        NotificationName.changeNotiifcationInfo.observe(sender: self,
                                                        selector: #selector(notificationInfoChangeAction(_:)))
    }

    @objc
    private func notificationInfoChangeAction(_ notification: Notification) {
        notificationView.numberView.number = PushManager.shared.unReadCountNum
    }
    
    private func localized() {
        feedbackLabel.text = "用户反馈".localized()
        feedbackInfoLabel.text = "有问题想吐槽？点这里".localized()
        addressLabel.text = "地址簿_profile".localized()
        notificationLabel.text = "通知中心".localized()
        walletSettingLabel.text = "设置".localized()
        wechatLabel.text = "微信".localized()
        wechatPublicLabel.text = "微信公众号".localized()
        weiboLabel.text = "微博".localized()
        telegramLabel.text = "Telegram".localized()
        twitterLabel.text = "Twitter".localized()
        facebookLabel.text = "Facebook".localized()
        aboutLabel.text = "关于我们".localized()
        
    }
}

// MARK: - tableview Method
extension MineViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // wechat
            UIPasteboard.general.string = "Hiwallet-official"
            Toast.showToast(text: "复制成功".localized())
        case (0, 1):
            // wechat public
            UIPasteboard.general.string = "小嗨区块链".localized()
            Toast.showToast(text: "复制成功".localized())
        case (0, 2):
            // weibo
            UIPasteboard.general.string = "HiWallet钱包".localized()
            Toast.showToast(text: "复制成功".localized())
        case (0, 3):
            //telegram
            if language == .chinese {
                UIPasteboard.general.string = "hiwallet_best"
                Toast.showToast(text: "复制成功".localized())
            } else {
                WebMannager.showInSafariWithUrl(url: "https://t.me/hiwallet_best", controller: self)
            }
        case (0, 4):
            //twitter
            if language == .chinese {
                UIPasteboard.general.string = "HiWallet1"
                Toast.showToast(text: "复制成功".localized())
            } else {
                WebMannager.showInSafariWithUrl(url: "https://twitter.com/HiWallet1", controller: self)
            }
        case (0, 5):
            // facebook
            if language == .chinese {
                UIPasteboard.general.string = "hiwalletbest"
                Toast.showToast(text: "复制成功".localized())
            } else {
                WebMannager.showInSafariWithUrl(url: "https://www.facebook.com/hiwalletbest/", controller: self)
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "关注我们".localized()
        default:
            return "其他".localized()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
}
