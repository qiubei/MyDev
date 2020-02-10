//
//  AssetManagementController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import RealmSwift
import TOPCore
import UIKit

class AssetManagementController: BaseViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableview: UITableView!

    private lazy var walletManager: WalletInteractorInterface = inject()
    private var viewModel = AssetMananagerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadInitData(update: true, success: { [weak self] in
            self?.tableview.reloadData()
        })
        tableview.keyboardDismissMode = .onDrag
    }

    override func setup() {
        title = "管理资产".localized()
        let _textField = searchBar.value(forKey: "searchField") as? UITextField
        _textField?.attributedPlaceholder = NSAttributedString(string: "输入资产名称或合约地址".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        _textField?.font = UIFont.systemFont(ofSize: 12)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消".localized()
    }
}

// MARK: - UITableDelegate

extension AssetManagementController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.showViewList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AssetSwitchCell = tableview.dequeueReusableCell(withIdentifier: "AssetSwitchCellID") as! AssetSwitchCell
        let cellModel = viewModel.showViewList[indexPath.row]
        cell.showStakingFlag = false
        cell.symbolLabel.text = cellModel.symbol
        cell.fullnameLabel.text = cellModel.desc
        cell.assetSwitch.isOn = cellModel.isOn
        cell.showStakingFlag = cellModel.isShowStakingFlag
        cell.iconimageView.setIconWithViewModel(model: cellModel)
        cell.chainImageview.setChainIconWithViewModel(model: cellModel)
        cell.chainImageview.isHidden = cellModel.isMainCoin
        cell.switchAction = { [weak self] open in
            cellModel.isOn = open
            self?.assetSwitchChange(open: open, cellModel: cellModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

// MARK: - UISearchBarDelegate

extension AssetManagementController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        viewModel.isSearching = true

        if let text = searchBar.text, text.count > 0 {
            return
        }
        tableview.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            viewModel.clearSearchData()
            tableview.reloadData()
            return
        }
        viewModel.searchCoin(content: searchText) { [weak self] in
            self?.tableview.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        viewModel.isSearching = false
        viewModel.clearSearchData()
        searchBar.resignFirstResponder()
        searchBar.text = ""
        tableview.reloadData()
    }
}

extension AssetManagementController {
    func assetSwitchChange(open: Bool, cellModel: AssetManagerCellViewModel) {
        if open {
            let array = walletManager.getHiddenWalletWithAssetID(assetID: String(cellModel.assetID))

            // 本地没有
            if array.isEmpty {
                // ("非本地钱包，本地没有，创建钱包")
                createAsset(model: cellModel.dataModel!)

            } else {
                // 本地有的话，直接重新打开
                // upload
                self.viewModel.appendUpload(wallets: array)
                for wallet in array {
                    (inject() as UserStorageServiceInterface).update({ user in
                        user.wallet?.open(wallet: wallet)
                    })
                }
            }
        } else {
            // "关闭，隐藏所有")
            closeAsset(assetID: cellModel.assetID)
        }
        //如果搜索中，重新计算数据
        if viewModel.isSearching {
            viewModel.loadInitData { [weak self] in
                self?.tableview.reloadData()
            }
        }
    }

    func closeAsset(assetID: String) {
        let array = walletManager.getWalletWithAssetID(assetID: assetID)
        // upload remove
        self.viewModel.appendRemove(wallets: array)
        for wallet in array {
            (inject() as UserStorageServiceInterface).update({ user in
                user.wallet?.remove(wallet: wallet)
            })
        }
    }

    // 本地没有添加过，直接创建
    func createAsset(model: ServiceCoinModel) {
        // 主币直接添加
        if model.isMainChain {
            let coin = ChainType.getTypeWithSymbol(symbol: model.symbol)
            (inject() as WalletInteractorInterface).addCoinsToWallet([coin],
                                                                     nickName: model.englishName,
                                                                     wallet: { [weak self] wallet in
                                                                        // upload
                                                                        self?.viewModel.appendUpload(wallets: [wallet])
            })
        } else {
            let token = Token(id: String(model.id),
                              contractAddress: model.contractAddress!,
                              symbol: model.symbol,
                              fullName: model.englishName,
                              decimals: model.decimals,
                              iconUrl: model.iconUrl,
                              webURL: model.infoURL ?? "",
                              chainType: model.chainType)

            walletManager.addTokenWallet(token, nickName: model.englishName) { [weak self] tokenWallet in
                //upload
                self?.viewModel.appendUpload(wallets: [tokenWallet])
            }
        }
    }
}
