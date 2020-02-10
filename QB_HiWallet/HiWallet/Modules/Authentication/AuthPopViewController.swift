//
//  AuthPopViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/10/9.
//  Copyright © 2019 TOP. All rights reserved.
//  授权签名的弹框

import TOPCore
import UIKit
class AuthPopViewController: BaseViewController {
    var wallet: ViewWalletInterface
    var message: String
    var cancelAction: EmptyAction?
    var confirmActionBlock: EmptyAction?

    init(wallet: ViewWalletInterface, message: String) {
        self.wallet = wallet
        self.message = message
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let popView = AddressAuthPopView(frame: .zero)
    var _height: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.addSubview(popView)

        popView.backgroundColor = .white
        popView.titleLabel.text = "授权签名".localized()
        let model = NormalPopModel(speedDesc: "签名地址".localized(), Fee: wallet.address, image: nil)
        let model1 = NormalPopModel(speedDesc: "签名内容".localized(), Fee: message, image: nil)
        popView.datalist = [model, model1]
        popView.uiActions = self

        _height = 102 * CGFloat(popView.datalist.count) + 48 + 80 + 86
        popView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(_height)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popView.addRounderCorner(corners: [.topLeft, .topRight], radius: CGSize(width: 16, height: 16))
    }
}

extension AuthPopViewController {
    func popAnimation() {
        popView.frame.origin.y = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.25) {
            self.popView.frame.origin.y = UIScreen.main.bounds.height - self._height
        }
    }

    func dismissAnimation(completion: EmptyAction?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.popView.frame.origin.y = self.view.bounds.height
        }) { flag in
            if flag {
                completion?()
                self.popView.removeFromSuperview()
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismissAnimation(completion: nil)
//    }
}

extension AuthPopViewController: AddressAuthPopViewActions {
    func closeAction() {
        if let cancel = self.cancelAction {
            cancel()
        }
        dismissAnimation(completion: nil)
    }

    func confirmAction() {
        dismissAnimation(completion: nil)
        if let comfirm = self.confirmActionBlock {
            comfirm()
        }
    }
}
