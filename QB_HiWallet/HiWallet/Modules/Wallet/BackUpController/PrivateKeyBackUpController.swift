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
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var blurView: UIImageView!
    
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    var seletIndex = 0
    var walletInfo:ViewWalletInterface?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewConstraint.constant = 0
        imageBgView.isHidden = true
        tabbleSelectView.delegate = self
        privateLabel.text = hidePrivate(privateStr: walletInfo!.privateKey)
        qrCodeImageView.image = UIImage.init(cgImage:EFQRCode.generate(content: walletInfo!.privateKey)!)
        bottomButton.setTitle("复制私钥".localized(), for: .normal)
    }
    
    override func setup() {
        title = "备份私钥".localized()
        tipLabel.text = "掌握私钥就相当于拥有钱包的全部权限，请确保私钥得到妥善保管和安全传输。".localized()
        
        tabbleSelectView.buttonTitles = ["私钥".localized(),"二维码".localized()]
    }
    
    func tabbedButtonsView(_ view: TabbedButtonsView, didSelectButtonAt index: Int) {
        
        seletIndex = index
        if seletIndex == 0 {
            textViewConstraint.constant = 80;
            imageViewConstraint.constant = 0
            bottomButton.setTitle("复制私钥".localized(), for: .normal)
    
        } else {
            textViewConstraint.constant = 0;
            imageViewConstraint.constant = 280
            imageBgView.isHidden = false
            bottomButton.setTitle("显示二维码".localized(), for: .normal)

        }
    }
    func hidePrivate(privateStr:String) -> String {
        return privateStr.prefix(10) + "*************" + privateStr.suffix(10)
    }
    @IBAction func bottomButtonClick(_ sender: Any) {
        if seletIndex == 1 {
            blurView.isHidden = true
        } else {
            
            UIPasteboard.general.string = walletInfo?.privateKey
            Toast.showToast(text: "复制成功".localized())
        }
    }
    @IBAction func showTextClick(_ sender: UIButton) {
        //显示完整私钥
         sender.isHidden = true
         privateLabel.text = walletInfo?.privateKey
    }
}
