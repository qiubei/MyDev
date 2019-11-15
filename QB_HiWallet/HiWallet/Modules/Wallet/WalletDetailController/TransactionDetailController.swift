//
//  NewTransactionDetailController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import EssentiaBridgesApi
import HDWalletKit
import SafariServices
import TOPCore
import UIKit

fileprivate struct CellModel {
    var title: String
    var detail: String
    var image: UIImage?
}

class TransactionDetailController: BaseViewController {
    @IBOutlet var tableview: UITableView!
    @IBOutlet var stateImageview: UIImageView!
    @IBOutlet var txTypeLabel: UILabel!
    @IBOutlet var txDateLabel: UILabel!
    @IBOutlet var tableviewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet var moreDetailButton: UIButton!
    @IBAction func moreDetailAction(_ sender: UIButton) {
        WebMannager.showInSafariWithUrl(url: viewModel.detailURL, controller: self)
    }

    var txModel: HistoryTxModel!
    private var viewModel: TransactionDetailViewModel!
    private var datalist: [CellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = App.Color.settingBG
        viewModel = TransactionDetailViewModel(historyModel: txModel)
        setData()
    }

    private func setData() {
        moreDetailButton.setTitle("去浏览器查看详情".localized() + " >", for: .normal)
        tableview.isScrollEnabled = false
        txDateLabel.text = viewModel?.time
        txTypeLabel.text = viewModel?.statusDesc.localized()
        stateImageview.image = UIImage(named: viewModel!.statusImageName)

        let amountMoel = CellModel(title: "金额".localized(), detail: String(viewModel.ammount.string.dropFirst()), image: nil)
        let gasModel = CellModel(title: "手续费".localized(), detail: viewModel.fee, image: nil)
        let sendTitle = viewModel.isSend ? "对方账户".localized() : "发送到".localized()
        let sendModel = CellModel(title: sendTitle, detail: viewModel.otherAddress, image: #imageLiteral(resourceName: "icon_copy"))
        let hashModel = CellModel(title: "交易号".localized(), detail: viewModel.txID, image: #imageLiteral(resourceName: "icon_copy"))
        datalist.append(amountMoel)
        datalist.append(gasModel)
        datalist.append(sendModel)
        datalist.append(hashModel)
        if let note = viewModel.note {
            let noteModel = CellModel(title: "备注tx".localized(), detail: String(data: note.hexStringToData(), encoding: .utf8) ?? "", image: nil)
            datalist.append(noteModel)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableviewHeigthConstraint.constant = CGFloat(datalist.count * 62 + 130)
    }
}

extension TransactionDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCellID") as! TransactionDetailCell
        cell.selectionStyle = .none
        let model = datalist[indexPath.row]
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = model.detail
        if let image = model.image {
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            cell.accessoryView = UIImageView(image: image).then {
                $0.frame = CGRect(x: 0, y: 0, width: 30, height: 18)
                $0.contentMode = .right
            }
        }

        if indexPath.row == datalist.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = datalist[indexPath.row]
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
