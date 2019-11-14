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
        WebMannager.showInSafariWithUrl(url: detailURL!, controller: self)
    }

    //TODO: 这个参数有什么用？
    var transationModel: Any!
    var viewTransaction: ViewTransaction!
    var wallet: ViewWalletInterface!

    private var detailURL: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = App.Color.settingBG
        loadData()
    }

    override func setup() {
        super.setup()
        moreDetailButton.setTitle("去浏览器查看详情".localized() + " >", for: .normal)
        tableview.isScrollEnabled = false
        txDateLabel.text = Date(timeIntervalSince1970: viewTransaction.date).string(custom: "yyyy/MM/dd HH:mm:ss")
        switch viewTransaction.status {
        case .success:
            stateImageview.image = #imageLiteral(resourceName: "icon_tx_state_success")
            if viewTransaction.type == .recive {
                txTypeLabel.text = "入账成功".localized()
            } else {
                txTypeLabel.text = "出账成功".localized()
            }
        case .pending:
            stateImageview.image = #imageLiteral(resourceName: "icon_tx_state_process")
            if viewTransaction.type == .recive {
                txTypeLabel.text = "正在接收中".localized()
            } else {
                txTypeLabel.text = "正在发送中".localized()
            }
        case .failure:
            stateImageview.image = #imageLiteral(resourceName: "icon_tx_state_failed")
            txTypeLabel.text = "发送失败".localized()
        }
    }

    private var datalist: [CellModel] = []
    private func dataListSetup() {
        let toAddress = viewTransaction.address
        let amountMoel = CellModel(title: "金额".localized(), detail: String(viewTransaction.ammount.string.dropFirst()), image: nil)
        let gasModel = CellModel(title: "手续费".localized(), detail: "", image: nil)
        let sendTitle = viewTransaction?.type == .recive ? "对方账户".localized() : "发送到".localized()
        let sendModel = CellModel(title: sendTitle, detail: toAddress, image: #imageLiteral(resourceName: "icon_copy"))
        let hashModel = CellModel(title: "交易号".localized(), detail: viewTransaction.hash, image: #imageLiteral(resourceName: "icon_copy"))
        let noteModel = CellModel(title: "备注tx".localized(), detail: "".localized(), image: nil)
        datalist.append(amountMoel)
        datalist.append(gasModel)
        datalist.append(sendModel)
        datalist.append(hashModel)
        datalist.append(noteModel)
    }

    func loadData() {
        dataListSetup()

        switch wallet!.asset {
        case is Token:
            let detail = transationModel as! TOPEthereumTransactionDetail
            let gas = BInt(detail.gasPrice)! * BInt(detail.gasUsed)!
            let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(gas)")
            let num = NSDecimalNumber(string: String(format: "%.15f", gasValue))
            detailURL = "https://cn.etherscan.com/tx/" + detail.hash
            datalist[1].detail = "\(num)" + " ETH"
            datalist[2].detail = viewTransaction?.type == .recive ? detail.from : detail.to
            datalist.removeLast()
        case is MainCoin:
            switch MainCoin.getTypeWithSymbol(symbol: (wallet?.asset.symbol)!) {
            case .bitcoin:
                let detail = transationModel as! UtxoTransactionValue
                let fee = NSDecimalNumber(string: String(format: "%.15f", detail.fees!))
                detailURL = "https://www.blockchain.com/btc/tx/" + viewTransaction!.hash
                datalist[1].detail = "\(fee) BTC"
                datalist.removeLast()
            case .ethereum:
                let detail = transationModel as! EthereumTransactionDetail
                let gas = BInt(detail.gasPrice)! * BInt( detail.gasUsed)!
                let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(gas)")
                let num = NSDecimalNumber(string: String(format: "%.15f", gasValue))
                detailURL = "https://cn.etherscan.com/tx/" + detail.hash
                let noteString = String(data: detail.input.hexStringToData(), encoding: .utf8) ?? "".localized()
                datalist[1].detail = "\(num)" + " ETH"
                datalist[2].detail = viewTransaction?.type == .recive ? detail.from : detail.to
                datalist[4].detail = noteString

            default:
                break
            }

        default:
            break
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
