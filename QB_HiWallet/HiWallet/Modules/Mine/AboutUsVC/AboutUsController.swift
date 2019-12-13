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
        #if DEBUG
            logoImageVIew.isUserInteractionEnabled = true
            logoImageVIew.bk_(whenTapped: { [unowned self] in
                self.changeTestEnvironment()
            })
        #else

        #endif
    }

    private func setup() {
        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    override func localizedString() {
        super.localizedString()
        title = "关于我们".localized()
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
        case (1, 1):
            WebMannager.showInSafariWithUrl(url: LocalizationLanguage.systemLanguage == .chinese ? "https://www.hiwallet.org/protocol" : "https://www.hiwallet.org/protocol-en", controller: self)
        default: break
        }
    }

    private func checkUpdate() {
        AppHandler.shared.checkAppUpdateAlways(self)
    }
}

//MARK: - For Debuging

extension AboutUsController {
    private func changeTestEnvironment() {
        let alert = UIAlertController(title: "选择以太坊环境", message: nil, preferredStyle: .actionSheet)
        let main = UIAlertAction(title: "ETH正式网", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: UserDefautConst.ETHChain_Main)
        }
        let text = UIAlertAction(title: "ETH测试网", style: .default) { _ in
            UserDefaults.standard.set(false, forKey: UserDefautConst.ETHChain_Main)
        }

        let cancel = UIAlertAction(title: "取消".localized(), style: .cancel) { _ in
        }
        alert.addAction(main)
        alert.addAction(text)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
