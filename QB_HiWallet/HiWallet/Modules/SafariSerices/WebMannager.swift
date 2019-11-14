//
//  WebMannager.swift
//  HiWallet
//
//  Created by Jax on 2019/7/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import SafariServices
import TOPCore
import UIKit

public class WebMannager: NSObject {
    class func showInSafariWithUrl(url: String, controller: UIViewController) {
        let safariController = SFSafariViewController(url: URL(string: url)!)
        safariController.modalPresentationStyle = .fullScreen
        controller.present(safariController, animated: true, completion: nil)
    }

    class func showDappWithUrl(url: String, wallet: ViewWalletInterface, controller: UIViewController) {
        let web = WebBrowserViewController(account: wallet, urlStr: url)
        controller.navigationController?.pushViewController(web, animated: true)
    }
}
