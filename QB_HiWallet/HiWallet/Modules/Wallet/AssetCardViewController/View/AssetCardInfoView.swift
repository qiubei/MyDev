//
//  AssetCardInfoView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

private let cardRatio: CGFloat = 170.0/343
private let cardWidth: CGFloat = screenWidth - 32

protocol AssetCardInfoDelegate: class {
    func assetCardInfoCell(infoView: AssetCardInfoView, didSelect index: IndexPath)
}

class AssetCardInfoView: UIView {
    private let tableview = UITableView(frame: .zero, style: .grouped)
    private let datalist = [("发送".localized(), UIImage.init(named: "icon_asset_send")),
                            ("接收".localized(), UIImage.init(named: "icon_asset_receive")),
                            ("交易记录".localized(), UIImage.init(named: "icon_tx_history")),
                            ("管理".localized(), UIImage.init(named: "icon_asset_manage"))]
    
    weak var delegate: AssetCardInfoDelegate?
    let card: AssetCard = AssetCard(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardWidth * cardRatio)).then {
        $0.enableCopyAction(true)
    }
    
    var pendingTxNubmer = 0 {
        didSet {
            if pendingTxNubmer == 0 {
                numberView.isHidden = true
            } else {
                numberView.isHidden = false
                numberView.number = pendingTxNubmer
            }
        }
    }
    
    private var numberView = NumberView().then {
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableview.backgroundColor = .white
        tableview.separatorStyle = .none
    }
    
    private func setup() {
        addSubview(tableview)
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: card.bounds.height + 20))
        headerview.addSubview(card)
        headerview.backgroundColor = .clear
        card.center = headerview.center
        tableview.tableHeaderView = headerview
        tableview.register(LocalTableviewCell.self, forCellReuseIdentifier: "cell_reuse_id")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    private func layout() {
        tableview.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - refresh handle
    
    private var refreshHandleBlock: EmptyAction?
    /// 添加刷新
    func addRefreshControl(refreshHandleBlock: @escaping EmptyAction) {
        self.refreshHandleBlock = refreshHandleBlock
        tableview.refreshControl = UIRefreshControl().then {
            $0.addTarget(self, action: #selector(self.refreshAction), for: .valueChanged)
        }
    }
    
    /// 停止刷新
    func stopRefreshing() {
        tableview.refreshControl?.endRefreshing()
    }
    
    @objc
    private func refreshAction() {
        refreshHandleBlock?()
    }
}

//MARK: - tableview delegate and datasoure methods

extension AssetCardInfoView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuse_id") as! LocalTableviewCell
        
        cell.selectionStyle = .none
        cell.titleLabel.text = datalist[indexPath.row].0
        cell.iconView.image = datalist[indexPath.row].1
        
        if indexPath.row == 2 {
            cell.rightView = numberView
        } else {
             cell.rightView = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.assetCardInfoCell(infoView: self, didSelect: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 * App.heightRatio
    }
}
