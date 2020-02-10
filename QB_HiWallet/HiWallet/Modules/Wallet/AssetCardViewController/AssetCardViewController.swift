//
//  AssetCardViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore
import SDWebImage

class AssetCardViewController: BaseViewController {
    var viewModel: AssetCardViewModel!
    private let assetCardView: AssetCardView = AssetCardView(frame: .zero)
    private let scrollview = UIScrollView()
    
    private lazy var bottomSafaGuideView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)).then {
        $0.backgroundColor = UIColor.init(hex: "#EAEAEA", alpha: 0.95)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        assetCardView.delegate = self
        assetCardView.defaultSelected(index: 0)
        
        addEvents()
        setupTitleView()
        
        assetCardView.cardInfoView.addRefreshControl { [weak self] in
            guard let self = self else { return }
            self.updateCardInfo()
        }
    }
    
    private func setupViews() {
        view.addSubview(scrollview)
        view.addSubview(bottomSafaGuideView)
        bottomSafaGuideView.layer.zPosition = .greatestFiniteMagnitude
        scrollview.addSubview(assetCardView)
        scrollview.isScrollEnabled = false
        scrollview.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        assetCardView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(viewModel.scrollviewContentHeight)
        }
        
        assetCardView.smallScreenOffset = viewModel.scrollviewContentHeight - (screenHeight - navigationHeight - viewModel.bottomMarginValue)

        bottomSafaGuideView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(viewModel.bottomMarginValue)
        }
        
        if viewModel.walletList.count == 1 {
            bottomSafaGuideView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        
        updateCardInfo()
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
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
            }
        }
    }
    
    private func updateRightBarItems() {
        var rightBarItems: [UIBarButtonItem] = []
        
        if viewModel.isShowStakingFlag {
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
        scrollview.isScrollEnabled = false
        viewModel.addWallet {  [weak self] in
            guard let self = self else { return }
            self.assetCardView.smallScreenOffset = self.viewModel.scrollviewContentHeight - (screenHeight - navigationHeight - self.viewModel.bottomMarginValue)
            self.assetCardView.snp.remakeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalTo(self.viewModel.scrollviewContentHeight)
            }
            self.assetCardView.defaultSelected(index: self.viewModel.selectedIndex)
        }
        bottomSafaGuideView.isHidden = false
    }
    
    @objc
    private func changeAccountInfo() {
        viewModel.updateWallet { [weak self] in
            self?.assetCardView.defaultSelected(index: self!.viewModel.selectedIndex)
        }
    }
    
    @objc
    private func deleteAccount() {
        scrollview.isScrollEnabled = false
        viewModel.deleteWallet { [weak self] in
            self?.assetCardView.defaultSelected(index: self!.viewModel.selectedIndex)
        }
        
        if viewModel.walletList.count == 1 {
            bottomSafaGuideView.isHidden = true
        }
        
        assetCardView.snp.remakeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(viewModel.scrollviewContentHeight)
        }
    }
}

//MARK: - AssetCardViewDelegate

extension AssetCardViewController: AssetCardViewDelegate {
    func assetCardView(assetcardView: AssetCardView, unSelected index: Int) {
        navigationItem.rightBarButtonItems = []
        scrollview.isScrollEnabled = true
        bottomSafaGuideView.isHidden = true
    }
    
    func assetCardViewTapAddCardAction() {
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
        card.colors = cardColors(with: wallet)
        card.setupWith(name: wallet.name,
                       address: wallet.address,
                       amount: wallet.formattedBalance,
                       balance: "≈ " + wallet.formattedBalanceInCurrentCurrencyWithSymbol,
                       iconImage: cardIconImage(with: wallet))
        return card
    }

    func assetCardView(assetcardView: AssetCardView, didSelected index: Int) {
        updateRightBarItems()
        viewModel.switchAssetCard(didSelect: index) { [weak self] in
            guard let self = self else { return }
            self.assetCardView.updateSelectedCardInfo(wallet: self.viewModel.currentWallet)
            assetCardView.pendingTxNubmer = 0 // 去除切换卡片时小红点停留的问题
            self.updateCardInfo()
        }
        
        // 添加或删除卡片基于原点动画
        scrollview.setContentOffset(.zero, animated: true)
        scrollview.isScrollEnabled = false
        
        if viewModel.walletList.count != 1 {
            bottomSafaGuideView.isHidden = false
        }
    }

    func assetCardView(assetcardView: AssetCardView) {
        if isBack() {
            let addressStr = viewModel.currentWallet.address
            UIPasteboard.general.string = addressStr
            Toast.showToast(text: "复制成功".localized())
        }
    }

    //TODO: 需要改进：事件和内容一致不好维护
    func assetCardView(assetcardView: AssetCardView, didSelectedInfoCell indexPath: IndexPath) {
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
}

extension AssetCardViewController {
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
    
    private func updateCardInfo() {
        // 更新余额
        viewModel.refreshCurrentWalletBalance { [weak self] wallet in
            self?.assetCardView.updateSelectedCardInfo(wallet: wallet)
            self?.assetCardView.cardInfoView.stopRefreshing()
        }
        
        // 更新正在交易的信息
        viewModel.getPendingTxCount { [weak self] count in
            self?.assetCardView.pendingTxNubmer = count
        }
    }
    
    private func cardColors(with wallet: ViewWalletInterface) -> [CGColor] {
        if wallet.isMainCoin {
            switch wallet.chainType {
            case .bitcoin:
                return App.Color.btcColors
            case .dash:
                return  App.Color.dashColors
            case .litecoin:
                return  App.Color.ltcColors
            case .bitcoinCash:
               return App.Color.bchColors
            case .ethereum:
                return App.Color.ethColors
            default:
                return App.Color.backupBgColors
            }
        }
        
        return App.Color.ethColors
    }
    
    private func cardIconImage(with wallet: ViewWalletInterface) -> UIImage {
        if wallet.isMainCoin {
            return UIImage.init(named: "icon_\(wallet.symbol.lowercased())_blur") ?? UIImage()
        }
        return UIImage.init(named: "icon_token_blur")!
    }
}
