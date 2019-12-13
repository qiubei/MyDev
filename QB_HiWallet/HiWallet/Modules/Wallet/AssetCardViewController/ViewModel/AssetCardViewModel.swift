//
//  AssetCardViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

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
    
    /// 获取正在交易中的交易数据条数：只有在请求成功后计算，并且只获取第一页的内容进行计算。
    func getPendingTxCount(callback: @escaping (Result<Int, Error>) -> ()) {
        var transcationList: [HistoryTxModel] = []
        (inject() as WalletBlockchainWrapperInteractorInterface).getTxHistoryByWallet(currentWallet, pageNum: 1, transactions: { result in
            transcationList = result
            // append local cache
            let list = LocalTxPool.pool.getTransactions(wallet: self.currentWallet).sorted { $0.date < $1.date }
            transcationList += list
            
            // remove repeat tx
            var apendingList: [HistoryTxModel] = []
            for tx in transcationList {
                if tx.status == .pending || tx.status == .unconfirmed {
                    if !apendingList.contains(where: {  tx.txhash.uppercased() == $0.txhash.uppercased() }) {
                        apendingList.append(tx)
                    }
                }
            }
            callback(.success(apendingList.count))
        }, failure: { error in
            callback(.failure(error))
        })
    }
    
    /// 更新余额:
    func refreshCurrentWalletBalance(callback: @escaping (Result<ViewWalletInterface, Error>) -> ()) {
        if currentWallet.isMainCoin {
            (inject() as WalletBlockchainWrapperInteractorInterface).getCoinBalance(for: ChainType.getTypeWithSymbol(symbol: currentWallet.symbol), address: currentWallet.address, balance: { balance in
                (inject() as UserStorageServiceInterface).update({ _ in
                    self.currentWallet.lastBalance = balance
                    callback(.success(self.currentWallet))
                })
            }, failure: {
                callback(.failure(BalanceError.requestFailed))
            })
            
        } else {
            let token = currentWallet?.asset as! Token
            (inject() as WalletBlockchainWrapperInteractorInterface).getTokenBalance(for: token, address: currentWallet.address, balance: { balance in
                (inject() as UserStorageServiceInterface).update({ _ in
                    self.currentWallet.lastBalance = balance
                    callback(.success(self.currentWallet))
                })
            }, failure: {
                callback(.failure(BalanceError.requestFailed))
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
        reloadData()
        callback()
    }

    /// 删除钱包要更新钱包集合
    func deleteWallet(callback: () -> ()) {
        reloadData()
        callback()
    }
    
    /// 重新从数据库缓存中加载数据
    private func reloadData() {
        walletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        selectedIndex = walletList.count - 1
        currentWallet = walletList[selectedIndex]
    }
}
