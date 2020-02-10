//
//  AssetAccountManagementController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/29.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import UIKit

class AssetAccountManagementController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var walletInfo: ViewWalletInterface!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var deleteButton: UIButton!
    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "确认移除？".localized(), message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "移除".localized(), style: .destructive, handler: { [unowned self] _ in
            // 上报移除的资产
            PushManager.shared.removeWallets(assets: [self.walletInfo!])
            
            (inject() as UserStorageServiceInterface).update({ user in
                user.wallet?.delete(wallet: self.walletInfo!)
                NotificationName.deleteAccount.emit()
                self.navigationController?.popViewController(animated: true)
            })
        })

        let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in

        })
        alert.addAction(action)
        alert.addAction(cancal)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()
        // 只有一个账户不能删除
        let array = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: (walletInfo?.asset.assetID)!)
        deleteButton.isHidden = array.count == 1
    }

    override func setup() {
        title = "账户管理".localized()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        
    }
    
    private var datalist: [String] = []

    override func localizedString() {
        if !walletInfo.isMainCoin {
            datalist = ["修改账户名称".localized()]
        } else {
            datalist = ["修改账户名称".localized(), "导出私钥".localized()]
        }
        deleteButton.setTitle("删除账户".localized(), for: .normal)
    }
}

extension AssetAccountManagementController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "asset_reuse_identifier_cell"
        let cell: UITableViewCell
        if let reCell = tableview.dequeueReusableCell(withIdentifier: identifier) {
            cell = reCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(named: "lineColor")
            cell.contentView.addSubview(lineView)
            lineView.snp.makeConstraints {
                $0.left.equalTo(20)
                $0.right.equalTo(cell.snp.right).offset(-20)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
        }

        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        cell.textLabel?.textColor = .black
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = datalist[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let controller = ModifyAssetNameController.loadFromWalletStoryboard()
            controller.title = "编辑账户名称".localized()
            controller.walletInfo = walletInfo
            navigationController?.pushViewController(controller, animated: true)
        case 1:
            AuthenticationService.shared.verifyWithResult { flag, _ in
                if flag {
                    let controller = PrivateKeyBackUpController.loadFromWalletStoryboard()
                    controller.walletInfo = self.walletInfo
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
