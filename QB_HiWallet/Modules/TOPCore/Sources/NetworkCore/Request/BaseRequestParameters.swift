//
//  BaseRequestParameters.swift
//  TOPCore
//
//  Created by Anonymous on 2019/10/24.
//  Copyright © 2019 TOP. All rights reserved.
//

import Alamofire
import Foundation
import HandyJSON
import SwiftyJSON

extension Parameters {
    mutating func encodeBodyToBase64String() -> String {
        
        self["language"] = LocalizationLanguage.systemLanguage.isChinese ? "CN" : "EN" //
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .sortedKeys) {
            let base64 = data.base64EncodedData()
            let string = String(data: base64, encoding: .utf8)
            return string ?? ""
        }
        return ""
    }

    mutating func encodeBodyToHmac(_ accessKey: String) -> String {
        return encodeBodyToBase64String().hmac(algorithm: .sha1, key: accessKey).urlEncode()
    }
}
