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

    var localArray: [ViewWalletInterface] {
        var tempArray: [ViewWalletInterface] = []
        for array in walletManager.getAllWalletGroup() {
            tempArray.append(array[0])
        }
        return tempArray
    }

    var serviceArray: [ServiceCoinModel] = []
    var openModelArray: [ServiceCoinModel] = []
    var closeModelArray: [String] = []

    var showDataArray: [Any] = [] // 显示的数据
    var defautDataArray: [Any] { // 热门+本地数据
        var hotdataArray: [Any] = localArray
        for model in serviceArray {
            if !localArray.contains(where: { Int($0.asset.assetID) == model.id }) {
                hotdataArray.append(model)
            }
        }
        return hotdataArray
    } // 默认数据

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.keyboardDismissMode = .onDrag
        loadData()
    }

    override func setup() {
        title = "管理资产".localized()
        let _textField = searchBar.value(forKey: "searchField") as? UITextField
        _textField?.attributedPlaceholder = NSAttributedString(string: "输入资产名称或合约地址".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        _textField?.font = UIFont.systemFont(ofSize: 12)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消".localized()
    }

    private func loadData() {
        TOPNetworkManager<CommonServices, ServiceCoinModel>.requestModelList(.hotCoinSpecies, success: { array, _ in
            self.serviceArray = array ?? []
            self.showDataArray = self.defautDataArray
            self.tableview.reloadData()
        }) { error in
            Toast.showToast(text: error.message)
        }
    }
}

// MARK: - UITableDelegate

extension AssetManagementController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AssetSwitchCellID"

        let cell: AssetSwitchCell = tableview.dequeueReusableCell(withIdentifier: identifier) as! AssetSwitchCell
        cell.showStakingFlag = false
        if let wallet = showDataArray[indexPath.row] as? ViewWalletInterface {
            cell.iconimageView.setIconWithWallet(model: wallet)
            cell.chainImageview.setChainIconWithWallet(model: wallet)
            cell.chainImageview.isHidden = wallet.isMainCoin
            cell.symbolLabel.text = wallet.symbol
            cell.fullnameLabel.text = wallet.fullName
            cell.assetSwitch.isOn = true
            cell.assetSwitch.isOn = !closeModelArray.contains(wallet.asset.assetID)

            if !wallet.isMainCoin, wallet.symbol.uppercased() == MainCoin.topnetwork.symbol.uppercased() {
                cell.showStakingFlag = Preference.stakingSwitch ?? false
            }

            cell.switchAction = { [weak self] open in

                if open {
                    let array = self?.walletManager.getHiddenWalletWithAssetID(assetID: wallet.asset.assetID)
                    for wallet in array! {
                        (inject() as UserStorageServiceInterface).update({ user in
                            user.wallet?.open(wallet: wallet)
                        })
                    }

                    if let index = self?.closeModelArray.firstIndex(of: wallet.asset.assetID) {
                        self?.closeModelArray.remove(at: index)
                    }

                } else {
                    self?.closeAsset(assetID: wallet.asset.assetID)
                    self?.closeModelArray.append(wallet.asset.assetID)
                }
            }
        }

        if let model = showDataArray[indexPath.row] as? ServiceCoinModel {
            cell.iconimageView.setIconWithCoinModel(model: model)
            cell.symbolLabel.text = model.symbol
            cell.fullnameLabel.text = model.englishName
            cell.assetSwitch.isOn = openModelArray.contains(model)
            cell.chainImageview.setChainIconWithCoinModel(model: model)
            cell.chainImageview.isHidden = model.isMainChain

            cell.switchAction = { [weak self] open in
                self?.assetSwitchChange(open: open, asset: model)
                if open {
                    self?.openModelArray.append(model)
                } else {
                    if let index = self?.openModelArray.firstIndex(of: model) {
                        self?.openModelArray.remove(at: index)
                    }
                }
            }

            if !model.isMainChain, model.symbol.uppercased() == MainCoin.topnetwork.symbol.uppercased() {
                cell.showStakingFlag = Preference.stakingSwitch ?? false
            }
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

        if let text = searchBar.text, text.count > 0 {
            return
        }

        showDataArray = []
        tableview.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            showDataArray = []
            tableview.reloadData()
            return
        }

        TOPNetworkManager<CommonServices, Any>.cancelAllRequest()

        TOPNetworkManager<CommonServices, ServiceCoinModel>.requestModelList(.searchCoin(coinName: searchText), success: { result, _ in

            let array = result ?? []
            self.showDataArray = array
            for (index, model) in array.enumerated() {
                var tempModel: Any?
                if self.localArray.contains(where: { wallet -> Bool in
                    if Int(wallet.asset.assetID) == model.id {
                        tempModel = wallet
                    }
                    return Int(wallet.asset.assetID) == model.id
                }) {
                    self.showDataArray[index] = tempModel!
                }
            }

            self.tableview.reloadData()
        }, failure: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        showDataArray = defautDataArray
        tableview.reloadData()
    }
}

extension AssetManagementController {
    func assetSwitchChange(open: Bool, asset: ServiceCoinModel) {
        if open {
            let array = walletManager.getHiddenWalletWithAssetID(assetID: String(asset.id))

            // 本地没有
            if array.isEmpty {
                // ("非本地钱包，本地没有，创建钱包")

                createAsset(model: asset)

            } else {
                // 本地有的话，直接重新打开
                // "本地有，重新打开隐藏")

                for wallet in array {
                    (inject() as UserStorageServiceInterface).update({ user in
                        user.wallet?.open(wallet: wallet)
                    })
                }
            }
        } else {
            // "关闭，隐藏所有")

            closeAsset(assetID: String(asset.id))
        }
    }
}

//
extension AssetManagementController {
    // 本地没有添加过，直接创建
    func createAsset(model: ServiceCoinModel) {
        // 主币直接添加
        if model.isMainChain {
            let coin = MainCoin.getTypeWithSymbol(symbol: model.symbol)
            //TODO: MainCoin convert to AssetInterface???
            (inject() as WalletInteractorInterface).addCoinsToWallet([coin],
                                                                     nickName: model.englishName,
                                                                     wallet: { _ in })

        } else {
            let token = Token(id: String(model.id),
                              contractAddress: model.contractAddress!,
                              symbol: model.symbol,
                              fullName: model.englishName,
                              decimals: model.decimals!,
                              iconUrl: model.iconUrl,
                              webURL: model.infoURL ?? "",
                              chainType: model.chainType)

            walletManager.addTokenWallet(token, nickName: model.englishName) { _ in
            }
        }
    }

    func closeAsset(assetID: String) {
        let array = walletManager.getWalletWithAssetID(assetID: assetID)
        for wallet in array {
            (inject() as UserStorageServiceInterface).update({ user in
                user.wallet?.remove(wallet: wallet)
            })
        }
    }
}
