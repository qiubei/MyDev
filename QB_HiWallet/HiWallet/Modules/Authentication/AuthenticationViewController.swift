//
//  AuthenticationViewController.swift
//  HiWallet
//
//  Created by 晨风 on 2018/10/8.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import AudioUnit
import LocalAuthentication
import RealmSwift
import TOPCore
import UIKit

public enum HandleType {
    case setPassword
    case login
    case changePassword
}

class AuthenticationViewController: BaseViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var pinView: UIStackView!
    @IBOutlet var cancelButton: UIButton!

    private lazy var userService: ViewUserStorageServiceInterface = inject()
    private lazy var keychainService: KeychainServiceInterface = inject()

    var passwordVerify: String = "" // 输入的密码
    var password: String = "" // 输入的密码
    var handleType: HandleType = .login
    var mnemonic: String = MnemonicService().newMnemonic(with: .english)
    var importMnemonic: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
//        if handleType == .login {
//            password = "111111"
//            loadAccount()
//            AuthenticationService.shared.closeAuthentication()
//        }
        #endif

        if handleType == .login {
            if AuthenticationService.shared.bioLogin {
                var error: NSError?
                let avaible = AuthenticationService.shared.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                if avaible {
                    // 如果修改过ID直接返回错误并关闭所有
                    if let bio = UserDefaults.standard.value(forKey: UserDefautConst.LAContentID) as? Data {
                        if bio != AuthenticationService.shared.laContext.evaluatedPolicyDomainState {
                            userService.update({ user in
                                user.biometricLogin = false
                            })
                            userService.update({ user in
                                user.biometricLogin = false
                            })
                            UserDefaults.standard.set(nil, forKey: UserDefautConst.LAContentID)

                            if AuthenticationService.shared.biometryType == .faceID {
                                tipLabel.text = "面容信息发生变更，请在设置中重新开启".localized()
                            } else {
                                tipLabel.text = "指纹信息发生变更，请在设置中重新开启".localized()
                            }
                            return
                        }

                        keychainService.getPassword(userId: userService.users.first!.id) { result in
                            switch result {
                            case let .success(pwd):
                                if let pass = pwd {
                                    self.password = pass
                                    self.loadAccount()
                                }
                                break
                            case .failure:
                                break
                            }
                        }
                    } else {
                        // 生物识别不可用
                        DLog(error?.description)
                    }
                }
            }
        } else {
            cancelButton.setTitle("取消".localized(), for: .normal)
            cancelButton.isEnabled = true
        }
    }

    override func localizedString() {
        switch handleType {
        case .login:
            tipLabel.text = "请输入密码解锁".localized()
        case .setPassword:
            tipLabel.text = "设置密码".localized()
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AuthenticationViewController {
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteButton(_ sender: Any) {
        if password.count == 0 {
            return
        }

        let imageView = view.viewWithTag(1000 + password.count - 1) as! UIImageView
        imageView.isHighlighted = false
        password.removeLast()
    }

    @IBAction func NumAction(_ sender: UIButton) {
        password = password + sender.titleLabel!.text!
        let imageView = view.viewWithTag(1000 + password.count - 1) as! UIImageView
        imageView.isHighlighted = true

        if password.count == 6 {
            switch handleType {
            case .login:
                if verify(password: password) {
                    loadAccount()

                } else {
                    password = ""
                    pinView.shake()
                    let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                    AudioServicesPlaySystemSound(soundID)
                }
                break

            case .setPassword:

                setPassword(password: password)
                password = ""

            default:
                password = ""
                break
            }
            view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for index in 0 ... 5 {
                    let imageView = self.view.viewWithTag(1000 + index) as! UIImageView
                    imageView.isHighlighted = false
                }
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}

// MAKR: - AuthenticationDelegate

extension AuthenticationViewController {
    func setPassword(password: String) {
        if passwordVerify.count == 0 {
            passwordVerify = password
            tipLabel.text = "请再次输入密码".localized()

        } else {
            if passwordVerify == password {
                createAccont(password: password)

            } else {
                passwordVerify = ""
                Toast.showToast(text: "两次密码不一致，请重新输入".localized(), style: .white)
                tipLabel.text = "设置密码".localized()
                pinView.shake()
            }
        }
    }

    // 验证密码
    func verify(password: String) -> Bool {
        let viewUser = userService.users.first
        if password.sha512().sha512() == viewUser?.passwordHash {
            return true
        }
        return false
    }

    func clearDBAndloadAccount() {
        view.isUserInteractionEnabled = false
        Toast.showHUD()

        let userID = userService.users.first!.id

        DispatchQueue.global().async {
            guard let userStore: UserStorageServiceInterface = try? RealmUserStorage(seedHash: userID, password: self.password) else {
                return
            }

            userStore.update { user in

                user.wallet?.clearWallet()
                ChainType.supportChains.forEach({ coin in

                    let walletInfo = GeneratingWalletInfo(name: coin.name, coin: coin, accountIndex: 0, seed: user.seed, sourseType: .app)
                    if coin.symbol == ChainType.ethereum.symbol {
                        let token = Token(id: "127",
                                          contractAddress: TOPConstants.erc20TOPContractAddress,
                                          symbol: "TOP",
                                          fullName: "TOP Network",
                                          decimals: 18,
                                          iconUrl: "https://topapplication.s3.amazonaws.com/eb9bc37cc267c8182b08ed0e0a8ed6f1",
                                          webURL: "https://cn.etherscan.com/token/0xdcd85914b8ae28c1e62f1c488e1d968d5aaffe2b",
                                          chainType: "ETH"
                        )

                        let tokenWallet = TokenWallet(name: "TOP Network", token: token, privateKey: walletInfo.privateKey, address: walletInfo.address, accountIndex: 0, lastBalance: 0)
                        user.wallet?.tokenWallets.append(tokenWallet)
                    }

                    user.wallet?.generatedWalletsInfo.append(walletInfo)

                    DispatchQueue.main.async {
                        Toast.hideHUD()

                        App.isLogined = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
                        UserDefaults.standard.set(false, forKey: "NeedClearDB")
                        self.loadAccount()
                    }
                })
            }
        }
    }

    // 登录账户
    func loadAccount() {
        guard let userStore: UserStorageServiceInterface = try? RealmUserStorage(seedHash: userService.users.first!.id, password: password) else {
            return
        }

        // 数据库需要清空
        if UserDefaults.standard.bool(forKey: "NeedClearDB") {
            let alert = UIAlertController(title: "数据同步".localized(), message: "升级版本后，需要将数据与旧版本进行同步，大概需要数秒，同步后可以手动添加已隐藏的资产".localized(), preferredStyle: .alert)
            let action = UIAlertAction(title: "开始同步".localized(), style: .default, handler: { _ in

                self.clearDBAndloadAccount()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        // 这句话必须加
        prepareInjection(userStore, memoryPolicy: .viewController)

        userStore.update { user in

            TOPStore.shared.setUser(user)
            App.isLogined = true
            AuthenticationService.shared.closeAuthentication()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
        }
    }

    // 创建账户
    func createAccont(password: String) {
        view.isUserInteractionEnabled = false
        Toast.showHUD()

        DispatchQueue.global().async {
            if let imp = self.importMnemonic {
                self.mnemonic = imp
            }
            let user = User(mnemonic: self.mnemonic)
            user.id = NSUUID().uuidString
            TOPStore.shared.setUser(user)

            DispatchQueue.main.sync {
                do {
                    let path = LocalFolderPath.final("Keystore")
                    let keystore = try (inject() as MnemonicServiceInterface).keyStoreFile(stringData: user.mnemonic!, passwordData: password.data(using: .utf8)?.sha3(.keccak256) ?? Data())

                    let url = try (inject() as LocalFilesServiceInterface).storeData(keystore, to: path, with: "\(user.id)")
                    user.backup?.keystorePath = url.path
                    user.backup?.currentlyBackup?.add(.keystore)

                    if self.importMnemonic != nil {
                        user.backup?.currentlyBackup?.add(.mnemonic)
                    }
                    //
                    let wallets: List<GeneratingWalletInfo> = List()
                    let tokenWallets: List<TokenWallet> = List()
                    // 创建默认钱包
                    ChainType.supportChains.forEach({ coin in

                        let walletInfo = GeneratingWalletInfo(name: coin.name, coin: coin, accountIndex: 0, seed: user.seed, sourseType: .app)
//                        #warning("测试代码")
//                        if coin == .bitcoinCash {
//                            walletInfo.address = "1H9wyrtu3gcfA5cZ1yDoV5aDaWAbbToY9v" //BCH ()
//                        }
//                        if coin == .dash {
//                            walletInfo.address = "XmzfivrzYQ7B7oBMZKwPRdhjB1iNvX71XZ"//XhwFc5qM7gAkPk5Y5K33byUc5EyeFcnjsN" //DASH
//                        }
//                        if coin == .litecoin {
//                            walletInfo.address = "M9sqXXW42k4QsqY9NAMei7EWC1ZX8ivg1f" //LTC
//                        }

                        wallets.append(walletInfo)

                        if coin.symbol == ChainType.ethereum.symbol {
                            let token = Token(id: "127",
                                              contractAddress: TOPConstants.erc20TOPContractAddress,
                                              symbol: "TOP",
                                              fullName: "TOP Network",
                                              decimals: 18,
                                              iconUrl: "https://topapplication.s3.amazonaws.com/eb9bc37cc267c8182b08ed0e0a8ed6f1",
                                              webURL: "https://cn.etherscan.com/token/0xdcd85914b8ae28c1e62f1c488e1d968d5aaffe2b",
                                              chainType: "ETH"
                            )

                            let tokenWallet = TokenWallet(name: "TOP Network", token: token, privateKey: walletInfo.privateKey, address: walletInfo.address, accountIndex: 0, lastBalance: 0)

                            tokenWallets.append(tokenWallet)
                        }
                    })
                    user.wallet?.generatedWalletsInfo = wallets
                    user.wallet?.tokenWallets = tokenWallets

                    let userStore: UserStorageServiceInterface = try RealmUserStorage(user: user, password: password)
                    prepareInjection(userStore, memoryPolicy: .viewController)
                    //
                    Toast.hideHUD()
                    App.isLogined = true
                    let root = Application.shared.keyWindow?.rootViewController

                    root?.dismiss(animated: false, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)

                } catch {
                    Toast.hideHUD()
                    DLog(error.localizedDescription)
                    Toast.showToast(text: "创建账户失败！".localized(),style: .white)
                }
            }
        }
    }
}

func authenticationSuccessful() {
    AuthenticationService.shared.closeAuthentication()
}
