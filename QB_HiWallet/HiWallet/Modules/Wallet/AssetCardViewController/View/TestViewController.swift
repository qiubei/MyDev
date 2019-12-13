//
//  TestViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore

class TestViewController: BaseViewController {
    var viewModel: AssetCardViewModel!
    private let assetCardView: AssetCardView = AssetCardView(frame: .zero)
    
    override func loadView() {
        super.loadView()
        view = assetCardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assetCardView.delegate = self
        assetCardView.reloadData()
        
        addEvents()
        setupTitleView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRightBarItems()
    }
    
    private func setupTitleView() {
        navigationItem.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20)).then { [weak self] in
            guard let self = self else { return }
            let imageview = UIImageView()
            imageview.setIconWithWallet(model: self.viewModel.currentWallet)
            let titleLabel = UILabel()
            titleLabel.text = self.viewModel.currentWallet.symbol
            $0.addSubview(imageview)
            $0.addSubview(titleLabel)
            imageview.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(18)
            }

            titleLabel.snp.makeConstraints {
                $0.left.equalTo(imageview.snp.right).offset(4)
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.right.equalToSuperview()
            }
        }
    }
    
    private func updateRightBarItems() {
        var rightBarItems: [UIBarButtonItem] = []
        
        if let flag = Preference.stakingSwitch,
            flag,
            viewModel.walletList.first!.asset.assetID == TOPConstants.erc20TOP_AssetID {
            let voteItem = UIBarButtonItem(image: UIImage(named: "icon_web_vote_none"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(voteBarAction(_:)))
            if Preference.hasTopVoted {
                voteItem.image = UIImage(named: "icon_web_vote")
            }
            rightBarItems.append(voteItem)
        }
        navigationItem.rightBarButtonItems = rightBarItems
    }
    
    private func addEvents() {
        NotificationName.createNewAccout.observe(sender: self, selector: #selector(addNewAccountAction))
        NotificationName.changeAccountInfo.observe(sender: self, selector: #selector(changeAccountInfo))
        NotificationName.deleteAccount.observe(sender: self, selector: #selector(deleteAccount))
    }
    
    @objc
    private func voteBarAction(_ sender: UIBarButtonItem) {
        Preference.hasTopVoted = true
        let ethWallet = (inject() as WalletInteractorInterface).createTempEthWallet(privateKey: viewModel.currentWallet.privateKey, address: viewModel.currentWallet.address)
        WebMannager.showDappWithUrl(url: TOPConstants.topStakingURL, wallet: ethWallet, controller: self)
    }

    @objc
    private func addNewAccountAction() {
        viewModel.addWallet {  [weak self] in
            self?.assetCardView.defaultSelected(index: self!.viewModel.selectedIndex)
        }
    }
    
    @objc
    private func changeAccountInfo() {
        viewModel.updateWallet { [weak self] in
            //TODO: ugly
            self?.assetCardView.reloadData()
        }
    }
    
    @objc
    private func deleteAccount() {
        viewModel.deleteWallet { [weak self] in
            self?.assetCardView.defaultSelected(index: self!.viewModel.selectedIndex)
        }
    }
}

extension TestViewController: AssetCardViewDelegate {
    func startRefreshAction() {
        viewModel.refreshCurrentWalletBalance {[weak self] (result) in
            switch result {
            case let .success(wallet):
                self?.assetCardView.selectedCard.setupWith(name: wallet.name,
                                                           address: wallet.address,
                                                           amount: wallet.formattedBalance,
                                                           balance: "≈ " + wallet.formattedBalanceInCurrentCurrencyWithSymbol)
                self?.assetCardView.stopRefresh()
            case .failure(_):
                //TODO: 确定是否需要
                Toast.showToast(text: "requeste failed!")
                break
            }
        }
    }
    
    func addCardAction() {
        let controller = ModifyAssetNameController.loadFromWalletStoryboard()
        controller.title = "创建新账户".localized()
        controller.newWallet = viewModel.walletList.first
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberOfAssetCard(assetcardView: AssetCardView) -> Int {
        return viewModel.walletList.count
    }

    func assetCardView(assetcardView: AssetCardView, cardFor index: Int) -> AssetCard {
        let card = AssetCard(frame: .zero)
        let wallet = viewModel.walletList[index]
        card.setupWith(name: wallet.name,
                       address: wallet.address,
                       amount: wallet.formattedBalance,
                       balance: "≈ " + wallet.formattedBalanceInCurrentCurrencyWithSymbol)

        return card
    }

    //TODO: 更新问题
    func assetCardView(assetcardView: AssetCardView, didSelected index: Int) {
        DLog("asset card selected: \(index)")
        
        viewModel.switchAssetCard(didSelect: index) { [weak self] in
            //TOOD: 刷新更新余额
//            self?.viewModel.refreshCurrentWalletBalance(callback: <#T##(Result<ViewWalletInterface, Error>) -> ()#>)
        }
    }

    func assetCardView(assetcardView: AssetCardView, copyFor index: Int) {
        DLog("asset card selected: \(index)")
        let addressStr = viewModel.walletList[index].address
        UIPasteboard.general.string = addressStr
        Toast.showToast(text: "复制成功".localized())
    }

    
    //TODO: 需要改进：事件和内容一致不好维护
    func assetCardView(assetcardView: AssetCardView, didSelectedInfoCell indexPath: IndexPath) {
        DLog("asset card info cell index: \(indexPath)")
        
        switch indexPath.row {
        case 0:
            let controller = SendTableViewController.loadFromWalletStoryboard()
            controller.wallet = viewModel.currentWallet
            navigationController?.pushViewController(controller, animated: true)
        case 1:
            if isBack() {
                let controller = ReceiveTableViewController.loadFromWalletStoryboard()
                controller.wallet = viewModel.currentWallet
                navigationController?.pushViewController(controller, animated: true)
            }
        case 2:
            let controller = TxHistoryViewController()
            controller.currentWallet = viewModel.currentWallet
            navigationController?.pushViewController(controller, animated: true)
        case 3:
            guard let wallet = viewModel.currentWallet else { return }
            let controller = AssetAccountManagementController.loadFromWalletStoryboard()
            controller.walletInfo = wallet
            navigationController?.pushViewController(controller, animated: true)
        default: break
        }
    }
    
    //TODO: 逻辑可以放到 View model 里面
    private func isBack() -> Bool {
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
}

//override func viewDidLoad() {
//        super.viewDidLoad()
////        testView()
////        testCardInfoView()
//        testCardView()
//    }
//
//    let cView = AssetCardView(frame: .zero)
//    private func testCardView() {
//        cView.delegate = self
//        cView.reloadData()
//        view.addSubview(cView)
//        cView.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
//    }
//
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated)
////        cView.defaultSelected(index: 1)
////    }
//
//    let cardView = AssetCardInfoView(frame: .zero)
//    func testCardInfoView() {
//        view.addSubview(cardView)
//        cardView.snp.makeConstraints {
//            $0.left.right.equalTo(0)
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.bottom.equalTo(-100)
//        }
//
//        cardView.tableview.delegate = self
//        cardView.tableview.dataSource = self
//        cardView.tableview.separatorStyle = .none
//        cardView.tableview.backgroundColor = .white
//        cardView.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell_reuse_id")
//        cardView.setupCard(name: "This is Account",
//                           address: "1G76JKL78UIhG66787666JKL78UIhG6678766",
//                           amount: "3242535474675.78283740923470328",
//                           balance: "≈ $ 12345678987654323456.654345676544567")
//    }
//
//    let card = AssetCard(frame: .zero)
//    func testView() {
//        view.addSubview(card)
//        card.snp.makeConstraints {
//            $0.left.equalTo(16)
//            $0.right.equalTo(-16)
//            $0.height.equalTo(card.snp.width).multipliedBy(170.0/334)
//            $0.center.equalToSuperview()
//        }
//    }
//
//    override func setup() {
//        card.nameLabel.text = "This is Account"
//        card.addressLabel.text = "1G76JKL78UIhG66787666JKL78UIhG6678766"
//        card.amountLabel.text = "3242535474675.78283740923470328"
//        card.balanceLabel.text = "≈ 12345678987654323456.654345676544567"
//    }
//
//    private let datalist: [String] = ["发送", "接受", "交易记录", "管理"]

//extension TestViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datalist.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuse_id")!
//
//        cell.textLabel?.text = datalist[indexPath.row]
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//}
//

