//
//  BaseRequestParameters.swift
//  TOPCore
//
//  Created by Anonymous on 2019/10/24.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import HandyJSON

extension Parameters {
    func encodeBodyToBase64String() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .sortedKeys) {
            let base64 = data.base64EncodedData()
            let string = String.init(data: base64, encoding: .utf8)
            return string ?? ""
        }
        return ""
    }
    
    func encodeBodyToHmac(_ accessKey: String) -> String {
        return encodeBodyToBase64String().hmac(algorithm: .sha1, key: accessKey).urlEncode()
    }
}
