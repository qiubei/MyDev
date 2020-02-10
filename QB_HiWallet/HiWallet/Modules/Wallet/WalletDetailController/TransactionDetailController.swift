//
//  NewTransactionDetailController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import EssentiaBridgesApi

import SafariServices
import TOPCore
import UIKit


class TransactionDetailController: BaseViewController {
    @IBOutlet var tableview: UITableView!
    @IBOutlet var stateImageview: UIImageView!
    @IBOutlet var txTypeLabel: UILabel!
    @IBOutlet var txDateLabel: UILabel!
    @IBOutlet var moreDetailButton: UIButton!
    @IBAction func moreDetailAction(_ sender: UIButton) {
        WebMannager.showWebViewWithUrl(url: viewModel.detailURL, controller: self)
    }

    var txModel: HistoryTxModel!
    private var viewModel: TransactionDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "交易详情".localized()
        viewModel = TransactionDetailViewModel(historyModel: txModel)
        setData()
    }

    private func setData() {
        moreDetailButton.setTitle("去浏览器查看详情".localized(), for: .normal)
        moreDetailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        txDateLabel.text = viewModel?.time
        txTypeLabel.text = viewModel?.statusDesc.localized()
        stateImageview.image = UIImage(named: viewModel!.statusImageName)
        
    }
}

extension TransactionDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datalist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCellID") as! TransactionDetailCell
        let model = viewModel.datalist[indexPath.row]
        cell.selectionStyle = .none
        cell.setupCell(cellModel: model)
        cell.hiddenSparator(isHidden: false)
        
        if indexPath.row == viewModel.datalist.count - 1 {
            cell.hiddenSparator(isHidden: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.datalist[indexPath.row]
        if model.title == "发送到".localized() || model.title == "对方账户".localized() {
            UIPasteboard.general.string = model.detail
            Toast.showToast(text: "复制成功".localized())
        }

        if model.title == "交易号".localized() {
            UIPasteboard.general.string = model.detail
            Toast.showToast(text: "复制成功".localized())
        }
    }
}
