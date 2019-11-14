//
//  AssetTranscationCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore

class AssetTranscationCell: UITableViewCell {
    @IBOutlet weak var iconview: UIImageView!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}

extension AssetTranscationCell {
    func setUpWith(tx: ViewTransaction) {
        switch tx.status {
        case .success:
            switch tx.type {
            case TransactionType.send:
                self.operationLabel.text = "出账".localized()
                self.iconview.image =  #imageLiteral(resourceName: "icon_tx_send")
            case TransactionType.recive:
                self.operationLabel.text = "入账".localized()
                self.iconview.image =  #imageLiteral(resourceName: "icon_tx_receive")
            default:
                break
            }
        case .pending:
            switch tx.type {
            case TransactionType.send:
                self.operationLabel.text = "正在发送中".localized()
                self.iconview.image =  #imageLiteral(resourceName: "icon_tx_send")
            case TransactionType.recive:
                self.operationLabel.text = "正在接收中".localized()
                self.iconview.image =  #imageLiteral(resourceName: "icon_tx_receive")
            default:
                break
            }
        default:
            self.operationLabel.text = "发送失败".localized()
            self.iconview.image =  #imageLiteral(resourceName: "icon_tx_failed")
        }
        
        dateLabel.text = tx.stringDate
        
        amountLabel.attributedText = tx.ammount
    }
}
