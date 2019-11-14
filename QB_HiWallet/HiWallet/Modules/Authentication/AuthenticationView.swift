//
//  AuthenticationView.swift
//  HiWallet
//
//  Created by Jax on 2019/9/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import AudioUnit
import UIKit

protocol AuthenticationViewProtocol {
    func cancelAction()
    func passwordVerify(password: String)
}

class AuthenticationView: UIView {
    @IBOutlet var passwordView: UIStackView!
    @IBOutlet var titleLabel: UILabel!

    var delegate: AuthenticationViewProtocol?
    var password: String = ""

    func passwordError() {
        passwordView.shake()
        password = ""
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(soundID)
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for index in 0 ... 5 {
                let imageView = self.viewWithTag(1000 + index) as! UIImageView
                imageView.isHighlighted = false
            }
            self.isUserInteractionEnabled = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "密码验证".localized()
    }

    @IBAction func closeAction(_ sender: Any) {
        delegate?.cancelAction()
    }

    @IBAction func numAction(_ sender: UIButton) {
        guard password.count < 6 else {
            return
        }

        password = password + sender.titleLabel!.text!
        let imageView = viewWithTag(1000 + password.count - 1) as! UIImageView
        imageView.isHighlighted = true
        if password.count == 6 {
            delegate?.passwordVerify(password: password)
        }
    }

    @IBAction func deleteAction(_ sender: Any) {
        if password.count == 0 {
            return
        }

        let imageView = viewWithTag(1000 + password.count - 1) as! UIImageView
        imageView.isHighlighted = false
        password.removeLast()
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */
}
