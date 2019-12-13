//
//  WalletMainViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/2.
//  Copyright © 2019 TOP. All rights reserved.
//

import BlocksKit
import Then
import TOPCore
import UIKit

class WalletMainViewController: BaseViewController, UINavigationControllerDelegate {
    @IBOutlet var headerView: WalletMainHeaderView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var backupTipView: GradientView!
    @IBOutlet var backupLabel: UILabel!
    @IBOutlet var backupTipLabel: UILabel!
    @IBOutlet var fakeNavigationBar: GradientView!
    @IBOutlet var fakeNavigationBarHeight: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    
    private let bouncesView = GradientView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: statusHeight))

    private let viewModel = WalletMainViewModel()
    private var datalist: [[ViewWalletInterface]]?
    private var hiddenNum = false
    private var isCheckVersion = false
    private var isAnimating = false
    private var needStakingLayout = true
    private var isShowStakingView: Bool? = Preference.stakingSwitch

    override func viewDidLoad() {
        super.viewDidLoad()
        addEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppHandler.shared.checkAppUpdate(self)

        reloadData()
    }

    override func localizedString() {
        backupLabel.text = "备份助记词".localized()
        backupTipLabel.text = "为提升账户安全性，请备份助记词。".localized()
        titleLabel.text = "HiWallet".localized()
    }

    override func setup() {
        navigationController?.delegate = self
        view.insertSubview(bouncesView, belowSubview: tableview)
        fakeNavigationBar.alpha = 0
        fakeNavigationBarHeight.constant = navigationHeight

        tableview.contentInset = UIEdgeInsets(top: statusHeight, left: 0, bottom: 0, right: 0)
        tableview.showsVerticalScrollIndicator = false
        tableview.refreshControl = UIRefreshControl()
        tableview.refreshControl?.tintColor = UIColor.white
        tableview.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableview.dataSource = self
        tableview.delegate = self

        headerView.assetLabel.isUserInteractionEnabled = true
        headerView.assetLabel.bk_(whenTapped: {
            self.hidhenOrShowAction(UIButton())
        })

        backupTipView.colors = App.Color.backupBgColors
        backupTipView.bk_(whenTapped: { [weak self] in
            let controller = BackupTipController.loadFromSettingStoryboard()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
    }
}

// MARK: - loadData and updateviews

extension WalletMainViewController {
    @objc func reloadData() {
        viewModel.setupWithUserState { state in
            switch state {
            case .unregister:
                let guide = GuideViewController.loadFromWalletStoryboard()
                let nav = BaseNavigationController(rootViewController: guide)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: false, completion: nil)
            case .unLogin:
                datalist?.removeAll()
                self.tableview.reloadData()
            case .logined:
                backupTipView.isHidden = viewModel.isBackup
                if !viewModel.isBackup {
                    tableview.contentInset = UIEdgeInsets(top: tableview.contentInset.top, left: 0, bottom: 80, right: 0)
                } else {
                    tableview.contentInset = UIEdgeInsets(top: tableview.contentInset.top, left: 0, bottom: 0, right: 0)
                }
                loadAsset()
            }
        }
    }

    private func loadAsset() {
        // load data from disk
        viewModel.loadWalletInfoFromDB { [weak self] list, balanceString in
            guard let self = self else { return }
            self.datalist = list
            self.updateBalanceViewWith(balanceString: balanceString)
        }

        // update balance from network to disk and reload data
        viewModel.updateAssetBalanceWithNetworkRank({ [weak self] in
            self?.tableview.refreshControl?.endRefreshing()
            self?.viewModel.loadWalletInfoFromDB { [weak self] list, balanceString in
                guard let self = self else { return }
                self.datalist = list
                self.updateBalanceViewWith(balanceString: balanceString)
            }
        })
    }

    private func updateBalanceViewWith(balanceString: String) {
        let attribteString = CryptoFormatter.balanceAttributeString(text: balanceString, currencyFont: UIFont.systemFont(ofSize: 26), amountFont: UIFont(name: "DIN Alternate", size: 36)!)

        headerView.balanceLabel.attributedText = hiddenNum ? NSAttributedString(string: "******") : attribteString
        tableview.reloadData()
    }
}

// MARK: - Action

extension WalletMainViewController {
    @IBAction func hidhenOrShowAction(_ sender: UIButton) {
        hiddenNum = !hiddenNum
        headerView.eyeButton.isSelected = hiddenNum
        updateBalanceViewWith(balanceString: viewModel.getTotalBalance())
    }

    @IBAction func intoAssetManagerAction(_ sender: UIButton) {
        let controller = AssetManagementController.loadFromWalletStoryboard()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func addEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStakingState(_:)), name: Notification.Name(NotificationConst.stakingSwitchEvent), object: nil)
        headerView.stakingRouteView.bk_(whenTapped: { [unowned self] in
            self.openDappStaking()
        })
    }

    private func openDappStaking() {
        viewModel.handleOpenStakingWith { topState in
            switch topState {
            case .none:
                let alert = UIAlertController(title: "".localized(), message: "此投票 DApp 需要 TOP 账户，您可开启账户后继续投票".localized(), preferredStyle: .alert)
                let action = UIAlertAction(title: "开启并继续".localized(), style: .default, handler: { _ in
                    self.viewModel.openERC20TOPTokenWallet()
                    self.reloadData()
                    self.openDappStaking()
                })
                let cancel = UIAlertAction(title: "取消".localized(), style: .cancel, handler: nil)
                alert.addAction(action)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
            case let .onlyOne(wallet):
                WebMannager.showDappWithUrl(url: TOPConstants.topStakingURL, wallet: viewModel.getETHWalletWith(topTokenWallet: wallet), controller: self)
            case .multiple:
                let pickWallet = AccountPickerViewController()
                pickWallet.assetID = TOPConstants.erc20TOP_AssetID
                pickWallet.modalPresentationStyle = .custom
                present(pickWallet, animated: false, completion: nil)
                pickWallet.selectWallet = { [unowned self] wallet in
                    WebMannager.showDappWithUrl(url: TOPConstants.topStakingURL, wallet: self.viewModel.getETHWalletWith(topTokenWallet: wallet), controller: self)
                }
            }
        }
    }

    @objc
    private func changeStakingState(_ notification: Notification) {
        needStakingLayout = true
        isShowStakingView = Preference.stakingSwitch
        updateTableviewHeaderHeight()
    }

    @objc
    private func updateTableviewHeaderHeight() {
        if !needStakingLayout { return }

        needStakingLayout = false
        let frame = headerView.frame
        var _offsetHeight: CGFloat = 38

        if let isShowStakingView = self.isShowStakingView {
            if isShowStakingView {
                headerView.stakingHeight.constant = App.UIConstant.walletMainStakingViewHeight
                _offsetHeight = 0
            } else {
                headerView.stakingHeight.constant = 0
            }
        } else {
            headerView.stakingHeight.constant = 0
        }
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: App.UIConstant.walletMainHeaderHeight - _offsetHeight)
        headerView.frame = rect
    }
}

// MARK: - UI display handle

extension WalletMainViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if scrollView == tableview {
            if y < 0 {
                var rect = scrollView.frame
                rect.size.height = statusHeight + abs(y)
                bouncesView.frame = rect
            }
        }

        if scrollView.contentOffset.y >= 20 {
            if isAnimating || (fakeNavigationBar.alpha == 1.0) { return }
            fakeNavigationBar.alpha = ((scrollView.contentOffset.y - 20) / 100)
            UIView.animate(withDuration: 0.25, animations: {
                self.isAnimating = true
                self.fakeNavigationBar.alpha = 1.0
            }, completion: { _ in
                self.isAnimating = false
            })
        } else {
            fakeNavigationBar.alpha = 0
            isAnimating = false
        }
    }
}

// MARK: - tableview delegate and datasource

extension WalletMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "AssetTypeInfoCell") as! AssetTypeInfoCell
        cell.setupWith(wallets: datalist![indexPath.row], hiddenNum: hiddenNum)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = AssetCardViewController.loadFromWalletStoryboard()
//        controller.assetID = datalist![indexPath.row][0].asset.assetID
//        navigationController?.pushViewController(controller, animated: true)
        
        let controller = TestViewController()
        controller.viewModel = AssetCardViewModel(assetID: datalist![indexPath.row][0].asset.assetID)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension WalletMainViewController {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.isEqual(self), animated: true)
    }
}
