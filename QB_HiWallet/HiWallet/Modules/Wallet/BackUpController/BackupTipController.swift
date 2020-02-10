//
//  BackupTipController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/17.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class BackupTipController: BaseViewController {
    
    @IBOutlet weak var backupTipLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var backupBtn: UIButton!
    
    @IBAction func backupAction(_ sender: UIButton) {

        AuthenticationService.shared.verifyWithResult { [weak self] result ,password in
            if result {
                let back = RemindBackupController.loadFromSettingStoryboard()
                self?.navigationController?.pushViewController(back, animated: true)
            }
        }
    }
    
    override func setup() {
        self.title = "备份钱包".localized()
        backupTipLabel.text = "备份提示".localized()
        infoLabel.text = "没有妥善备份就无法保障资产安全，删除程序或钱包后，您需要备份文件来恢复钱包。".localized()
        infoLabel.setLine(space: 6, font: UIFont.systemFont(ofSize: 14))
        tipLabel.text = "请在四周无人或无摄像头的安全环境下备份".localized()
        backupBtn.setTitle("立即备份钱包".localized(), for: .normal)
    }
}
