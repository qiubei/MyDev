//
//  WalletMainViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/11/14.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

enum UserState {
    case unregister
    case unLogin
    case logined
}

enum TopWalletNumberState {
    case none 
    case onlyOne(wallet: ViewWalletInterface)
    case multiple
}

class WalletMainViewModel {
    private lazy var userStorageInteractor: ViewUserStorageServiceInterface = inject()
    private lazy var interactor: WalletInteractorInterface = inject()
    private lazy var blockchainInteractor: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var currencyRankInteractor: CurrencyRankDaemonInterface = inject()

    var isBackup: Bool {
        return TOPStore.shared.currentUser.backup?.currentlyBackup?.isBackup ?? false
    }

    // setup with state of user
    func setupWithUserState(_ complete: ActionBlock<UserState>) {
        if userStorageInteractor.users.isEmpty {
            complete(.unregister)
            return
        }
        if App.isLogined {
            complete(.logined)
        } else {
            complete(.unLogin)
        }
    }

    /// 从磁盘缓存中那钱包数据，并回调给上一层。
    /// - Parameter completion: 数据回调操作
    func loadWalletInfoFromDB(_ completion: ActionBlock<(datalist: [[ViewWalletInterface]], totalBalance: String)>) {
        let list = interactor.getAllWalletGroup()
        let balanceString = formattedBalance(interactor.getTotalBalanceInCurrentCurrency())
        completion((list, balanceString))
    }

    // 给网络请求加一些保护
    private var isLoadingData = false

    /// 从网络上更新本地磁盘的资产数据（价格和余额），然后回调给上一层。
    /// - Parameter completion: 回调操作
    func updateAssetBalanceWithNetworkRank(_ completion: @escaping EmptyBlock) {
        if isLoadingData {
            DLog("请求进行中，取消刷新")
            return
        }
        isLoadingData = true

        let group = DispatchGroup()
        group.enter()
        currencyRankInteractor.update(callBack: {
            group.leave()
        })

        interactor.getGeneratedWallets().forEach { wallet in
            group.enter()
            blockchainInteractor.getCoinBalance(for: wallet.mainChainType, address: wallet.address, balance: { balance in

                (inject() as UserStorageServiceInterface).update({ _ in
                    wallet.lastBalance = balance
                })
                group.leave()
            }, failure: {
                group.leave()
            })
        }

        interactor.getTokenWallets().forEach { tokenWallet in
            group.enter()
            blockchainInteractor.getTokenBalance(for: tokenWallet.token!, address: tokenWallet.address, balance: { balance in
                group.leave()
                (inject() as UserStorageServiceInterface).update({ _ in
                    tokenWallet.lastBalance = balance
                })
            }, failure: {
                group.leave()
            })
        }

        group.notify(queue: DispatchQueue.main) {
            self.isLoadingData = false
            completion()
        }
    }

    /// 获取本地所有打开钱包的余额的总数
    func getTotalBalance() -> String {
        return formattedBalance(interactor.getTotalBalanceInCurrentCurrency())
    }

    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: TOPStore.shared.currentUser.profile?.currency ?? .cny)
        return formatter.formattedAmmountWithSymbol(amount: balance)
    }

    /// 根据回调中不同的 top 钱包个数做不同 UI 业务处理。
    /// - Parameter complete: 回调给 top 钱包个数状态
    func handleOpenStakingWith(_ complete: ActionBlock<TopWalletNumberState>) {
        let topWallets = interactor.getERC20TOPTokenWallet()
        if topWallets.count == 0 { complete(.none) }
        if topWallets.count == 1 { complete(.onlyOne(wallet: topWallets.first!)) }
        if topWallets.count > 1 { complete(.multiple) }
    }

    /// 根据 top 的 TokenWallet 生成返回 Eth 的主币钱包
    /// - Parameter topTokenWallet: top token 钱包
    func getETHWalletWith(topTokenWallet: ViewWalletInterface) -> ViewWalletInterface {
        let ethWallet = interactor.createTempEthWallet(privateKey: topTokenWallet.privateKey, address: topTokenWallet.address)
        return ethWallet
    }

    /// 打开或者生成一个 Top 钱包（需要用户更新数据状态）
    func openERC20TOPTokenWallet() {
        return interactor.openERC20TOPTokenWallet()
    }
}
