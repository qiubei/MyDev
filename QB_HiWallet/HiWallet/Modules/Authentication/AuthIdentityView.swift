//
//  AuthView.swift
//  HiWallet
//
//  Created by Jax on 2019/9/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import LocalAuthentication
import TOPCore
import UIKit

class AuthIdentityView: UIView {
    private var backView: UIView
    private var verifyView: AuthenticationView
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    var resultBack: ((_ success: Bool, _ password: String?) -> Void)?

    override init(frame: CGRect) {
        backView = UIView(frame: frame)
        backView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4298480308)
        backView.alpha = 0
        verifyView = Nib.load(name: "AuthentionView").view as! AuthenticationView
        verifyView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenWidth / 375.0 * 420)
        backView.addSubview(verifyView)
        super.init(frame: frame)
        addSubview(backView)
        verifyView.delegate = self
    }

    func show() {
        UIView.animate(withDuration: 0.25) {
            self.verifyView.y = screenHeight - screenWidth / 375.0 * 420
            self.backView.alpha = 1
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// show the password verify view
    /// - Parameters:
    ///   - passVerify: it's a flag of not to verify the biodata
    ///   - resultBack: result
    class func showWithResult(passVerify: Bool = false, resultBack: @escaping (_ success: Bool, _ passwd: String?) -> Void) {
        let auth = AuthIdentityView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        auth.resultBack = { result, pwd in
            resultBack(result, pwd)
        }
        UIApplication.shared.keyWindow?.addSubview(auth)
        auth.show()

        // 如果不是必须密码验证
        if !passVerify {
            // 如果开启人脸
            if AuthenticationService.shared.bioPay {
                let laContext = LAContext()
                var error: NSError?
                let avaible = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                // 判断是否可用
                if avaible {
                    // 如果修改过ID直接返回错误并关闭所有
                    if let bio = UserDefaults.standard.data(forKey: UserDefautConst.LAContentID) {
                        if bio != laContext.evaluatedPolicyDomainState {
                            closeBioAction()
                        } else {
                            (inject() as KeychainServiceInterface).getPassword(userId: (inject() as ViewUserStorageServiceInterface).current!.id) { result in
                                switch result {
                                case let .success(pwd):
                                    resultBack(true, pwd)
                                    auth.closeAction()
                                    break
                                case .failure:
                                    // 失败不回调
                                    break
                                }
                            }
                        }
                    }

                } else {
                    // 如果没有启人脸
                    DLog("生物验证不可用")
                    (inject() as ViewUserStorageServiceInterface).update({ user in
                        user.biometricLogin = false
                        user.biometricPay = false
                    })
                }
            }
        }
    }
}

// MARK: - 关闭免密，清空指纹信息

extension AuthIdentityView {
    // 系统设置关闭生物授权（指纹或面容）时，同步本地偏好设置项。
    private class func closeBioAction() {
        (inject() as ViewUserStorageServiceInterface).update({ user in
            user.biometricLogin = false
            user.biometricPay = false
        })
        UserDefaults.standard.set(nil, forKey: UserDefautConst.LAContentID)

        if AuthenticationService.shared.biometryType == .faceID {
            Toast.showToast(text:"面容信息发生变更，请在设置中重新开启".localized())
        } else {
            Toast.showToast(text:"指纹信息发生变更，请在设置中重新开启".localized())
        }
    }
}

//MARK:- authention view ui action delegate
extension AuthIdentityView: AuthenticationViewProtocol {
    func passwordVerify(password: String) {
        if password.sha512().sha512() == userService.users.first?.passwordHash {
            DispatchQueue.main.async {
                self.closeAction()
            }

            if let callback = resultBack {
                callback(true, password)
            }
        } else {
            verifyView.passwordError()
        }
    }

    private func closeAction() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.verifyView.y = screenHeight
            self.backView.alpha = 0

        }) { _ in
            self.removeFromSuperview()
        }
    }

    func cancelAction() {
        if let callback = resultBack {
            callback(false, nil)
        }
        closeAction()
    }
}
