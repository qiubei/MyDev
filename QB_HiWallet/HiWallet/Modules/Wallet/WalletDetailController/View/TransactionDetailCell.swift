//
//  TransactionDetailCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/16.
//  Copyright © 2019 TOP. All rights reserved.
//

import SnapKit
import UIKit

class TransactionDetailCell: UITableViewCell {
    init(reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        layout()
    }

    private func setup() {
        textLabel?.textColor = App.Color.cellInfo
        textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        detailTextLabel?.textColor = App.Color.cellTitle
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        detailTextLabel?.numberOfLines = 0
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    private func layout() {
        textLabel?.snp.updateConstraints {
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(0.2 * UIScreen.main.bounds.width)
        }

        detailTextLabel?.snp.updateConstraints {
            $0.top.equalTo(12)
            $0.right.equalTo(-20)
            $0.left.equalTo(textLabel!.snp.right).offset(10)
            $0.centerY.equalToSuperview()
            $0.bottom.equalTo(-12)
            $0.height.greaterThanOrEqualTo(36)
        }
    }
}

extension TransactionDetailCell {
    func setupCell(cellModel: DetailCellModel) {
        textLabel?.text = cellModel.title
        detailTextLabel?.text = cellModel.detail
        if let _image = cellModel.imageName {
            detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            accessoryView = UIImageView(image: UIImage.init(named: _image)).then {
                $0.frame = CGRect(x: 0, y: 0, width: 30, height: 18)
                $0.contentMode = .right
            }
            detailTextLabel?.snp.updateConstraints {
                $0.right.equalTo(0)
                $0.left.equalTo(textLabel!.snp.right).offset(10)
                $0.centerY.equalToSuperview()
            }
        }
    }

    func hiddenSparator(isHidden: Bool) {
        if isHidden {
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        } else {
            separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}
