//
//  WebBrowserViewController.swift
//  HiWallet
//
//  Created by Jax on 2019/11/22.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import WebKit

class WebBrowserViewController: BaseViewController {
    // URL
    private var myContext = 0
    var urlString: String
    let sessionConfig: Config
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
    init(urlStr: String) {
        urlString = urlStr
        sessionConfig = .current
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
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    lazy var config: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width',initial-scale=1.0, maximum-scale=1.0,user-scalable=no\">'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript2 = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript2)
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

    lazy var closeItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "icon_web_close"), style: .plain, target: self, action: #selector(closeAction(_:)))
    }()

    lazy var backItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "navigation_left_back"), style: .plain, target: self, action: #selector(backAction(_:)))
    }()

//    lazy var moreItem: UIBarButtonItem = {
//        UIBarButtonItem(image: UIImage(named: "icon_web_more"), style: .plain, target: self, action: #selector(moreAction(_:)))
//    }()

    // MARK: - Life

    override func viewDidLoad() {
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.setAcceptLanguage()
        webView.load(request)
        navigationItem.leftBarButtonItems = [backItem]
//        navigationItem.rightBarButtonItem = moreItem
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
            checkGoBack()
        } else if keyPath == Keys.Title {
            title = webView.title
            checkGoBack()
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

// MARK: - UIScrollViewDelegate

extension WebBrowserViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return webView.scrollView.subviews.first
    }
}

// MARK: - web view delegate

extension WebBrowserViewController: WKUIDelegate, WKNavigationDelegate {
    @objc
    private func closeAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

//    @objc
//    private func moreAction(_ sender: UIBarButtonItem) {
//        let controller = FakeSharedViewController()
//        controller.modalPresentationStyle = .custom
//        controller.uiAction = self
//        present(controller, animated: false, completion: nil)
//    }

    @objc
    private func backAction(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()

        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension WebBrowserViewController {
    /// 检查返回（pop/goback）
    func checkGoBack() {
        if webView.canGoBack {
            navigationItem.leftBarButtonItems = [backItem, closeItem]
        } else {
            navigationItem.leftBarButtonItems = [backItem]
        }
    }
}

// MARK: - more pop view Callback action

//extension WebBrowserViewController: FakeUIService {
//    func dismissAction() {
//    }
//
//    func shareAction() {
//        if let url = webView.url {
//            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//            present(activityController, animated: true, completion: nil)
//            //            activityController.completionHandler
//        }
//    }
//
//    func refreshAction() {
//        webView.reload()
//    }
//
//    func copyLinkAction() {
//        if let url = webView.url {
//            DispatchQueue.main.async {
//                UIPasteboard.general.string = url.absoluteString
//                Toast.showToast(text: "复制成功".localized())
//            }
//        }
//    }
//
//    func openInSafariAction() {
//        if let url = webView.url {
//            UIApplication.shared.open(url,
//                                      options: [:],
//                                      completionHandler: nil)
//        }
//    }
//}
