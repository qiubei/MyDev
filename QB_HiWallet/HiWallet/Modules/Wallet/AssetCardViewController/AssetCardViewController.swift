//
//  AssetCardViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import ESPullToRefresh
import LYEmptyView
import SDWebImage
import SnapKit
import TOPCore
import UIKit

class AssetCardViewController: BaseViewController {
    // UI
    private let assetCardsView = AssetCardCollectionView(frame: .zero)
    private let tableview = UITableView(frame: .zero, style: .plain)
    private let lodingView = UIActivityIndicatorView(style: .gray)
    private let titleImageview = UIImageView()
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    // Data
    var assetWalletList: [ViewWalletInterface] = [] //TODO: 为什么不直接用这个从上层赋值，而要借助 assetID？
    var assetID: String!
    private var currentWallet: ViewWalletInterface?
    private var transitionHistoryList: [TransactionListViewModel] = []

    // MARK: - 生命周期

    override func viewDidLoad() {
        super.viewDidLoad()

        registNotice()
        reloadData()
    }

    // MARK: - 刷新数据

    @objc func reloadData() {
        reloadCardInfo()
        loadData()
    }

    private func registNotice() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCardInfo), name: NSNotification.Name(rawValue: NotificationConst.balanceChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNewAccent), name: NSNotification.Name(rawValue: NotificationConst.addAccount), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletDeleteAction(_:)), name: NSNotification.Name(rawValue: NotificationConst.deleteAccount), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
    }

    override func setup() {
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        assetCardsView.uiService = self

        tableview.refreshControl = UIRefreshControl()
    
        tableview.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)

        navigationItem.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20)).then { [weak self] in
            guard let self = self else { return }
            $0.addSubview(self.titleImageview)
            $0.addSubview(self.titleLabel)
            self.titleImageview.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(18)
            }

            self.titleLabel.snp.makeConstraints {
                $0.left.equalTo(self.titleImageview.snp.right).offset(4)
                $0.centerY.equalTo(self.titleImageview.snp.centerY)
                $0.right.equalToSuperview()
            }
        }
        view.addSubview(assetCardsView)
        view.addSubview(tableview)

        view.addSubview(lodingView)
        lodingView.hidesWhenStopped = true
        lodingView.center = view.center
    }

    override func layout() {
        assetCardsView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(6)
            $0.left.right.equalTo(0)
            $0.height.equalTo((UIScreen.main.bounds.width - 64) / App.assetCardRatio + 40)
        }

        tableview.snp.makeConstraints {
            $0.top.equalTo(self.assetCardsView.snp.bottom).offset(0)
            $0.right.left.bottom.equalTo(0)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRightBarItems()
    }

    @objc
    private func voteBarAction(_ sender: UIBarButtonItem) {
        Preference.hasTopVoted = true
        let ethWallet = (inject() as WalletInteractorInterface).createTempEthWallet(privateKey: currentWallet!.privateKey, address: currentWallet!.address)
        WebMannager.showDappWithUrl(url: TOPConstants.topStakingURL, wallet: ethWallet, controller: self)
    }

    @objc private func rightBarAction(_ sender: UIBarButtonItem) {
        let controller = ModifyAssetNameController.loadFromWalletStoryboard()
        controller.title = "创建新账户".localized()
        controller.newWallet = assetWalletList.first
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func walletDeleteAction(_ notification: Notification) {
        reloadData()
        assetCardsView.selectCard(index: 0, animated: true)
    }
}

// MARK: - loadData

extension AssetCardViewController {
    @objc func showNewAccent() {
        reloadCardInfo()
        assetCardsView.selectCard(index: assetWalletList.count - 1, animated: false)
    }

    @objc func reloadCardInfo() {
        assetWalletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        currentWallet = (currentWallet != nil && !currentWallet!.isInvalidated) ? currentWallet : assetWalletList.first
        assetCardsView.walletList = assetWalletList
        updateRightBarItems()
    }

    private func loadData() {
        guard currentWallet != nil else {
            return
        }
        TOPNetworkManager<ETHServices, Any>.cancelAllRequest()
        TOPNetworkManager<BTCServices, Any>.cancelAllRequest()

        if !tableview.refreshControl!.isRefreshing {
            lodingView.startAnimating()
        }

        if currentWallet!.isMainCoin {
            (inject() as WalletBlockchainWrapperInteractorInterface).getCoinBalance(for: MainCoin.getTypeWithSymbol(symbol: currentWallet!.symbol), address: currentWallet!.address, balance: { balance in

                (inject() as UserStorageServiceInterface).update({ _ in
                    self.currentWallet!.lastBalance = balance
                    self.reloadCardInfo()

                })
            }, failure: {
            })

        } else {
            let token = currentWallet?.asset as! Token
            (inject() as WalletBlockchainWrapperInteractorInterface).getTokenBalance(for: token, address: currentWallet!.address, balance: { balance in
                (inject() as UserStorageServiceInterface).update({ _ in

                    self.currentWallet!.lastBalance = balance
                    self.reloadCardInfo()
                })
            }, failure: {
            })
        }
        (inject() as WalletBlockchainWrapperInteractorInterface).getTransactionsByWallet(currentWallet!, transactions: { [weak self] result in
            guard let self = self else {
                return
            }
            self.transitionHistoryList.removeAll()

            // 所有数据
            let transcationList = result

            // pending数据
            let processingTxList = transcationList.filter {
                $0.status == .pending
            }
            if !processingTxList.isEmpty {
                let viewModel = TransactionListViewModel(titile: "正在处理".localized(), transactionList: processingTxList)
                self.transitionHistoryList.append(viewModel)
            }
            // 完成的交易
            let finishTxList = transcationList.filter {
                $0.status != .pending
            }
            if !finishTxList.isEmpty {
                let viewModel = TransactionListViewModel(titile: "交易记录".localized(), transactionList: finishTxList)
                self.transitionHistoryList.append(viewModel)
            }
            // 都没有
            if processingTxList.isEmpty && finishTxList.isEmpty {
                let viewModel = TransactionListViewModel(titile: "交易记录".localized(), transactionList: [])
                self.transitionHistoryList.append(viewModel)
            }
            self.tableview.ly_emptyView = LYEmptyView.empty(with: UIImage(named: "noData_icon"), titleStr: "无历史记录".localized(), detailStr: "")
            self.tableview.reloadData()
            self.lodingView.stopAnimating()
            self.tableview.refreshControl?.endRefreshing()
        }, failure: { error in
            self.transitionHistoryList.removeAll()
            // Cancel request handler
            if error.code != 6 {
                Toast.showToast(text: error.message)
            }
            self.tableview.reloadData()
            self.lodingView.stopAnimating()
            self.tableview.refreshControl?.endRefreshing()
        })

        let wallet = assetWalletList.first!
        titleImageview.setIconWithWallet(model: wallet)
        titleLabel.text = wallet.symbol
    }
}

// MARK: - tableview method

extension AssetCardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transitionHistoryList.count != 0 ? transitionHistoryList.count : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transitionHistoryList.count != 0 ? transitionHistoryList[section].transactionList.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "asset_tx_id"

        let cell: AssetTranscationCell
        if let re_cell = tableview.dequeueReusableCell(withIdentifier: identifier) as? AssetTranscationCell {
            cell = re_cell
        } else {
            cell = Nib.load(name: "AssetTranscationCellXIB").view as! AssetTranscationCell
        }

        cell.setUpWith(tx: transitionHistoryList[indexPath.section].transactionList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return transitionHistoryList.count != 0 ? transitionHistoryList[section].titile : "交易记录".localized()
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        view.tintAdjustmentMode = .dimmed
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = transitionHistoryList[indexPath.section].transactionList[indexPath.row]
        let txDetailController = TransactionDetailController.loadFromWalletStoryboard()
        txDetailController.transationModel = transaction.originalData
        txDetailController.viewTransaction = transaction
        txDetailController.wallet = currentWallet
        navigationController?.pushViewController(txDetailController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(named: "#111622")!
        label.text = transitionHistoryList.count != 0 ? transitionHistoryList[section].titile : "交易记录".localized()
        label.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
        }

        return view
    }
}

// MARK: - card gesture action method

extension AssetCardViewController: AssertCardCollectionActionService {
    func assetCardCopyAction(indexPath: IndexPath, selectedString: String) {
        if isBack() {
            UIPasteboard.general.string = selectedString
            Toast.showToast(text: "复制成功".localized())
        }
    }

    func assetCardManagerAction(indexPath: IndexPath) {
        guard let wallet = self.currentWallet else { return }
        let controller = AssetAccountManagementController.loadFromWalletStoryboard()
        controller.walletInfo = wallet
        navigationController?.pushViewController(controller, animated: true)
    }

    func assetCardSendAction(indexPath: IndexPath) {
        let controller = SendTableViewController.loadFromWalletStoryboard()
        controller.wallet = currentWallet
        navigationController?.pushViewController(controller, animated: true)
    }

    func assetCardReceiveAction(indexPath: IndexPath) {
        if isBack() {
            let controller = ReceiveTableViewController.loadFromWalletStoryboard()
            controller.wallet = currentWallet
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension AssetCardViewController {
    func collectionViewDidSelected(indexPath: IndexPath) {
        currentWallet = assetWalletList[indexPath.row]
        loadData()
    }
}

extension AssetCardViewController {
    func isBack() -> Bool {
        let currentUserBackups = TOPStore.shared.currentUser.backup?.currentlyBackup
        let backup = currentUserBackups!.isBackup
        if !backup {
            let alert = UIAlertController(title: "温馨提示".localized(), message: "你还没有备份助记词，建议立即备份！".localized(), preferredStyle: .alert)
            let action = UIAlertAction(title: "立即备份".localized(), style: .default, handler: { _ in
                let controller = BackupTipController.loadFromSettingStoryboard()
                self.navigationController?.pushViewController(controller, animated: true)
            })
            let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in

            })
            alert.addAction(action)
            alert.addAction(cancal)

            present(alert, animated: true, completion: nil)

            return false
        } else {
            return true
        }
    }

    private func updateRightBarItems() {
        var rightBarItems: [UIBarButtonItem] = []
        if assetWalletList.count < 3 {
            let item = UIBarButtonItem(image: UIImage(named: "Address_add"), style: .plain, target: self, action: #selector(rightBarAction(_:)))
            rightBarItems.append(item)
            if let flag = Preference.stakingSwitch, flag, !assetWalletList.first!.isMainCoin && (assetWalletList.first!.symbol == MainCoin.topnetwork.symbol) {
                let voteItem = UIBarButtonItem(image: UIImage(named: "icon_web_vote_none"), style: .plain, target: self, action: #selector(voteBarAction(_:)))
                if Preference.hasTopVoted {
                    voteItem.image = UIImage(named: "icon_web_vote")
                }
                rightBarItems.append(voteItem)
            }
        } else {
            if let flag = Preference.stakingSwitch, flag, !assetWalletList.first!.isMainCoin && (assetWalletList.first!.symbol == MainCoin.topnetwork.symbol) {
                let voteItem = UIBarButtonItem(image: UIImage(named: "icon_web_vote_none"), style: .plain, target: self, action: #selector(voteBarAction(_:)))
                if Preference.hasTopVoted {
                    voteItem.image = UIImage(named: "icon_web_vote")
                }
                rightBarItems.append(voteItem)
            }
        }
        navigationItem.rightBarButtonItems = rightBarItems
    }
}
