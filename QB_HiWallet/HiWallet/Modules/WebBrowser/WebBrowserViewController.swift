//
//  WebBrowserViewController.swift
//  HiWallet
//
//  Created by apple on 2019/5/28.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import HDWalletKit
import SnapKit
import TOPCore
import WebKit

//        urlString = "https://member.iotex.io/" // 投票
//        urlString = "https://app.compound.finance/" // 借贷
//        urlString = "http://192.168.50.194:3002/" //top
//        urlString = "https://www.hypersnakes.io/e/i/m/index.html" // 贪吃蛇
//        urlString = "https://hyperdragons.alfakingdom.com/" // "云斗龙

class WebBrowserViewController: BaseViewController {
    // URL
    private var myContext = 0
    var urlString: String
    var account: ViewWalletInterface!
    let sessionConfig: Config
    let server: ETHRPCServer
    var sendModel: TranstonInterface!

    private struct Keys {
        static let estimatedProgress = "estimatedProgress"
        static let developerExtrasEnabled = "developerExtrasEnabled"
        static let URL = "URL"
        static let ClientName = "HiWallet"
        static let Title = "title"
    }

    private lazy var userClient: String = {
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String
        return Keys.ClientName + "/" + majorVersion
    }()

    // 初始化
    init(
        account: ViewWalletInterface,
        urlStr: String
    ) {
        self.account = account
        sessionConfig = .current
        urlString = urlStr
        #if DEBUG
            server = UserDefaults.standard.bool(forKey: UserDefautConst.ETHChain_Main) ? ETHRPCServer.main : ETHRPCServer.rinkeby
            urlString = UserDefaults.standard.bool(forKey: UserDefautConst.ETHChain_Main) ? "http://www.topstaking.io/" : "http://192.168.50.194:3002"
        #else
            server = ETHRPCServer.main
        #endif

        if account.symbol == MainCoin.ethereum.symbol {
            sendModel = ContractTransfer(walletInfo: account)
        }

        super.init(nibName: nil, bundle: nil)
        view.addSubview(webView)
        view.addSubview(progressView)

        injectUserAgent()
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: Keys.URL, options: [.new, .initial], context: &myContext)
        webView.addObserver(self, forKeyPath: Keys.Title, options: [.new, .initial], context: &myContext)

        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // WebView
    lazy var webView: TPWKWebView = {
        let webView = TPWKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    lazy var config: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration.make(for: server, address: account.address, with: sessionConfig, in: ScriptMessageProxy(delegate: self))
        config.websiteDataStore = WKWebsiteDataStore.default()
        return config
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        progressView.tintColor = App.Color.mainColor
        progressView.trackTintColor = .clear
        return progressView
    }()

    // MARK: - Life

    override func viewDidLoad() {
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.setAcceptLanguage()
        webView.load(request)

        webView.reload()
        NotificationCenter.default.addObserver(self, selector: #selector(webViewTouchEvent(_:)), name: Notification.Name(NotificationConst.touchWebViewEvent), object: nil)
    }

    @objc
    private func webViewTouchEvent(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            if self.webView.backForwardList.backList.count > 0 || self.webView.canGoForward {
                self.closeItem.image = UIImage(named: "icon_web_close")
                self.closeItem.isEnabled = true
            }
        })
    }

    private var closeItem: UIBarButtonItem!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationCloseBarButton()
        addNavigationMoreBarButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        config.removeAllMessageHandler()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == Keys.estimatedProgress {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.alpha = 1
                progressView.setProgress(progress, animated: true)
                if progress >= 1 {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.progressView.alpha = 0
                    }) { _ in
                        self.progressView.isHidden = true
                        self.progressView.progress = 0
                    }
                }
            }
        } else if keyPath == Keys.URL {
        } else if keyPath == Keys.Title {
            title = webView.title
        }
    }

    private func injectUserAgent() {
        webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
            guard let strongSelf = self, let currentUserAgent = result as? String else { return }
            strongSelf.webView.customUserAgent = currentUserAgent + " " + strongSelf.userClient
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath: Keys.estimatedProgress)
        webView.removeObserver(self, forKeyPath: Keys.URL)
        webView.removeObserver(self, forKeyPath: Keys.Title)

        print("web deinit")
    }
}

extension WebBrowserViewController: WKScriptMessageHandler {
    // WebView中给Swift发消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let dappCommonModel = try! DAppDataHandle.fromMessage(message: message)
        switch dappCommonModel.name {
        case .sendTransaction, .signTransaction:
            pushTransaction(dappCommonModel: dappCommonModel)
        case .signPersonalMessage, .signMessage, .signTypedMessage:
            pushSignMessage(dappCommonModel: dappCommonModel)
        case .unknown:
            DLog(message.name)
            break
        }
    }
}

extension WebBrowserViewController {
    private func pushTransaction(dappCommonModel: DAppCommonModel) {
        DLog("交易事件")
        if dappCommonModel.chainType == .eth {
            let bigAmount = BInt(dappCommonModel.eth?.value ?? "0") ?? 0
            let etherAmmount = ethAmount(amount: bigAmount)
            sendModel.amount = etherAmmount
            sendModel.address = (dappCommonModel.eth?.to)!
            sendModel.note = dappCommonModel.eth?.data ?? ""
            if let gas = dappCommonModel.eth?.gasLimit {
                sendModel.gasLimit = gas.hexStringToInt()
            }
            Toast.showHUD()
            sendModel.loadFeeData { [weak self] success in
                Toast.hideHUD()
                if success {
                    self?.popConfrmView(amount: etherAmmount, dappCommonModel: dappCommonModel)
                } else {
                    self!.showNetError()
                }
            }
        }
    }

    //
    func ethAmount(amount: BInt) -> String {
        let ethAmount = CryptoFormatter.WeiToEther(valueStr: "\(amount)")
        let amountValue = NSDecimalNumber(string: String(format: "%.15f", ethAmount))
        return String("\(amountValue)")
    }

    private func pushSignMessage(dappCommonModel: DAppCommonModel) {
        DLog("签名事件")
        let dataText = dappCommonModel.eth?.data ?? ""
        let message = String(decoding: Data.fromHex(dataText)!, as: UTF8.self)
        let popView = AuthPopViewController(wallet: account, message: message)
        let privateKey = account.privateKey
        popView.cancelAction = {
            self.callBackWebView(id: dappCommonModel.id, value: "", error: DAppError.userCanceled)
        }
        popView.confirmActionBlock = {
            AuthenticationService.shared.verifyWithResult(resultBack: { success, _ in

                if success {
                    Toast.showHUD()
                    DispatchQueue.global().async {
                        do {
                            let messageData = Data.fromHex(dappCommonModel.eth?.data ?? "") ?? Data()

                            if dappCommonModel.name == .signPersonalMessage {
                                guard let signed = try EthereumMessageSigner().signPersonalMessage(message: messageData, privateKey: privateKey) else {
                                    self.messageSignCallBackWebView(id: dappCommonModel.id, value: "", error: DAppError.signPersonalMessagFailed)
                                    return
                                }

                                DispatchQueue.main.async {
                                    Toast.hideHUD()
                                    self.messageSignCallBackWebView(id: dappCommonModel.id, value: signed, error: nil)
                                }
                            } else {
                                guard let signed = try EthereumMessageSigner().sign(message: messageData, privateKey: privateKey) else {
                                    self.messageSignCallBackWebView(id: dappCommonModel.id, value: "", error: DAppError.signMessageFailed)
                                    return
                                }
                                DispatchQueue.main.async {
                                    Toast.hideHUD()
                                    self.messageSignCallBackWebView(id: dappCommonModel.id, value: signed, error: nil)
                                }
                            }
                        } catch let error {
                            DispatchQueue.main.async {
                                Toast.hideHUD()
                                DLog(error.localizedDescription)
                                self.messageSignCallBackWebView(id: dappCommonModel.id, value: "", error: DAppError.signMessageFailed)
                            }
                        }
                    }
                } else {
                    self.messageSignCallBackWebView(id: dappCommonModel.id, value: "", error: DAppError.userCanceled)
                }
            })
        }
        present(popView, animated: false, completion: nil)
    }

    // 回调函数
    func callBackWebView(id: Int, value: String, error: DAppError?) {
        evaluateJavaScryptWebView(id: id, value: value, error: error)
        if let error = error {
            error != .userCanceled ? Toast.showToast(text: "DApp.Browser.PayFaild".localized()) : nil
        }
    }

    func messageSignCallBackWebView(id: Int, value: String, error: DAppError?) {
        evaluateJavaScryptWebView(id: id, value: value, error: error)
        if let error = error {
            error != .userCanceled ? Toast.showToast(text: "DApp.Browser.SignFaild".localized()) : nil
        }
    }

    func evaluateJavaScryptWebView(id: Int, value: String, error: DAppError?) {
        let script: String
        if error == nil {
            script = "executeCallback(\(id), null, \"\(value)\")"
        } else {
            script = "executeCallback(\(id), \"\(error!)\", null)"
        }
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension WebBrowserViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return webView.scrollView.subviews.first
    }
}

// MARK: - User agent, JS, CSS style, etc.

private extension WebBrowserViewController {
    func popConfrmView(amount: String, dappCommonModel: DAppCommonModel) {
        let controller = PopViewController()
        controller.datalist = sendModel.getPopData()
        controller.balanceText = CryptoFormatter.attributeString(amount: amount + " " + account.symbol, balance: BalanceFormatter.getCurreyPrice(fullName: account.fullName, value: Double(amount) ?? 0))

        controller.selectedSpeedAction = { [unowned self] index in
            controller.reloadData(data: self.sendModel.reloadPopDataWithIndex(index: index))
        }
        // 用户取消
        controller.cancelAction = { [unowned self] in
            self.callBackWebView(id: dappCommonModel.id, value: "", error: DAppError.userCanceled)
        }

        // 确认按钮

        controller.confirmAction = { [unowned self] in

            Toast.showHUD()
            self.sendModel.confirmVerify { result in
                Toast.hideHUD()
                switch result {
                case .success:
                    controller.dismiss(animated: true, completion: nil)

                    AuthenticationService.shared.verifyWithResult(resultBack: { success, _ in

                        if success {
                            Toast.showHUD()

                            self.sendModel.sendTranstion(callback: { success, msg in

                                Toast.hideHUD()
                                if success {
                                    Toast.showToast(text: "广播成功".localized())
                                    self.callBackWebView(id: dappCommonModel.id, value: msg, error: nil)
                                } else {
                                    Toast.showToast(text: msg)
                                    self.callBackWebView(id: dappCommonModel.id, value: "", error: DAppError.sendTransactionFailed)
                                }
                            })
                        } else {
                            self.callBackWebView(id: dappCommonModel.id, value: "", error: DAppError.userCanceled)
                        }
                    })
                case let .toast(msg):
                    Toast.showToast(text: msg)

                case let .alert(msg):
                    self.showAlert(msg: msg)
                }
            }
        }

        controller.modalPresentationStyle = UIModalPresentationStyle.custom
        present(controller, animated: false, completion: nil)
    }

    func showNetError() {
        Toast.showToast(text: "网络出走了，请检查网络状态后重试".localized())
    }

    func showAlert(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancal = UIAlertAction(title: "确定".localized(), style: .default, handler: { _ in

        })
        alert.addAction(cancal)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - web view delegate

extension WebBrowserViewController: WKUIDelegate, WKNavigationDelegate {
    func addNavigationCloseBarButton() {
        closeItem = UIBarButtonItem(image: UIImage(named: "icon_web_close"), style: .plain, target: self, action: #selector(closeAction(_:)))
        let backItem = UIBarButtonItem(image: UIImage(named: "navigation_left_back"), style: .plain, target: self, action: #selector(backAction(_:)))
        navigationItem.leftBarButtonItems = [backItem, closeItem]
        closeItem.image = UIImage()
        closeItem.isEnabled = false
    }

    func addNavigationMoreBarButton() {
        let moreItem = UIBarButtonItem(image: UIImage(named: "icon_web_more"), style: .plain, target: self, action: #selector(moreAction(_:)))

        navigationItem.rightBarButtonItem = moreItem
    }

    @objc
    private func closeAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func moreAction(_ sender: UIBarButtonItem) {
        let controller = FakeSharedViewController()
        controller.modalPresentationStyle = .custom
        controller.uiAction = self
        present(controller, animated: false, completion: nil)
    }

    @objc
    private func backAction(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
        if webView.backForwardList.backList.count > 0 {
            closeItem.image = UIImage(named: "icon_web_close")
            closeItem.isEnabled = true
            if webView.backForwardList.backList.count == 1 {
                closeItem.image = UIImage()
                closeItem.isEnabled = false
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)

        if webView.canGoBack {
            closeItem.image = UIImage(named: "icon_web_close")
            closeItem.isEnabled = true
        } else {
            closeItem.image = UIImage()
            closeItem.isEnabled = false
        }
    }
}

// MARK: - more pop view Callback action

extension WebBrowserViewController: FakeUIService {
    func dismissAction() {
    }

    func shareAction() {
        if let url = webView.url {
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
            //            activityController.completionHandler
        }
    }

    func refreshAction() {
        webView.reload()
    }

    func copyLinkAction() {
        if let url = webView.url {
            DispatchQueue.main.async {
                UIPasteboard.general.string = url.absoluteString
                Toast.showToast(text: "复制成功".localized())
            }
        }
    }

    func openInSafariAction() {
        if let url = webView.url {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
}

public class TPWKWebView: WKWebView {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        NotificationCenter.default.post(name: Notification.Name(NotificationConst.touchWebViewEvent), object: nil)
        return super.hitTest(point, with: event)
    }
}
