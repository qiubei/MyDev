//
//  NewSendTableViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/17.
//  Copyright © 2019 TOP. All rights reserved.
//

import BLTNBoard
import EssentiaBridgesApi

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
    var sendViewModel: SendTableviewModel!
    var confirmViewModel: ConfirmSendTxViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendViewModel = SendTableviewModel(wallet: wallet)
        confirmViewModel = ConfirmSendTxViewModel(wallet: wallet)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmViewModel.loadData { [weak self] (flag) in
            if !flag {
                self?.showNetError()
            }
        }
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
        amountTextfiled.text = sendViewModel.maxAmount
    }

    @IBAction func addAddressAction(_ sender: UIButton) {
        let addresslist = AddressListViewController.loadFromSettingStoryboard()
        addresslist.isSelectModel = true
        addresslist.selectType = wallet!.isMainCoin ? wallet?.symbol : "ETH"
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

        let txInput = SendTxInputInfo(amount: amountTextfiled.text!,
                                      to: addressTextField.text!,
                                      note: noteTextField.text!)
        sendViewModel.submitTxWith(txInput) { (type) in
            switch type {
            case let .alert(msg):
                showAlert(msg: msg)
            case let .toast(msg):
                Toast.showToast(text: msg)
            case .success:
                Toast.showHUD()
                self.confirmViewModel.checkoutInputInfoWith(txInputInfo: txInput) { (confirmType) in
                    Toast.hideHUD()
                    switch confirmType {
                    case let .toast(msg):
                        Toast.showToast(text: msg)
                    case let .alert(msg):
                        self.showAlert(msg: msg)
                    case .success:
                        self.popConfrmView()
                    }
                }
            }
        }
    }

    func showAlert(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancal = UIAlertAction(title: "确定".localized(), style: .default, handler: nil)
        alert.addAction(cancal)
        present(alert, animated: true, completion: nil)
    }

    func popConfrmView() {
        let controller = PopViewController()
        controller.datalist = confirmViewModel.updatePoplistWith(feeLevelIndex: 1)
        controller.balanceText = confirmViewModel.attributeAmount(amount: amountTextfiled.text!)

        controller.selectedSpeedAction = { [unowned self] index in
            controller.reloadData(data: self.confirmViewModel.updatePoplistWith(feeLevelIndex: index))
        }

        // 确认按钮
        controller.confirmAction = { [unowned self] in

            Toast.showHUD()
            self.confirmViewModel.confirmVerify { [weak self] result in
                guard let self = self else { return }
                Toast.hideHUD()
                switch result {
                case .success:
                    controller.dismiss(animated: true, completion: nil)

                    AuthenticationService.shared.verifyWithResult(resultBack: { [weak self] success, _ in
                        guard let self = self else { return }
                        if success {
                            self.bulletinManager.showBulletin(above: self, animated: true) { [weak self] in
                                guard let self = self else { return }
                                self.confirmViewModel.sendTranscation(callback: { [weak self] (success, _) in
                                    guard let self = self else { return }
                                    if success {
                                        (inject() as UserStorageServiceInterface).update({ _ in
                                            self.wallet.lastBalance = self.wallet.lastBalance - (Double(self.amountTextfiled.text!) ?? 0)
                                            self.availableLabel.text = "可用余额: ".localized() + self.wallet.formattedBalanceWithSymbol
                                        })

                                        self.bulletinManager.hideActivityIndicator()
                                    } else {
                                        self.bulletinManager.displayNextItem()
                                    }
                                })
                            }
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
}

extension SendTableViewController {
    func showNetError() {
        Toast.showToast(text: "网络出走了，请检查网络状态后重试".localized())
    }
}

extension SendTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wallet.symbol == ChainType.ethereum.symbol {
            return 3
        }
        return 2
    }
}
