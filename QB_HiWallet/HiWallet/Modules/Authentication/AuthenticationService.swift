//
//  AuthenticationService.swift
//  HiWallet
//
//  Created by 晨风 on 2018/10/8.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import LocalAuthentication
import RealmSwift
import TOPCore
import UIKit

class AuthenticationService {
    enum BiometryType {
        case none
        case touchID
        case faceID
    }
    
    static let shared = AuthenticationService()

    private var willResignActiveDate: Date? // 退出后台时间
    private var window: UIWindow?
    private var notificationToken: NotificationToken?
    private lazy var viewUserService: ViewUserStorageServiceInterface = inject()
    private lazy var keychainService: KeychainServiceInterface = inject()

    let biometryType: BiometryType
    let laContext = LAContext()

    // 是否可用用户
    var isEnable: Bool {
        return viewUserService.users.count > 0
    }

    // 免密支付
    var bioPay: Bool {
        return viewUserService.users.first!.biometricPay
    }

    // 免密登录
    var bioLogin: Bool {
        return viewUserService.users.first!.biometricLogin
    }

    var timeout: TimeInterval = 30.0 // 后台时间

    private init() {
        // 初始化支持的内容
        var error: NSError?
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if laContext.biometryType == LABiometryType.faceID {
                biometryType = BiometryType.faceID
            } else {
                biometryType = BiometryType.touchID
            }

        } else {
            biometryType = BiometryType.none
        }

        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
    }

    deinit {
        notificationToken?.invalidate()
    }

    func register() {}

    func authentication() {
        guard self.window == nil else { return }
        guard willResignActiveDate == nil || willResignActiveDate! + timeout < Date() else {
            return
        }

        if viewUserService.users.isEmpty {
            return
        }

        let controller: AuthenticationViewController = UIStoryboard(name: .authentication).instantiateViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: controller)
        window.makeKeyAndVisible()
        self.window = window
    }

    // MARK: - 弹框认证
    func verifyWithResult(pwd: Bool = false, resultBack: @escaping (_ success: Bool, _ passwd: String?) -> Void) {
        AuthIdentityView.showWithResult(passVerify: pwd) { result, passwd in
            resultBack(result, passwd)
        }
    }

    // MARK: - 关闭认证
    func closeAuthentication() {
        guard let window = window else { return }
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            window.transform = CGAffineTransform(translationX: 0, y: window.bounds.size.height)
        }, completion: { _ in
            self.window = nil
        })
    }

    // MARK: - 调用生物认证
    func deviceAuthentication(complection: @escaping (Bool, LAError?) -> Void) {
        var error: NSError?
        let avaible = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        // 判断是否可用
        if avaible {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometry") { (result, error: Error?) in
                DispatchQueue.main.async {
                    if result {
                        complection(true, nil)
                    } else {
                        guard let error = error as NSError? else {
                            complection(false, nil)
                            return
                        }
                        let errorType = LAError(_nsError: error)
                        complection(false, errorType)
                    }
                }
            }
        } else { // 不可用
            let errorType = LAError(_nsError: error!)
            complection(false, errorType)
        }
    }

    // MARK: - Notification

    @objc private func didBecomeActiveNotification() {
        guard isEnable else { return }
        authentication()
        willResignActiveDate = nil
    }

    @objc private func willResignActiveNotification() {
        guard isEnable else { return }
        willResignActiveDate = Date()
    }
}

// MARK: - 设置免密支付和人脸

extension AuthenticationService {
    func setBiometricsEnable(isPay: Bool, enable: Bool, complection: @escaping (Bool) -> Void) {
        // 开启
        if enable {
            verifyWithResult(pwd: true, resultBack: { success, pwd in

                if success {
                    self.deviceAuthentication { pass, error in
                        if pass {
                            self.changeBiometricsEnable(isPay: isPay, enable: enable, password: pwd ?? "", complection: complection)
                        } else {
                            Toast.showToast(text:error!.stringValue)
                            complection(false)
                        }
                    }

                } else {
                    complection(false)
                }
            })
        } else {
            // 关闭
            viewUserService.update({ user in
                if isPay {
                    user.biometricPay = enable

                } else {
                    user.biometricLogin = enable
                }
            })
            complection(true)
        }
    }

    func changeBiometricsEnable(isPay: Bool, enable: Bool, password: String, complection: @escaping (Bool) -> Void) {
        keychainService.storePassword(userId: viewUserService.current!.id, password: password, result: { result in
            switch result {
            case .success():

                UserDefaults.standard.set(self.laContext.evaluatedPolicyDomainState, forKey: UserDefautConst.LAContentID)

                self.viewUserService.update({ user in
                    if isPay {
                        user.biometricPay = enable

                    } else {
                        user.biometricLogin = enable
                    }
                })
                complection(true)

                break
            case let .failure(error):
                DLog(error)
                complection(false)
                break
            }
        })
    }

    func setAuthenticationLoginEnable(enable: Bool, complection: @escaping (Bool) -> Void) {
        setBiometricsEnable(isPay: false, enable: enable, complection: complection)
    }

    func setAuthenticationPayEnable(enable: Bool, complection: @escaping (Bool) -> Void) {
        setBiometricsEnable(isPay: true, enable: enable, complection: complection)
    }
}

extension LAError {
    var stringValue: String {
        switch self {
        case LAError.biometryNotEnrolled:
            return "未设置生物识别".localized()
        case LAError.biometryNotAvailable:
            return "生物识别不可用".localized()
        case LAError.passcodeNotSet:
            return "未设置手机密码".localized()
        case LAError.biometryLockout:
            return "多次验证失败被锁定".localized()
        default:
            return "验证失败，请重新验证".localized()
        }
    }
}
