//
//  WKWebViewConfiguration.swift
//  HiWallet
//
//  Created by Jax on 2019/9/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import WebKit

extension WKWebViewConfiguration {
    static func make(for server: ETHRPCServer, address: String, with sessionConfig: Config, in messageHandler: WKScriptMessageHandler) -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true

        var js = ""
        if let jsPath = Bundle.main.path(forResource: "HiWallet-min", ofType: "js") {
            do {
                js += try String(contentsOfFile: jsPath)
            } catch {}
        }

        js += javaScriptForDappBrowser(server: server, address: address)

        // 自适应屏幕宽度js
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width',initial-scale=1.0, maximum-scale=1.0,user-scalable=no\">'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript2 = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(userScript2)

        
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        config.userContentController.add(messageHandler, name: Method.signTransaction.rawValue)
        config.userContentController.add(messageHandler, name: Method.signPersonalMessage.rawValue)
        config.userContentController.add(messageHandler, name: Method.signMessage.rawValue)
        config.userContentController.add(messageHandler, name: Method.signTypedMessage.rawValue)
        config.userContentController.addUserScript(userScript)
        config.preferences.javaScriptEnabled = true
        return config
    }

    fileprivate static func javaScriptForDappBrowser(server: ETHRPCServer, address: String) -> String {
        var initJS = """
         window.addressHex = '\(address)';
         window.rpcURL = '\(server.rpcURL.absoluteString)';
         window.chainID = '\(server.chainID)';
        """

        if let initPath = Bundle.main.path(forResource: "init", ofType: "js") {
            do {
                initJS += try String(contentsOfFile: initPath)
            } catch {}
        }
        return initJS
    }

    func removeAllMessageHandler() {
        userContentController.removeScriptMessageHandler(forName: Method.signTransaction.rawValue)
        userContentController.removeScriptMessageHandler(forName: Method.signPersonalMessage.rawValue)
        userContentController.removeScriptMessageHandler(forName: Method.signMessage.rawValue)
        userContentController.removeScriptMessageHandler(forName: Method.signTypedMessage.rawValue)
    }
}
