//
//  NewSendTableViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/17.
//  Copyright © 2019 TOP. All rights reserved.
//

import BLTNBoard
import EssentiaBridgesApi
import HDWalletKit
import TOPCore
import UIKit

class SendTableViewController: BaseTabViewController {
    @IBOutlet var symbolNameLabel: UILabel!
    @IBOutlet var availableLabel: UILabel!
    @IBOutlet var amountTextfiled: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var noteTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var recipientLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!

    var sendModel: TranstonInterface!

    // 完成转账弹框
    lazy var bulletinManager: BLTNItemManager = {
        let completPage = BulletinDataSource.makeCompletionPage()
        let failStatePage = BulletinDataSource.makeSendFailPage()

        failStatePage.alternativeHandler = { [weak self] item in

            item.manager?.dismissBulletin(animated: true)
            self?.navigationController?.popViewController(animated: true)
        }

        completPage.next = failStatePage

        completPage.actionHandler = { [weak self] item in

            item.manager?.dismissBulletin(animated: true)
            self?.navigationController?.popViewController(animated: true)
        }
        return BLTNItemManager(rootItem: completPage)
    }()

    var wallet: ViewWalletInterface!

    var dataError: Bool = false // 数据获取失败

    override func viewDidLoad() {
        super.viewDidLoad()

        if wallet.symbol == MainCoin.ethereum.symbol {
            sendModel = ETHTransViewModel(walletInfo: wallet)
        }

        if wallet.symbol == MainCoin.bitcoin.symbol {
            sendModel = UTXOTransViewModel(walletInfo: wallet)
        }

        if !wallet.isMainCoin {
            sendModel = TokenTransViewModel(walletInfo: wallet)
        }

        // 获取数据
        sendModel.loadData(callback: { [weak self] success in
            if !success {
                self?.showNetError()
            }
        })
    }

    override func localizedString() {
        title = "发送".localized()
        confirmButton.setTitle("确认发送".localized(), for: .normal)
        amountTextfiled.placeholder = "请输入金额".localized()
        addressTextField.placeholder = "请输入地址".localized()
        noteTextField.placeholder = "转账信息（选填）".localized()
        symbolNameLabel.text = wallet.symbol.uppercased()
        availableLabel.text = "可用余额: ".localized() + wallet.formattedBalanceWithSymbol
        recipientLabel.text = "发送到".localized()
        memoLabel.text = "备注tx".localized()
    }
}

// MARK: - Action

extension SendTableViewController {
    @IBAction func maxAction(_ sender: UIButton) {
        amountTextfiled.text = wallet.formattedBalance
    }

    @IBAction func addAddressAction(_ sender: UIButton) {
        let addresslist = AddressListViewController.loadFromSettingStoryboard()
        addresslist.isSelectModel = true
        addresslist.selectType = wallet!.isMainCoin ?  wallet?.symbol : "ETH" 
        addresslist.callBack = { contacts in
            self.addressTextField.text = contacts.address
        }
        navigationController?.pushViewController(addresslist, animated: true)
    }

    @IBAction func scanAction(_ sender: Any) {
        let vc = ScannerVC()

        // 设置标题、颜色、扫描样式（线条、网格）、提示文字
        vc.setupScanner("扫一扫".localized(), .green, .default, "将二维码/条码放入框内，即可自动扫描".localized()) { code in
            // 扫描回调方法
            self.addressTextField.text = code

            // 关闭扫描页面
            self.navigationController?.popViewController(animated: true)
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func confirmAction(_ sender: UIButton) {
        view.endEditing(true)

        sendModel.amount = amountTextfiled.text!
        sendModel.address = addressTextField.text!
        sendModel.note = noteTextField.text!

        switch sendModel.validInput() {
        case let .alert(msg):
            showAlert(msg: msg)

        case let .toast(msg):
            Toast.showToast(text: msg)
        case .success:
            Toast.showHUD()
            sendModel.loadFeeData { [weak self] success in
                Toast.hideHUD()
                if success {
                    self?.popConfrmView()
                } else {
                    self!.showNetError()
                }
            }
        }
    }

    func showAlert(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancal = UIAlertAction(title: "确定".localized(), style: .default, handler: { _ in

        })
        alert.addAction(cancal)
        present(alert, animated: true, completion: nil)
    }

    func popConfrmView() {
        let controller = PopViewController()
        controller.datalist = sendModel.getPopData()
        controller.balanceText = CryptoFormatter.attributeString(amount: amountTextfiled.text! + " " + wallet.symbol, balance: BalanceFormatter.getCurreyPrice(fullName:wallet.fullName ,value: Double(amountTextfiled.text!) ?? 0))

        controller.selectedSpeedAction = { [unowned self] index in

            controller.reloadData(data: self.sendModel.reloadPopDataWithIndex(index: index))
        }

        // 确认按钮

        controller.confirmAction = { [unowned self] in

            Toast.showHUD()
            self.sendModel.confirmVerify { result in
                Toast.hideHUD()
                switch result {
                case .success:
                    controller.dismiss(animated: true, completion: nil)

                    AuthenticationService.shared.verifyWithResult(resultBack: { success, _ in

                        if success {
                            self.showBulletin()
                            self.sendModel.sendTranstion(callback: { success, msg in
                                if success {
                                    
                                    (inject() as UserStorageServiceInterface).update({ _ in
                                        self.wallet.lastBalance = self.wallet.lastBalance - (Double(self.amountTextfiled.text!) ?? 0)
                                        self.availableLabel.text = "可用余额: ".localized() + self.wallet.formattedBalanceWithSymbol

                                    })
                                    
                                    self.bulletinManager.hideActivityIndicator()
                                } else {
//                                    Toast.showToast(text: msg)
                                    self.bulletinManager.displayNextItem()
                                }
                            })
                        }
                    })
                case let .toast(msg):
                    Toast.showToast(text: msg)

                case let .alert(msg):
                    self.showAlert(msg: msg)
                }
            }
        }

        controller.modalPresentationStyle = UIModalPresentationStyle.custom
        present(controller, animated: false, completion: nil)
    }

    func showBulletin() {
        bulletinManager.showBulletin(above: self)
    }
}

extension SendTableViewController {
    func showNetError() {
        Toast.showToast(text: "网络出走了，请检查网络状态后重试".localized())
    }
}

extension SendTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wallet.symbol == MainCoin.ethereum.symbol {
            return 3
        }
        return 2
    }
}
