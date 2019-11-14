//
//  String+Extension.swift
//  HiWallet
//
//  Created by apple on 2019/5/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

extension LocalizationLanguage {
    var isChinese: Bool {
        if self == .chinese {
            return true
        }
        return false
    }
}

extension String {
    func removeHexPrefix() -> String {
        if hasPrefix("0x") {
            return String(dropFirst(2))
        }
        return self
    }

    func addHexPrefix() -> String {
        if hasPrefix("0x") {
            return self
        }
        return "0x" + self
    }

    func localized(_ comment: String = "") -> String {
        let language = LocalizationLanguage.systemLanguage
        if language.isChinese {
            let path = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
            if let bundle = Bundle(path: path!) {
                return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
            }
        } else {
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            if let bundle = Bundle(path: path!) {
                return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
            }
        }

        return NSLocalizedString(self, comment: comment)
    }

    init?(gbkData: Data) {
        // 获取GBK编码, 使用GB18030是因为它向下兼容GBK
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        // 从GBK编码的Data里初始化NSString, 返回的NSString是UTF-16编码
        if let str = NSString(data: gbkData, encoding: encoding) {
            self = str as String
        } else {
            return nil
        }
    }

    var gbkData: Data {
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        let gbkData = (self as NSString).data(using: encoding)!
        return gbkData
    }

    func hexStringToData() -> Data {
        var hex = replacingOccurrences(of: "0x", with: "")
        var data = Data()
        while hex.count > 0 {
            let c: String = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)]) //  hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...]) // hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }

    func hexStringToInt() -> Int {
        let hex = removeHexPrefix()
        let str = hex.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 { // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    

}
