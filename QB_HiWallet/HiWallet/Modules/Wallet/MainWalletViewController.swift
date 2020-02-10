//
//  WalletViewController.swift
//  HiWallet
//
//  Created by apple on 2019/5/24.
//  Copyright © 2019 TOP. All rights reserved.
//

import ESPullToRefresh
import Foundation
import SDWebImage
import TOPCore

import UIKit

fileprivate struct Store {
    var tokens: [ViewWalletObject: [TokenWallet]] = [:]
    var generatedWallets: [GeneratingWalletInfo] = []
    var importedWallets: [ImportedWallet] = []
    var allWallets: [ViewWalletInterface] = []
}

class MainWalletViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var walletNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalBalanceLabel: UILabel!

    private lazy var userStorage: UserStorageServiceInterface = inject()
    private lazy var interator: WalletInteractorInterface = inject()
    private lazy var blockchainInterator: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var store: Store = Store()
    private var isCheckVersion = false

    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(userInfoChanged), name: NSNotification.Name(rawValue: "userInfoChanged"), object: nil)

        tableView.es.addPullToRefresh { [unowned self] in

            self.reloadAllComponents()
        }
        // 未登录，展示热门币种
        if (inject() as ViewUserStorageServiceInterface).users.isEmpty {
            return
        }

        loadUser()

        let a = WebBrowserViewController()
        navigationController?.pushViewController(a, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 未登录，展示热门币种
        if (inject() as ViewUserStorageServiceInterface).users.isEmpty {
            let hotVc = BaseNavigationController(rootViewController: UIStoryboard.main().initViewController(name: .hotCoinController)!)
            present(hotVc, animated: false, completion: nil)
            return
        }

        if !isCheckVersion {
            checkUpdate()
        }

        if currentUser != nil {
            hardReload()
        }
    }

    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: TOPStore.shared.currentUser.profile?.currency ?? .cny)
        return formatter.formattedAmmountWithCurrency(amount: balance)
    }

    func loadUser() {
        currentUser = TOPStore.shared.currentUser
        if currentUser?.id.count == 0 {
            VerifyManager.verfiry(viewController: self, verifyType: .login, callBack: nil)
            return
        }

        walletNameLabel.text = currentUser?.profile?.name

        hardReload()
        tableView.reloadData()
    }

    private func hardReload() {
        (inject() as CurrencyRankDaemonInterface).update { [unowned self] in
            self.reloadAllComponents()
        }
    }

    private func reloadAllComponents() {
        loadData()
        loadBalances()
    }

    private func loadBalances() {
        let group = DispatchGroup()

        store.generatedWallets.enumerated().forEach { index, value in
            let address = value.address

            group.enter()

            blockchainInterator.getCoinBalance(for: value.coin, address: address, balance: { [unowned self] balance in

                group.leave()

                self.userStorage.update({ _ in
                    self.store.generatedWallets[index].lastBalance = balance

                })
            }, failure: {
                group.leave()
            })
        }

        store.tokens.forEach { tokenWallet in

            tokenWallet.value.enumerated().forEach({ indexedToken in
                let address = indexedToken.element.address

                group.enter()
                blockchainInterator.getTokenBalance(for: indexedToken.element.token ?? Token(), address: address, balance: { [unowned self] balance in

                    group.leave()
                    self.userStorage.update({ _ in
                        self.store.tokens[tokenWallet.key]?[indexedToken.offset].lastBalance = balance

                    })
                }, failure: {
                    group.leave()
                })
            })
        }

        group.notify(queue: DispatchQueue.main) {
            self.tableView.es.stopPullToRefresh()
            self.tableView.reloadData()
        }
    }

    private func loadData() {
        store.generatedWallets = interator.getGeneratedWallets()
        store.importedWallets = interator.getImportedWallets()
        store.allWallets = interator.getAllWallet()
        store.tokens = interator.getTokensByWalleets()
        totalBalanceLabel.text = formattedBalance(interator.getTotalBalanceInCurrentCurrency())
        tableView.reloadData()
    }

    //
    @objc func userInfoChanged() {
        // 解决删除数据库之后，object不存在的问题
        userStorage = (inject() as UserStorageServiceInterface)
        interator = (inject() as WalletInteractorInterface)
        //
        loadUser()
    }
}

extension MainWalletViewController {
    func checkUpdate() {
        TOPHttpManager<CommonServices, UpdateModel>.requestModel(.checkUpdate, success: { updateModel in

            if let model = updateModel {
                if model.hasUpdate == "0" {
                    return
                }
                let alert = UIAlertController(title: "Settings.About.findUpdate".localized(), message: model.description, preferredStyle: .alert)
                let action = UIAlertAction(title: "Settings.About.GoUpdate".localized(), style: .default, handler: { _ in
                    WebMannager.showInSafariWithUrl(url: model.downloadUrl!, controller: self)
                    self.isCheckVersion = (model.isForcedUpdates == 0)

                })
                let cancal = UIAlertAction(title: "Common.cancel".localized(), style: .cancel, handler: { _ in
                    self.isCheckVersion = (model.isForcedUpdates == 0)

                })
                alert.addAction(action)
                if model.isForcedUpdates == 0 {
                    alert.addAction(cancal)
                }
                self.present(alert, animated: true, completion: nil)
            }
        }, failure: nil)
    }
}

extension MainWalletViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

// MARK: - TabViewDelegate

extension MainWalletViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.allWallets.count
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 创建删除操作
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Wallet.Details.deleteWallet".localized()) { action, _ in

            print("删除操作")
            let wallet = self.store.allWallets[indexPath.row]
            let remain = wallet.asset.type == .coin ? "Wallet.Details.deleteWalletInfo".localized() : ""
            let alert = UIAlertController(title: "Wallet.Details.confirmDeleteWallet".localized(), message: remain, preferredStyle: .alert)
            let action = UIAlertAction(title: "Wallet.Details.deleteWallet".localized(), style: .destructive, handler: { [unowned self] _ in

                self.userStorage.update({ user in

                    user.wallet?.remove(wallet: wallet)
                    DispatchQueue.main.async {
                        self.loadData()
                    }

                })
            })

            let cancal = UIAlertAction(title: "Common.cancel".localized(), style: .cancel, handler: { _ in

            })
            alert.addAction(action)
            alert.addAction(cancal)

            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellNomal") as! WalletsTableViewCell
        let wallet = store.allWallets[indexPath.row]

        cell.iconImageView.sd_setImage(with: URL(string: wallet.logoUrl), completed: nil)
        cell.nameLabel.text = wallet.symbol
        cell.noteName.text = wallet.isToken ? getFaterWalletName(wallet: wallet) : wallet.name
        cell.balanceLabel.text = wallet.formattedBalanceWithSymbol
        cell.totalPriceLabel.text = wallet.formattedBalanceInCurrentCurrencyWithSymbol
        cell.fatherImageView.sd_setImage(with: URL(string: getFaterWalletIcon(wallet: wallet) ?? ""), completed: nil)
        cell.fatherImageView.isHidden = !wallet.isToken
        return cell
    }

    func getFaterWalletName(wallet: ViewWalletInterface) -> String {
        let result = store.allWallets.filter { $0.address == wallet.address && $0.symbol == "ETH" }
        return result.first!.name
    }

    func getFaterWalletIcon(wallet: ViewWalletInterface) -> String? {
        let result = store.allWallets.filter { $0.address == wallet.address && $0.symbol == "ETH" }
        return result.first?.iconUrl
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let wallet = store.allWallets[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WalletDetailViewController.loadFromStoryboard()
        vc.wallet = wallet
        navigationController?.pushViewController(vc, animated: true)
    }
}
