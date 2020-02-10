//
//  AssetCardViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore
import CoreGraphics

enum BalanceError: Error {
    case requestFailed
}

class AssetCardViewModel {
    var walletList: [ViewWalletInterface] = []
    var currentWallet: ViewWalletInterface!
    var selectedIndex: Int = 0
    
    private let assetID: String
    
    init(assetID: String) {
        self.assetID = assetID
        
        self.walletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        if let wallet = walletList.first {
            currentWallet = wallet
        }
    }
    
    var isShowStakingFlag: Bool {
        return (Preference.stakingSwitch ?? false) && assetID == TOPConstants.erc20TOP_AssetID
    }
    
    /// 获取正在交易中的交易数据条数：只有在请求成功后计算，并且只获取第一页的内容进行计算。
    func getPendingTxCount(callback: @escaping ActionBlock<Int>) {
        var transcationList: [HistoryTxModel] = []
        (inject() as WalletBlockchainWrapperInteractorInterface).getTxHistoryByWallet(currentWallet, pageNum: 1, transactions: { result in
            transcationList += result
            callback(self.getPendingList(txList: transcationList).count)
        }, failure: { error in
            callback(self.getPendingList(txList: transcationList).count)
        })
    }
    
    private func getPendingList(txList: [HistoryTxModel]) -> [HistoryTxModel] {
        checkLocalTx(transcationList: txList)
        var transcationList: [HistoryTxModel] = txList
        // append local cache
        let list = LocalTxPool.pool.getTransactions(wallet: self.currentWallet).sorted { $0.date < $1.date }
        transcationList += list
        var apendingList: [HistoryTxModel] = []
        for tx in transcationList {
            if tx.status == .pending || tx.status == .unconfirmed {
                if !apendingList.contains(where: {  tx.txhash.uppercased() == $0.txhash.uppercased() }) {
                    apendingList.append(tx)
                }
            }
        }
        
        return apendingList
    }
    
    private func checkLocalTx(transcationList: [HistoryTxModel]) {
        var list = LocalTxPool.pool.getTransactions(wallet: currentWallet!).sorted { $0.date < $1.date }
        //去重,筛选不在第一页的本地记录，重复的从数据库删除
        for model in transcationList {
            if list.count >= 1 {
                for index in 0 ... list.count - 1 {
                    if list[index].txhash.uppercased() == model.txhash.uppercased() {
                        let txHash = list[index].txhash
                        DispatchQueue.global().async {
                            LocalTxPool.pool.remove(hash: txHash)
                        }
                        list.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
    /// TODO: 更新余额: 更新失败显示的 余额 有问题
    func refreshCurrentWalletBalance(callback: @escaping ActionBlock<ViewWalletInterface>){
        if currentWallet.isMainCoin {
            (inject() as WalletBlockchainWrapperInteractorInterface).getCoinBalance(for: ChainType.getTypeWithSymbol(symbol: currentWallet.symbol), address: currentWallet.address, balance: { balance in
                (inject() as UserStorageServiceInterface).update({ _ in
                    self.currentWallet.lastBalance = balance
                    callback(self.currentWallet)
                })
            }, failure: {
                // 余额更新失败的话读取本地钱包的内容
                callback(self.currentWallet)
            })
            
        } else {
            let token = currentWallet?.asset as! Token
            (inject() as WalletBlockchainWrapperInteractorInterface).getTokenBalance(for: token, address: currentWallet.address, balance: { balance in
                (inject() as UserStorageServiceInterface).update({ _ in
                    self.currentWallet.lastBalance = balance
                    callback(self.currentWallet)
                })
            }, failure: {
                // 余额更新失败的话读取本地钱包的内容
                callback(self.currentWallet)
            })
        }
    }
    
    /// 更新选中钱包，并返回给业务层
    func switchAssetCard(didSelect index: Int, callback: () -> ()){
        if index >= walletList.count { return }
        currentWallet = walletList[index]
        selectedIndex = index
        callback()
    }

    func updateWallet(callback: () -> ()) {
        walletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        currentWallet = walletList[selectedIndex]
        callback()
    }
    
    /// 添加钱包要更新钱包集合
    func addWallet(callback: () -> ()) {
        walletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        selectedIndex = walletList.count - 1
        currentWallet = walletList[selectedIndex]
        
        PushManager.shared.uploadWallets(assets: [currentWallet])
        callback()
    }

    /// 删除钱包要更新钱包集合
    func deleteWallet(callback: () -> ()) {
        walletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        selectedIndex = 0
        currentWallet = walletList[selectedIndex]
        callback()
    }
    
    //MARK: - Caculate scroll content height
    
    private let marginCardEdge: CGFloat = 16
    private let marginBetweenCards: CGFloat = 16
    private let addCardHeight: CGFloat = 79
    private let addViewHeight: CGFloat = 59
    private var bottomOffset: CGFloat {
        return bottomMarginValue + 64 + 48
    }
     private var cardHeight: CGFloat {
        return (screenWidth - 2 * marginCardEdge) * 170.0 / 343
    }
    var bottomMarginValue: CGFloat = statusHeight > 20 ? 30 : 0
    var scrollviewContentHeight: CGFloat {
        var height: CGFloat = 0
        switch walletList.count {
        case 1:
            height = cardHeight + addViewHeight + bottomOffset
        case 2:
            height = (cardHeight + marginBetweenCards) * 2 + addCardHeight + bottomOffset
        case 3:
            height = (cardHeight + marginBetweenCards) * 3 + bottomOffset
        default: break
        }
        
        if height > (screenHeight - navigationHeight - bottomMarginValue - 4) {
            return height
        }
        return screenHeight - navigationHeight - bottomMarginValue - 4
    }
}
