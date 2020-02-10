//
//  DAppAction.swift
//  HiWallet
//
//  Created by XiaoLu on 2018/10/12.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

struct DAppAction {
    enum Error: Swift.Error {
        case manifestRequestFailed
        case emptyChainHosts
        case emptyTX
    }
}

struct Manifest: Decodable {
    var shortName: String?
    var name: String?
    var startUrl: String?
    var display: String?
    var themeColor: String?
    var backgroundColor: String?
    var blockViewer: String?
    var chainSet: [String: String]?
    var entry: String?
    var icon: String?

    enum CodingKeys: String, CodingKey {
        case shortName = "short_name"
        case name
        case startUrl = "start_url"
        case display
        case themeColor = "theme_color"
        case backgroundColor = "background_color"
        case blockViewer
        case chainSet
        case entry
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shortName = try? values.decode(String.self, forKey: .shortName)
        name = try? values.decode(String.self, forKey: .name)
        startUrl = try? values.decode(String.self, forKey: .startUrl)
        display = try? values.decode(String.self, forKey: .display)
        themeColor = try? values.decode(String.self, forKey: .themeColor)
        backgroundColor = try? values.decode(String.self, forKey: .backgroundColor)
        blockViewer = try? values.decode(String.self, forKey: .blockViewer)
        chainSet = try? values.decode([String: String].self, forKey: .chainSet)
        entry = try? values.decode(String.self, forKey: .entry)
    }
}
