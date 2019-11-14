//
//  ModifyAssetNameController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/29.
//  Copyright © 2019 TOP. All rights reserved.
//

import IQKeyboardManagerSwift
import TOPCore
import UIKit

class ModifyAssetNameController: BaseViewController, UITextFieldDelegate {
    // MARK: - override

    // 需要修改信息的时候传入
    var walletInfo: ViewWalletInterface?

    // 需要创建的时候传入
    var newWallet: ViewWalletInterface?

    private lazy var walletManager: WalletInteractorInterface = inject()

    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    @IBAction func confirmAction(_ sender: UIButton) {
        // TODO: save the new asset name
        if nameTextField.text?.count == 0 {
            Toast.showToast(text: "请输入账户名称".localized())
        } else if getStringByteLength(string: nameTextField.text!) > 30 {
            Toast.showToast(text: "名称不得超过 30 个字符".localized())
        } else {
            if walletInfo == nil {
                // 创建新Accent
                createNewAccent()
            } else {
                (inject() as UserStorageServiceInterface).update({ _ in
                    self.walletInfo!.name = self.nameTextField.text!
                })
                Toast.showToast(text: "修改成功！".localized())
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
            }

            navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = walletInfo {
            nameTextField.text = model.name
        } else {
            let array = walletManager.getWalletWithAssetID(assetID: (newWallet?.asset.assetID)!)
            nameTextField.text = newWallet!.fullName + " - " + "\(array.count + 1)"
        }
    }

    override func setup() {
        nameTextField.becomeFirstResponder()
        tipLabel.text = "有意义的名称有助于更好地管理帐户。".localized()
        nameLabel.text = "名称".localized()
        confirmButton.setTitle("确认".localized(), for: .normal)
        nameTextField.placeholder = "请输入账户名称".localized()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }

    // MARK: - private

    private func getStringByteLength(string: String) -> Int {
        var bytes: [UInt8] = []
        for char in string.gbkData {
            bytes.append(char.advanced(by: 0))
        }
        return bytes.count
    }
}

extension ModifyAssetNameController {
    func createNewAccent() {
        if let wallet = newWallet {
            // 添加代币
            if let tokenInfo = wallet.asset as? Token {
                let coin = MainCoin.getTypeWithSymbol(symbol: tokenInfo.chainType)

                switch coin {
                case .ethereum:
                    addEthToken(tokenInfo: tokenInfo)
                default:
                    Toast.showToast(text: "暂不支持该币")
                    break
                }

            } else {
                // 添加主币
                let coin = MainCoin.getTypeWithSymbol(symbol: wallet.symbol)
                // 如果有自动创建的就打开一个
                (inject() as WalletInteractorInterface).addCoinsToWallet([coin],
                                                                         nickName: nameTextField.text,
                                                                         wallet: { _ in })
                postAddNotication()
            }
        }
    }

    func addEthToken(tokenInfo: Token) {
        let token = Token(id: String(tokenInfo.id),
                          contractAddress: tokenInfo.contractAddress,
                          symbol: tokenInfo.symbol,
                          fullName: tokenInfo.fullName,
                          decimals: tokenInfo.decimals,
                          iconUrl: tokenInfo.iconUrl,
                          webURL: tokenInfo.webURL,
                          chainType: tokenInfo.chainType)

        (inject() as WalletInteractorInterface).addTokenWallet(token, nickName: nameTextField.text ?? "") { _ in
        }
        postAddNotication()
    }
}

extension ModifyAssetNameController {
    func postAddNotication() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConst.addAccount), object: nil)
    }
}
