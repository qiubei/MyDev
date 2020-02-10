//
//  AccountPickerViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import UIKit

class AccountPickerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        _layout()
    }

    var assetID: String!
    var selectWallet: ((ViewWalletInterface) -> Void)?

    private var assetWalletList: [ViewWalletInterface] = []
    private var pickerView: AccountPickerview!

    override func setup() {
        super.setup()
        assetWalletList = (inject() as WalletInteractorInterface).getWalletWithAssetID(assetID: assetID)
        var datalist: [AccountPickerModel] = []
        for wallet in assetWalletList {
            let model = AccountPickerModel(name: wallet.name, address: wallet.address, amount: wallet.balanceInCurrentCurrency)
            datalist.append(model)
        }

        pickerView = AccountPickerview(frame: .zero)
        pickerView.datalist = datalist
        pickerView.titleLabel.text = "选择账户".localized()
        pickerView.uiActions = self
        view.addSubview(pickerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popAnimation()
        pickerView.cornerRadius = 30
    }

    private var _height: CGFloat = 0
    private let _bottomMargin: CGFloat = statusHeight > 20 ? 30 : 10
    private func _layout() {
        _height = 71 + 60 + 68 * CGFloat(assetWalletList.count)
        pickerView.snp.makeConstraints {
            $0.left.equalTo(11)
            $0.right.equalTo(-11)
            $0.bottom.equalTo(-_bottomMargin)
            $0.height.equalTo(_height)
        }
    }
}

extension AccountPickerViewController {
    func popAnimation() {
        pickerView.frame.origin.y = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.25) {
            let offsetY = UIScreen.main.bounds.height - self._height - self._bottomMargin
            self.pickerView.frame.origin.y = offsetY
        }
    }

    func dismissAnimation(completion: EmptyAction?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.frame.origin.y = self.view.bounds.height
        }) { flag in
            if flag {
                completion?()
                self.pickerView.removeFromSuperview()
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    // touch offset position of the popview to close the pop view.
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismissAnimation(completion: nil)
//    }
}

extension AccountPickerViewController: AccountPickerViewActions {
    func closeAction() {
        dismissAnimation(completion: nil)
    }

    func selectedRow(indexPath: IndexPath) {
        dismissAnimation(completion: {
            if let selectAciton = self.selectWallet {
                selectAciton(self.assetWalletList[indexPath.row])
            }
        })
    }
}
