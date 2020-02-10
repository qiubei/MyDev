//
//  NetworkConfig.swift
//  TOPCore
//
//  Created by Anonymous on 2019/10/15.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

public class NetworkConfig {
    static let `default` = NetworkConfig()
    private init() {}
    #if DEBUG
        var baseURL: String {
            return UserDefaults.standard.bool(forKey: "ETHChain_Main") ?
                "https://www.hiwallet.org/hiwallet" : // 正式
                "http://178.128.84.127:8090" // 测试
        }

    #else
        let baseURL = "https://www.hiwallet.org/hiwallet" // 正式
    #endif

    let accessID = "92bfca8adf52f522f418d052ceec74ff"
    let accessKey = "KAMAhTqZFy2hgt2i0CCAd/XYsB8dK9gYVNHdPh+RYJWmxJIyt0ofXA=="
    let contentType = "application/json"
}
