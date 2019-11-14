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
                "https://www.hiwallet.org/hiwallet/v1/app/" : // 正式
                "http://128.199.174.23:8090/v1/app/" // 测试
        }

    #else
        let baseURL = "https://www.hiwallet.org/hiwallet/v1/app/" // 正式
    #endif
    
    let accessID = "8412f654f8662d033111fc453edc5b63"
    let accessKey = "c4jWPrC8mdRC+Nt3ftdwDDi564O3L0+FqMjRRHwHigBwmmoSZB7Pug=="
    let contentType = "application/json"
}
