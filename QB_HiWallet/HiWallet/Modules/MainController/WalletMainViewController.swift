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
    @IBOutlet var backupTipView: GradientView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var backupLabel: UILabel!
    @IBOutlet var backupTipLabel: UILabel!
    @IBOutlet var headerView: WalletMainHeaderView!
    @IBOutlet var eyeButton: UIButton!
    
    @IBOutlet var stakingRoutwView: UIView!
    @IBOutlet var stakingTopInfoLabel: UILabel!
    @IBOutlet var stakingTopIncomeLabel: UILabel!
    @IBOutlet var stakingHeight: NSLayoutConstraint!
    
    private let fakeNavigationBar = GradientView(frame: .zero)
    private let bouncesView = UIView()
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    
    private lazy var interator: WalletInteractorInterface = inject()
    private lazy var blockchainInterator: WalletBlockchainWrapperInteractorInterface = inject()
    
    private var datalist: [[ViewWalletInterface]]?
    
    private var hiddenNum = false
    private var currentUser: User?
    private var isCheckVersion = false
    private var isAnimating = false
    
    override func localizedString() {
        stakingTopInfoLabel.text = "为 Top Network 节点投票，赚取高额收益".localized()
        stakingTopIncomeLabel.text = "赚收益".localized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.contentInset = UIEdgeInsets(top: statusHeight, left: 0, bottom: 0, right: 0)
        tableview.refreshControl = UIRefreshControl()
        tableview.refreshControl?.tintColor = UIColor.white
        tableview.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        stakingRoutwView.bk_(whenTapped: { [unowned self] in
            self.openDappStaking()
        })
        self.addEvents()
         
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isCheckVersion {
            checkUpdate()
        }
        
        reloadData()
        updateTableviewHeaderHeight()
    }
    
    
    private func openDappStaking() {
        let topWallets = interator.getERC20TOPTokenWallet()
        if topWallets.isEmpty {
            let alert = UIAlertController(title: "".localized(), message: "此投票 DApp 需要 TOP 账户，您可开启账户后继续投票".localized(), preferredStyle: .alert)
            let action = UIAlertAction(title: "开启并继续".localized(), style: .default, handler: { _ in
                self.interator.openERC20TOPTokenWallet()
                self.reloadData()
                self.openDappStaking()
                
            })
            let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in
                
            })
            alert.addAction(action)
            alert.addAction(cancal)
            
            present(alert, animated: true, completion: nil)
        } else {
            if topWallets.count == 1 {
                let ethWallet = interator.createTempEthWallet(privateKey: topWallets.first!.privateKey, address: topWallets.first!.address)
                WebMannager.showDappWithUrl(url: TOPConstants.topStakingURL, wallet: ethWallet, controller: self)
                
            } else {
                let pickWallet = AccountPickerViewController()
                pickWallet.assetID = "127"
                pickWallet.modalPresentationStyle = .custom
                present(pickWallet, animated: false, completion: nil)
                pickWallet.selectWallet = { [unowned self] wallet in
                    
                    let ethWallet = self.interator.createTempEthWallet(privateKey: wallet.privateKey, address: wallet.address)
                    WebMannager.showDappWithUrl(url: TOPConstants.topStakingURL, wallet: ethWallet, controller: self)
                }
            }
        }
    }

    override func setup() {
        navigationController?.delegate = self
        view.addBGGradient(colors: [#colorLiteral(red: 0.3215686275, green: 0.4274509804, blue: 0.9803921569, alpha: 1).cgColor, #colorLiteral(red: 0.2196078431, green: 0.6588235294, blue: 1, alpha: 1).cgColor])
        tableview.dataSource = self
        tableview.delegate = self
        titleLabel.text = "HiWallet".localized()
        
        setupViews()
        backupTipView.colors = [#colorLiteral(red: 0.4862745098, green: 0.6941176471, blue: 0.9725490196, alpha: 1).cgColor, #colorLiteral(red: 0.4823529412, green: 0.3921568627, blue: 0.9333333333, alpha: 1).cgColor]
        backupTipView.bk_(whenTapped: { [weak self] in
            let controller = BackupTipController.loadFromSettingStoryboard()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        headerView.assetLabel.isUserInteractionEnabled = true
        headerView.assetLabel.bk_(whenTapped: {
            self.hidhenOrShowAction(UIButton())
        })
        //        tableview.panGestureRecognizer.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var isShowStakingView: Bool? = Preference.stakingSwitch {
        didSet {
            self.updateTableviewHeaderHeight()
        }
    }
    private var isStakingLayout = false
    
    private func addEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStakingState(_:)), name: Notification.Name.init(NotificationConst.stakingSwitchEvent), object: nil)
    }
    
    
    @objc
    private func changeStakingState(_ notification: Notification) {
        isStakingLayout = false
        self.isShowStakingView = Preference.stakingSwitch
    }
    
    @objc
    private func updateTableviewHeaderHeight() {
        if isStakingLayout { return }
        
        isStakingLayout = true
        let frame = headerView.frame
        var _offsetHeight: CGFloat = 38
        
        if let isShowStakingView = self.isShowStakingView {
            if isShowStakingView {
                stakingHeight.constant = App.UIConstant.homePageStakingViewHeight
                _offsetHeight = 0
            } else {
                stakingHeight.constant = 0
            }
        } else {
            stakingHeight.constant = 0
        }
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: App.UIConstant.homePageTableViewHeaderHeight - _offsetHeight)
        headerView.frame = rect
    }
    
    private var isRankRequesting = false
    private func updateLocalRankRequestState(block: @escaping EmptyBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: block)
    }
}

extension WalletMainViewController {
    // 拉取余额和币价
    @objc func reloadData() {
        // 未登录,弹出引导页
        if (inject() as ViewUserStorageServiceInterface).users.isEmpty  {
            let guide = GuideViewController.loadFromWalletStoryboard()
            let nav = BaseNavigationController(rootViewController: guide)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
            return
        }
        
        if !App.isLogined {
            datalist?.removeAll()
            currentUser = nil
            tableview.reloadData()
            return
         }
        loadAsset()
        loadCoinData()
    }
    
    private func loadAsset() {
        currentUser = TOPStore.shared.currentUser
        // check current user is existed, if not stop refresh UI.
        if let isInvalidated = currentUser?.isInvalidated, isInvalidated {
            return
        }
        let isBackup = currentUser?.backup?.currentlyBackup?.isBackup ?? false
        backupTipView.isHidden = isBackup
        
        if !isBackup {
            tableview.contentInset = UIEdgeInsets(top: tableview.contentInset.top, left: 0, bottom: 80, right: 0)
        } else {
            tableview.contentInset = UIEdgeInsets(top: tableview.contentInset.top, left: 0, bottom: 0, right: 0)
        }
        
        datalist = interator.getAllWalletGroup()
        
        updateBalanceViews()
    }
    
    private func loadCoinData() {
        let group = DispatchGroup()
        
        if let count = self.datalist?.count, count > 8 {
            if !isRankRequesting {
                isRankRequesting = true
                self.updateLocalRankRequestState { [weak self] in
                    self?.isRankRequesting = false
                }
            } else {
                self.tableview.refreshControl?.endRefreshing()
                return
            }
        }
        
        group.enter()
        (inject() as CurrencyRankDaemonInterface).update(callBack: {
            self.tableview.reloadData()
            group.leave()
        })
        
        interator.getGeneratedWallets().forEach { wallet in
            
            group.enter()
            blockchainInterator.getCoinBalance(for: wallet.mainCoinType, address: wallet.address, balance: { balance in
                
                (inject() as UserStorageServiceInterface).update({ _ in
                    wallet.lastBalance = balance
                })
                group.leave()
            }, failure: {
                group.leave()
            })
        }
        
        interator.getTokenWallets().forEach { tokenWallet in
            
            group.enter()
            blockchainInterator.getTokenBalance(for: tokenWallet.token!, address: tokenWallet.address, balance: { balance in
                group.leave()
                (inject() as UserStorageServiceInterface).update({ _ in
                    tokenWallet.lastBalance = balance
                })
            }, failure: {
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableview.refreshControl?.endRefreshing()
            self.updateBalanceViews()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConst.balanceChanged), object: nil)
        }
    }
    
    private func updateBalanceViews() {
        tableview.reloadData()
        let balanceString = formattedBalance(interator.getTotalBalanceInCurrentCurrency())
        let attribteString = CryptoFormatter.balanceAttributeString(text: balanceString, currencyFont: UIFont.systemFont(ofSize: 26), amountFont: UIFont(name: "DIN Alternate", size: 36)!)
        headerView.balanceLabel.attributedText = hiddenNum ? NSAttributedString(string: "******") : attribteString
    }
}

// MARK: - Action

extension WalletMainViewController {
    @IBAction func hidhenOrShowAction(_ sender: UIButton) {
        hiddenNum = !hiddenNum
        eyeButton.isSelected = hiddenNum
        updateBalanceViews()
    }
    
    @IBAction func intoAssetManagerAction(_ sender: UIButton) {
        let controller = AssetManagementController.loadFromWalletStoryboard()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension WalletMainViewController {
    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: TOPStore.shared.currentUser.profile?.currency ?? .cny)
        return formatter.formattedAmmountWithSymbol(amount: balance)
    }
}

// MARK: - UI

extension WalletMainViewController {
    private func setupViews() {
        fakeNavigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-12)
            $0.width.greaterThanOrEqualTo(80)
            $0.height.equalTo(24)
        }
        view.addSubview(fakeNavigationBar)
        fakeNavigationBar.alpha = 0
        fakeNavigationBar.snp.remakeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(navigationHeight)
        }
        view.insertSubview(bouncesView, belowSubview: tableview)
        bouncesView.backgroundColor = .white
        bouncesView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(self.view.bounds.height * 0.75)
        }
        
        // localization
        backupLabel.text = "备份助记词".localized()
        backupTipLabel.text = "为提升账户安全性，请备份助记词。".localized()
    }
}

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
        let controller = AssetCardViewController.loadFromWalletStoryboard()
        controller.assetID = datalist![indexPath.row][0].asset.assetID
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension WalletMainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            bouncesView.snp.updateConstraints {
                $0.height.equalTo(abs(scrollView.contentOffset.y + self.view.bounds.height * 0.75))
            }
        } else {
            if abs(tableview.contentOffset.y) > (view.bounds.height * 0.25) {
                let offset = view.bounds.height - abs(tableview.contentOffset.y)
                bouncesView.snp.updateConstraints {
                    $0.height.equalTo(offset)
                }
            }
            
            if abs(tableview.contentOffset.y) < 60 {
                bouncesView.snp.updateConstraints {
                    $0.height.equalTo(self.view.bounds.height * 0.75)
                }
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

// MARK: - 检测更新

extension WalletMainViewController {
    func checkUpdate() {
        TOPNetworkManager<CommonServices, UpdateModel>.requestModel(.checkAppUpdate, success: { model in
            
            if model.hasUpdate == "0" {
                return
            }
            let alert = UIAlertController(title: "有新版本!".localized(), message: model.description, preferredStyle: .alert)
            let action = UIAlertAction(title: "去更新".localized(), style: .default, handler: { _ in
                WebMannager.showInSafariWithUrl(url: model.downloadUrl!, controller: self)
                self.isCheckVersion = (model.isForcedUpdates == 0)
                
            })
            let cancal = UIAlertAction(title: "取消".localized(), style: .cancel, handler: { _ in
                self.isCheckVersion = (model.isForcedUpdates == 0)
                
            })
            alert.addAction(action)
            if model.isForcedUpdates == 0 {
                alert.addAction(cancal)
            }
            self.present(alert, animated: true, completion: nil)
            
        }, failure: nil)
    }
    
    // MARK: - 获取 staking 的 h5 入口是否显示的开关
    
    private func getStakingSwitch() {
        TOPNetworkManager<CommonServices, StakingSwitchModel>.requestModel(.getStakingSwitch, success: { model in
            
            Preference.stakingSwitch = model.open
            self.isShowStakingView = Preference.stakingSwitch
            self.isStakingLayout = false
            
            self.updateTableviewHeaderHeight()
        }) { _ in
            DLog("get staking failed!!")
            self.isShowStakingView = false
            self.updateTableviewHeaderHeight()
        }
    }
}

extension WalletMainViewController {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.isEqual(self), animated: true)
    }
}
