//
//  NewWalletSettingController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import BLTNBoard
import LocalAuthentication
import TOPCore
import UIKit

class WalletSettingController: BaseTabViewController {
    @IBOutlet var bioVerifyLabel: UILabel!
    @IBOutlet var bioLoginLabel: UILabel!

    @IBOutlet var currencyUnitLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var backupLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!

    @IBOutlet var bioVerifySwitch: UISwitch!
    @IBOutlet var bioLoinSwith: UISwitch!

    private lazy var userStorage: UserStorageServiceInterface = inject()
    private lazy var viewUserService: ViewUserStorageServiceInterface = inject()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置".localized()
        bioVerifySwitch.isOn = viewUserService.current?.biometricPay ?? false
        bioLoinSwith.isOn = viewUserService.current?.biometricLogin ?? false

        localized()
        setup()
    }

    private func localized() {
        switch AuthenticationService.shared.biometryType {
        case .faceID:
            bioVerifyLabel.text = "面容支付".localized()
            bioLoginLabel.text = "面容解锁".localized()
        case .touchID:
            bioVerifyLabel.text = "指纹支付".localized()
            bioLoginLabel.text = "指纹解锁".localized()
        default:
            bioVerifyLabel.text = "生物识别支付不可用".localized()
            bioLoginLabel.text =  "生物识别解锁不可用".localized()
            bioVerifySwitch.isUserInteractionEnabled = false
            bioLoinSwith.isUserInteractionEnabled = false
        }

        currencyUnitLabel.text = "默认币种".localized()
        backupLabel.text = "备份助记词".localized()
        deleteButton.setTitle("删除钱包".localized(), for: .normal)
    }

    private func setup() {
        // ugly fix
        let flag = TOPStore.shared.currentUser.profile!.currency.name.contains("USD")
        currencyLabel.text = flag ? "USD $" : "CNY ¥"
    }

    // picker view
    private var board: BLTNItemManager?
}

extension WalletSettingController {
    @IBAction func bioAuthorizeAction(_ sender: UISwitch) {
        AuthenticationService.shared.setAuthenticationPayEnable(enable: sender.isOn) { success in
            if !success {
                sender.isOn = !sender.isOn
            }
        }
    }

    @IBAction func bioLoginAction(_ sender: UISwitch) {
        AuthenticationService.shared.setAuthenticationLoginEnable(enable: sender.isOn) { success in
            if !success {
                sender.isOn = !sender.isOn
            }
        }
    }

    @IBAction func deleteWalletAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "确认删除?".localized(), message: "所有数据将被清除".localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: "删除".localized(), style: .destructive, handler: { _ in
            guard let viewUser = self.viewUserService.current else { return }

            self.userStorage.remove(userID: viewUser.id)
            self.viewUserService.remove(viewUser)

            App.isLogined = false

            self.navigationController?.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)
        })
        let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancal)
        present(alert, animated: true, completion: nil)
    }
}

// add picker view
extension WalletSettingController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            addPickerView()

        case (1, 0):

            let controller = BackupTipController.loadFromSettingStoryboard()
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }

    private func addPickerView() {
        let page = PickerBLTNItem(title: "本地货币".localized())
        page.titleArray = ["USD $", "CNY ¥"]
        page.actionButtonTitle = "确认".localized()
        page.appearance = PageItemAppearance.default

        board = BLTNItemManager(rootItem: page)
        board?.showBulletin(above: self)

        page.actionHandler = { [weak self] _ in

            (inject() as UserStorageServiceInterface).update({ user in
                user.profile?.currency = FiatCurrency.cases[page.selectIndex]
            })
            // ugly fix
            let flag = TOPStore.shared.currentUser.profile!.currency.name.contains("USD")
            self?.currencyLabel.text = flag ? "USD $" : "CNY ¥"

            self?.board?.dismissBulletin()
        }
    }
}

// MARK: - face id
