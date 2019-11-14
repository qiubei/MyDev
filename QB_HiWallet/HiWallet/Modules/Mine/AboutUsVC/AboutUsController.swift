//
//  NewAboutUsController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import BlocksKit
import SafariServices
import TOPCore
import UIKit

class AboutUsController: BaseTabViewController {
    @IBOutlet var versionTitleLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var termLabel: UILabel!
    @IBOutlet var logoImageVIew: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        localized()
        #if DEBUG
            logoImageVIew.isUserInteractionEnabled = true
            logoImageVIew.bk_(whenTapped: { [unowned self] in
                self.changeTestEnvironment()
            })

        #else

        #endif
    }

    private func changeTestEnvironment() {
        let alert = UIAlertController(title: "选择以太坊环境", message: nil, preferredStyle: .actionSheet)
        let main = UIAlertAction(title: "ETH正式网", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: UserDefautConst.ETHChain_Main)
        }
        let text = UIAlertAction(title: "ETH测试网", style: .default) { _ in
            UserDefaults.standard.set(false, forKey: UserDefautConst.ETHChain_Main)
        }

        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
        }
        alert.addAction(main)
        alert.addAction(text)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    private func setup() {
        title = "关于我们".localized()
        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    private func localized() {
        versionTitleLabel.text = "版本".localized()
        helpLabel.text = "帮助中心".localized()
        termLabel.text = "用户协议".localized()
    }
}

extension AboutUsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            checkUpdate()
        case (1, 0):
            WebMannager.showInSafariWithUrl(url: LocalizationLanguage.systemLanguage == .chinese ? "https://www.hiwallet.org/help" : "https://www.hiwallet.org/help-en", controller: self)
            break
        case (1, 1):
            WebMannager.showInSafariWithUrl(url: LocalizationLanguage.systemLanguage == .chinese ? "https://www.hiwallet.org/protocol" : "https://www.hiwallet.org/protocol-en", controller: self)
            break
        default:
            break
        }
    }

    private func checkUpdate() {
        TOPNetworkManager<CommonServices, UpdateModel>.requestModel(.checkAppUpdate, success: { model in
            if model.hasUpdate == "0" {
                let alert = UIAlertController(title: "暂无新版本!".localized(), message: "", preferredStyle: .alert)

                let cancal = UIAlertAction(title: "确认".localized(), style: .cancel, handler: { _ in

                })
                alert.addAction(cancal)
                self.present(alert, animated: true, completion: nil)
            }
            let alert = UIAlertController(title: "有新版本!".localized(), message: model.description, preferredStyle: .alert)
            let action = UIAlertAction(title: "去更新".localized(), style: .default, handler: { _ in

                WebMannager.showInSafariWithUrl(url: model.downloadUrl!, controller: self)

            })
            let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in

            })
            alert.addAction(action)
            alert.addAction(cancal)
            self.present(alert, animated: true, completion: nil)

        }, failure: nil)
    }
}
