//
//  AddressDetailTableViewController.swift
//  HiWallet
//
//  Created by Jax on 2019/8/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import BLTNBoard
import TOPCore
import UIKit

class AddressDetailTableViewController: BaseTabViewController, UITextFieldDelegate {
    // localized
    @IBOutlet var addressTitleLabel: UILabel!
    @IBOutlet var typeTitleLabel: UILabel!
    @IBOutlet var noteLocLabel: UILabel!
    @IBOutlet var commonUsedLocLabel: UILabel!

    //
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var noteLabel: UITextField!
    @IBOutlet var commonUserdSwith: UISwitch!
    @IBOutlet var deletedButton: UIButton!
    @IBOutlet var rightBttonItem: UIBarButtonItem!

    let user = TOPStore.shared.currentUser
    public var contacts: Contacts?
    private var board: BLTNItemManager?

    // 需要
    var seletcSymbol: String?
    var saveCallBack: ((_ contacts: Contacts) -> Void)?
    var isChanged: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_left_back"), style: .done, target: self, action: #selector(back))
        commonUserdSwith.addTarget(self, action: #selector(valueCange), for: .valueChanged)
        if let cont = contacts {
            addressTextField.text = cont.address
            typeTextField.text = cont.symble
            noteLabel.text = cont.note
            commonUserdSwith.isOn = cont.commonlyUsed

        } else {
            deletedButton.isHidden = true
        }

        if seletcSymbol != nil {
            typeTextField.text = seletcSymbol
            rightBttonItem.title = "保存".localized()
        }
        deletedButton.setTitle("删除地址".localized(), for: .normal)
    }

    @objc func valueCange() {
        isChanged = true
    }

    @objc func back() {
        if isChanged {
            let alert = UIAlertController(title: "是否保存修改？".localized(), message: nil, preferredStyle: .alert)
            let saveaAction = UIAlertAction(title: "保存".localized(), style: .default, handler: { _ in

                self.saveAction(UIButton())

            })

            let cancal = UIAlertAction(title: "放弃".localized(), style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)

            })
            alert.addAction(cancal)
            alert.addAction(saveaAction)

            present(alert, animated: true, completion: nil)

        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    override func localizedString() {
        if contacts != nil {
            title = "编辑地址".localized()
        } else {
            title = "新建地址".localized()
        }
        addressTitleLabel.text = "地址".localized()
        typeTitleLabel.text = "类型".localized()
        noteLocLabel.text = "备注".localized()
        commonUsedLocLabel.text = "设为常用地址".localized()

        addressTextField.placeholder = "请输入地址".localized()
        typeTextField.placeholder = "请选择主链类型".localized()
        noteLabel.placeholder = "请输入地址的备注".localized()
        rightBttonItem.title = "保存".localized()
    }
}

extension AddressDetailTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if seletcSymbol != nil {
                return
            }
            let page = PickerBLTNItem(title: "类型".localized())
            page.titleArray = ["ETH", "TOP", "BTC"]
            page.actionButtonTitle = "确认".localized()
            page.appearance = PageItemAppearance.default

            board = BLTNItemManager(rootItem: page)

            board?.showBulletin(above: self)

            page.actionHandler = { [weak self] _ in

                self?.typeTextField.text = page.titleArray[page.selectIndex]
                self?.isChanged = true
                self?.board?.dismissBulletin()
            }
        }
    }
}

extension AddressDetailTableViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isChanged = true
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isChanged = true
        return true
    }
}

extension AddressDetailTableViewController {
    @IBAction func saveAction(_ sender: Any) {
        view.resignFirstResponder()
        if addressTextField.text!.count == 0 {
            Toast.showToast(text:"请输入地址".localized())
            return
        }
        if typeTextField.text!.count == 0 {
            Toast.showToast(text:"请选择主链类型".localized())
            return
        }
        if noteLabel.text!.count == 0 {
            Toast.showToast(text:"请输入地址的备注".localized())
            return
        }

        if !isValidAddress(address: addressTextField.text!) {
            Toast.showToast(text:"请输入正确的地址".localized())
            return
        }
        if let cont = contacts {
            (inject() as UserStorageServiceInterface).update { _ in
                cont.address = self.addressTextField.text!
                cont.symble = self.typeTextField.text!
                cont.note = self.noteLabel.text!
                cont.commonlyUsed = self.commonUserdSwith.isOn
            }

        } else {
            let contacts = Contacts(address: addressTextField.text!, symble: typeTextField.text!, note: noteLabel.text!, commonlyUsed: commonUserdSwith.isOn)
            (inject() as UserStorageServiceInterface).update { _ in
                self.user.addressBook.append(contacts)
            }

            if let callback = saveCallBack {
                callback(contacts)
            }
        }

        Toast.showToast(text:"保存成功".localized())
        navigationController?.popViewController(animated: true)
    }

    func isValidAddress(address: String) -> Bool {
        switch typeTextField.text {
        case "ETH":
            return MainCoin.ethereum.isValidAddress(address)
        case "BTC":
            return MainCoin.bitcoin.isValidAddress(address)
        case "TOP":
            return MainCoin.topnetwork.isValidAddress(address)
        default:
            return false
        }
    }

    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "确认删除地址？".localized(), message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确认".localized(), style: .destructive, handler: { [unowned self] _ in
            (inject() as UserStorageServiceInterface).update { _ in
                self.contacts?.delete()
            }
            self.navigationController?.popViewController(animated: true)

        })

        let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in

        })
        alert.addAction(action)
        alert.addAction(cancal)

        present(alert, animated: true, completion: nil)
    }
}
