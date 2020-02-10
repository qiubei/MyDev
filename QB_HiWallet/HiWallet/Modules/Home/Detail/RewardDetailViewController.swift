//
//  RewardDetailViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit
import LYEmptyView

class RewardDetailViewController: BaseViewController {
    
    private var pageNum = 1
    private var isLoadingData = false
    private let cell_id = "reward_detail_cell_id"
    private let emptyViewHeight: CGFloat = 108
    private lazy var emptyViewPosition: CGFloat = (statusHeight + emptyViewHeight) / 2
    private let emptyView = LYEmptyView.empty(with: UIImage(named: "noData_icon"),
                                              titleStr: "暂无内容".localized(),
                                              detailStr: "")
    
    let viewModel = RewardDetailViewModel()
    let _view = RewardDetailView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "领取明细".localized()
        
        view.addSubview(_view)
        _view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
        loadBalanceData()
        loadDetailList(scrollToTop: false, index: viewModel.selectedSegmentIndex)
    }
    
    override func setup() {
        super.setup()
        
        _view.actionDelegate = self
        _view.tableView.dataSource = self
        _view.tableView.delegate = self
        _view.tableView.register(RewardDetailCell.self, forCellReuseIdentifier: cell_id)
    }
    
    private func loadBalanceData() {
        viewModel.loadBalance { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: break
            case let .failure(flag):
                if flag {
                    Toast.showToast(text: "出了点小问题，请重试".localized())
                }
            }
            self._view.currentBalance = self.viewModel.rewardBalance.balance
            self._view.accumulateBalance = self.viewModel.rewardBalance.accumulate
        }
    }
    
    private func loadDetailList(scrollToTop: Bool, index: Int) {
        _view.isUserInteractionEnabled = false
        _view.loadingView.startAnimating()
        viewModel.loadData(pageIndex: pageNum, segmentIndex: index) { [weak self] result in
            guard let self = self else { return }
            
            if self._view.tableView.ly_emptyView == nil {
                self._view.tableView.ly_emptyView = self.emptyView
                self._view.tableView.ly_emptyView.contentViewOffset = -self.emptyViewPosition
            }
            
            switch result {
            case .success: break
            case let .failure(flag):
                if flag {
                    Toast.showToast(text: "出了点小问题，请重试".localized())
                }
            }
            self.isLoadingData = false
            self._view.tableView.reloadData()
            self._view.loadingView.stopAnimating()
            self._view.isUserInteractionEnabled = true
            if self.viewModel.datalist.isEmpty { return }
            
            if scrollToTop {
                self._view.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
    }
}

//MARK: - RewardDetailViewDelegate

extension RewardDetailViewController: RewardDetailViewDelegate {
    func didSelectedSegment(segmentIndex index: Int) {
        pageNum = 1
        loadDetailList(scrollToTop: true, index: index)
    }  
    
    func didSelectForCash() {
        //TODO: TO BE CONTINUE
    }
}

//MARK: - tableview delegate and datasource

extension RewardDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_id) as! RewardDetailCell
        cell.selectionStyle = .none
        let model = viewModel.datalist[indexPath.row]
        cell.setup(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.isEndOfPageIndex { return }
        if indexPath.row == viewModel.datalist.count - 2, !isLoadingData {
            isLoadingData = true
            pageNum += 1
            loadDetailList(scrollToTop: false, index: viewModel.selectedSegmentIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0 * App.widthRatio
    }
}

//MARK: - RewardDetailCell
extension RewardDetailCell {
    func setup(model: RewardDetail) {
        titleLabel.text = model.text
        dateLabel.text = model.dateStr
        amountLabel.attributedText = model.detail
    }
}
