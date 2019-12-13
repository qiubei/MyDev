//
//  PrivateKeyBackUpController.swift
//  HiWallet
//
//  Created by apple on 2019/5/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import TOPCore
import EFQRCode

class PrivateKeyBackUpController: BaseViewController,TabbedButtonsViewDelegate {
    
    @IBOutlet weak var tabbleSelectView: TabbedButtonsView!
    @IBOutlet weak var textViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrBgView: UIView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var showQrButton: UIButton!
    
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    var walletInfo:ViewWalletInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrBgView.shadowColor = UIColor.black
        qrBgView.shadowOffset = .zero
        qrBgView.shadowRadius = 20
        qrBgView.shadowOpacity = 0.09
        qrBgView.clipsToBounds = false
    }
    
    override func setup() {
        imageViewConstraint.constant = 0
        qrBgView.isHidden = true
        tabbleSelectView.delegate = self
        privateLabel.text = hidePrivate(privateStr: walletInfo!.privateKey)
        qrCodeImageView.image = UIImage.init(cgImage:EFQRCode.generate(content: walletInfo!.privateKey)!)
        bottomButton.setTitle("复制私钥".localized(), for: .normal)
    }
    
    override func localizedString() {
        super.localizedString()
        title = "备份私钥".localized()
        tipLabel.text = "掌握私钥就相当于拥有钱包的全部权限，请确保私钥得到妥善保管和安全传输。".localized()
        tabbleSelectView.buttonTitles = ["私钥".localized(),"二维码".localized()]
        showQrButton.setTitle("显示二维码".localized(), for: .normal)
    }
    
    func tabbedButtonsView(_ view: TabbedButtonsView, didSelectButtonAt index: Int) {
        if index == 0 {
            textViewConstraint.constant = 80;
            imageViewConstraint.constant = 0
            bottomButton.isHidden = false
            qrBgView.isHidden = true
        } else {
            textViewConstraint.constant = 0;
            imageViewConstraint.constant = 254
            qrBgView.isHidden = false
            bottomButton.isHidden = true
            blurView.isHidden = false
            showQrButton.isHidden = false
            qrCodeImageView.isHidden = true
        }
    }
    func hidePrivate(privateStr:String) -> String {
        return privateStr.prefix(10) + "*************" + privateStr.suffix(10)
    }
    
    @IBAction func bottomButtonClick(_ sender: Any) {
        UIPasteboard.general.string = walletInfo?.privateKey
        Toast.showToast(text: "复制成功".localized())
    }
    
    @IBAction func showQRCodeAction(_ sender: UIButton) {
        blurView.isHidden = true
        showQrButton.isHidden = true
        qrCodeImageView.isHidden = false
    }
    
    @IBAction func showTextClick(_ sender: UIButton) {
        //显示完整私钥
         sender.isHidden = true
         privateLabel.text = walletInfo?.privateKey
    }
}
