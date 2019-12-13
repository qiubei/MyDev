//
//  TransactionHistoryPresenter.swift
//  HiWallet
//
//  Created by Jax on 2019/11/8.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

protocol TransactionHistoryPresenterDelegate: NSObjectProtocol {
    func reloadTransactionHistor()
}

class TransactionHistoryPresenter: NSObject {
    var currentWallet: ViewWalletInterface?
    var transcationList: [HistoryTxModel] = []
    var txHistoryViewModelList: [TransactionListViewModel] = []
    var isFinish = false //数据是否已经加载完成
    var pageNum = 1 //

    weak var delegate: TransactionHistoryPresenterDelegate?

    override init() {
        let defautViewModel = TransactionListViewModel(titile: "交易记录".localized(), transactionList: [])
        txHistoryViewModelList.append(defautViewModel)
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddLocalTxAction(notification:)), name: LocalTxPool.didAddLocalTx, object: nil)
    }

    @objc func didAddLocalTxAction(notification: Notification) {
        guard let transaction = notification.userInfo![LocalTxPool.txKey] as? HistoryTxModel else { return }
        guard transaction.myAddress == currentWallet?.address else { return }
        transcationList.insert(transaction, at: 0)
        createViewModel()
        delegate?.reloadTransactionHistor()
    }

    func getHistory(page: NSInteger, success: @escaping () -> Void, failure: @escaping (TOPHttpError) -> Void) {
        (inject() as WalletBlockchainWrapperInteractorInterface).getTxHistoryByWallet(currentWallet!, pageNum: page, transactions: { result in
            // 所有数据
            if page == 1 {
                self.transcationList = result
                self.isFinish = false
                self.checkLocalTx()

            } else {
                if result.count == 0 {
                    self.isFinish = true
                    success()
                    return
                } else {
                    self.transcationList = self.transcationList + result
                    self.isFinish = false
                }
            }

            self.createViewModel()
            success()

        }, failure: { error in
            self.isFinish = true
            failure(error)
        })
    }

    private func checkLocalTx() {
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

        transcationList += list
    }

    private func createViewModel() {
        txHistoryViewModelList.removeAll()
        // pending数据
        let processingTxList = transcationList.filter {
            $0.status == .pending
        }

        let unconfirmedTxList = transcationList.filter {
            $0.status == .unconfirmed
        }

        let processingTx = processingTxList + unconfirmedTxList
        if !processingTx.isEmpty {
            let viewModel = TransactionListViewModel(titile: "正在处理".localized(), transactionList: processingTx)
            txHistoryViewModelList.append(viewModel)
        }
        // 完成的交易
        let finishTxList = transcationList.filter {
            $0.status != .pending && $0.status != .unconfirmed
        }
        if !finishTxList.isEmpty {
            let viewModel = TransactionListViewModel(titile: "交易记录".localized(), transactionList: finishTxList)
            txHistoryViewModelList.append(viewModel)
        }
        // 都没有
        if processingTxList.isEmpty && finishTxList.isEmpty {
            let viewModel = TransactionListViewModel(titile: "交易记录".localized(), transactionList: [])
            txHistoryViewModelList.append(viewModel)
        }
    }
}
