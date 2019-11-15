//
//  AssetTranscationCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import UIKit

class AssetTranscationCell: UITableViewCell {
    @IBOutlet var iconview: UIImageView!
    @IBOutlet var operationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
}

extension AssetTranscationCell {
    func setUpWith(tx: HistoryTxModel) {
        let viewModel = HistoryListViewModel(historyModel: tx)
        operationLabel.text = viewModel.statusDesc.localized()
        iconview.image = UIImage.init(named: viewModel.statusImageName)
        dateLabel.text = viewModel.time
        amountLabel.attributedText = viewModel.ammount
    }
}
