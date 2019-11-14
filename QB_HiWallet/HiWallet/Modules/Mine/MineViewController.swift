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
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackInfoLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var walletSettingLabel: UILabel!
    @IBOutlet var wechatLabel: UILabel!
    @IBOutlet var telegramLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    @IBOutlet var facebookLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    

    lazy var language = LocalizationLanguage.systemLanguage

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人中心".localized()
        addEvents()
        localized()
    }

    private func addEvents() {
        feedbackView.bk_(whenTapped: { [unowned self] in
            WebMannager.showInSafariWithUrl(url: self.language == .chinese ? "https://wj.qq.com/s2/4570313/593d" : "https://wj.qq.com/s2/4570416/0a15", controller: self)
        })
    }

    private func localized() {
        feedbackLabel.text = "用户反馈".localized()
        feedbackInfoLabel.text = "有问题想吐槽？点这里".localized()
        addressLabel.text = "地址簿".localized()
        walletSettingLabel.text = "设置".localized()
        wechatLabel.text = "微信".localized()
        telegramLabel.text = "Telegram".localized()
        twitterLabel.text = "Twitter".localized()
        facebookLabel.text = "Facebook".localized()
        aboutLabel.text = "关于我们".localized()
    }
}

extension MineViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            // wechat
            UIPasteboard.general.string = "top_network"
            Toast.showToast(text: "复制成功".localized())
            break
        case (1, 1):
            //telegram
            if language == .chinese {
                UIPasteboard.general.string = "hiwallet_best"
                Toast.showToast(text: "复制成功".localized())
            } else {
                WebMannager.showInSafariWithUrl(url: "https://t.me/hiwallet_best", controller: self)
            }

            break
        case (1, 2):
            //twitter
            if language == .chinese {
                UIPasteboard.general.string = "HiWallet1"
                Toast.showToast(text: "复制成功".localized())
            } else {
                WebMannager.showInSafariWithUrl(url: "https://twitter.com/HiWallet1", controller: self)
            }
            break
        case (1, 3):
            // facebook
            if language == .chinese {
                UIPasteboard.general.string = "hiwalletbest"
                Toast.showToast(text: "复制成功".localized())
            } else {
                WebMannager.showInSafariWithUrl(url: "https://www.facebook.com/hiwalletbest/", controller: self)
            }
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "钱包".localized()
        case 1:
            return "关注我们".localized()
        default:
            return "其他".localized()
        }
    }
}
