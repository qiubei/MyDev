//
//  TxHistoryViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import LYEmptyView
import TOPCore
import UIKit

fileprivate let emptyViewHeight: CGFloat = 108
class TxHistoryViewController: BaseViewController {
    var currentWallet: ViewWalletInterface!

    private let identifier = "asset_tx_id"
    private let historyPresenter = TransactionHistoryPresenter()
    private var isLoadingData = false //是否正在加载数据
    private var pageNum = 1 //分页

    private let lodingView = UIActivityIndicatorView(style: .gray)
    private let tableview = UITableView(frame: .zero, style: .grouped)


    override func viewDidLoad() {
        super.viewDidLoad()
        // 这种方式需要改进
        title = "交易记录".localized()
        historyPresenter.currentWallet = currentWallet
        historyPresenter.delegate = self

        reloadData()
    }

    override func setup() {
        super.setup()
        let nib = UINib(nibName: "AssetTranscationCellXIB", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: identifier)
        tableview.register(HistoryTitleView.self, forHeaderFooterViewReuseIdentifier: "historyTitleView")
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.delegate = self
        tableview.refreshControl = UIRefreshControl()
        tableview.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)

        view.addSubview(tableview)
        view.addSubview(lodingView)
        lodingView.hidesWhenStopped = true
        lodingView.center = view.center
    }

    override func layout() {
        super.layout()
        tableview.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }

    @objc
    private func reloadData() {
        pageNum = 1

        TOPNetworkManager<ETHServices, Any>.cancelAllRequest()
        TOPNetworkManager<BTCServices, Any>.cancelAllRequest()
        loadHistory()
    }
}

extension TxHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyPresenter.txHistoryViewModelList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyPresenter.txHistoryViewModelList[section].transactionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: identifier) as! AssetTranscationCell
        let txModel = historyPresenter.txHistoryViewModelList[indexPath.section].transactionList[indexPath.row]
        cell.setUpWith(tx: txModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return historyPresenter.txHistoryViewModelList.count == 2 ? 50 : 0
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        view.tintAdjustmentMode = .dimmed
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let txModel = historyPresenter.txHistoryViewModelList[indexPath.section].transactionList[indexPath.row]
        let txDetailController = TransactionDetailController.loadFromWalletStoryboard()
        txDetailController.txModel = txModel
        navigationController?.pushViewController(txDetailController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if historyPresenter.txHistoryViewModelList.count == 1 {
            return nil
        }
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "historyTitleView") as! HistoryTitleView
        headView.title =  historyPresenter.txHistoryViewModelList[section].titile
        return headView
    }

    //加载更多
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = historyPresenter.txHistoryViewModelList.last?.transactionList.count ?? 0
        if indexPath.row == row - 2 && !isLoadingData {
            pageNum += 1
            loadHistory()
        }
    }

    private func loadHistory() {
        isLoadingData = true

        if historyPresenter.isFinish && pageNum != 1 {
            lodingView.stopAnimating()
            tableview.refreshControl?.endRefreshing()
            isLoadingData = false
            return
        }

        if !tableview.refreshControl!.isRefreshing && pageNum == 1 {
            lodingView.startAnimating()
        }

        //获取历史纪录
        historyPresenter.getHistory(page: pageNum, success: { [weak self] in
            self?.lodingView.stopAnimating()
            self?.tableview.refreshControl?.endRefreshing()
            self?.tableview.ly_emptyView = LYEmptyView.empty(with: UIImage(named: "noData_icon"), titleStr: "无历史记录".localized(), detailStr: "")
            self?.tableview.ly_emptyView.contentViewOffset = -(navigationHeight + emptyViewHeight) / 2
            self?.tableview.reloadData()
            self?.isLoadingData = false

        }, failure: { [weak self] error in
            // Cancel request handler
            if error.code != 6 {
                Toast.showToast(text: error.message)
            }
            self?.lodingView.stopAnimating()
            self?.tableview.refreshControl?.endRefreshing()
            self?.tableview.ly_emptyView = LYEmptyView.empty(with: UIImage(named: "noData_icon"), titleStr: "无历史记录".localized(), detailStr: "")
            self?.tableview.ly_emptyView.contentViewOffset = -(navigationHeight + emptyViewHeight) / 2
        })
    }
}

extension TxHistoryViewController: TransactionHistoryPresenterDelegate {
    func reloadTransactionHistor() {
        tableview.reloadData()
    }
}
