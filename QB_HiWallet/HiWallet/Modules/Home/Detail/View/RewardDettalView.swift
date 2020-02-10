//
//  RewardDettalView.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/6.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit
import SnapKit

protocol RewardDetailViewDelegate: class {
    func didSelectedSegment(segmentIndex index: Int)
    func didSelectForCash()
}

class RewardDetailView: UIView {
    weak var actionDelegate: RewardDetailViewDelegate?
    let balanceCard = RewardBalanceCard(frame: .zero)
    let tableView = UITableView()
    let loadingView = UIActivityIndicatorView.init(style: .gray)
    let segmentView = SegmentView.init(frame: .zero,
                                       itemTitles: ["全部".localized(),
                                                    "收入".localized(),
                                                    "支出".localized()])
    
    var currentBalance: String = "" {
        didSet {
            balanceCard.amountLabel.text = currentBalance
        }
    }
    
    var accumulateBalance: String = "" {
        didSet {
            balanceCard.accumulateAmountLabel.text = accumulateBalance
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(balanceCard)
        addSubview(segmentView)
        addSubview(tableView)
        addSubview(loadingView)
        
        loadingView.hidesWhenStopped = true
        tableView.tableFooterView = UIView()
        segmentView.delegate = self
        balanceCard.cashLabel.bk_(whenTapped: { [weak self] in
            self?.actionDelegate?.didSelectForCash()
        })
    }
    
    @objc
    private func segmentAction(_ control: UISegmentedControl) {
        actionDelegate?.didSelectedSegment(segmentIndex: control.selectedSegmentIndex)
        DLog("this is segment control \(control.selectedSegmentIndex)")
    }
    
    private func layout() {
        balanceCard.snp.makeConstraints {
            $0.top.equalTo(18)
            $0.height.equalTo(138)
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
        }
        
        segmentView.snp.makeConstraints {
            $0.top.equalTo(balanceCard.snp.bottom).offset(23)
            $0.height.equalTo(32)
            $0.left.equalTo(10)
            $0.width.greaterThanOrEqualTo(150)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom).offset(3)
            $0.left.right.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalTo(tableView.snp.center)
            $0.width.height.equalTo(44)
        }
    }
}

extension RewardDetailView: SegmentViewDelegate {
    func segmentView(didSelect index: Int) {
        actionDelegate?.didSelectedSegment(segmentIndex: index)
    }
}
