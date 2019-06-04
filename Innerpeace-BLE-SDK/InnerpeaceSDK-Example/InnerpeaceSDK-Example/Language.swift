//
//  Language.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/15.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation

/// 多语言规范：希望多语言文件和 xcode 提供的语言类别名称一致，同时 enum 与前面保持一致。
/// 多语言: raw value 最好与本地多语言文件名一致
public enum Language: String {
    case zh_CN = "zh_CN"
    case en = "en"
}

/// Language 实现扩展
extension Language {
    public static var `default` = Language.zh_CN
    public static var current = Language.default

    public static func initLocal() {
        self.current = self.detectLanguage()
    }

    public static func load() {
        self.current = self.detectLanguage()
    }

    /// 根据选择的语言读取文件，并以字典的形式返回文件内容
    ///
    /// - Parameter language: 语言类别，默认取 Language.default
    /// - Returns: 多语言内容的字典
    public static func dic(_ language: Language = .default) -> [String: String]? {
        let languageFilePath = Bundle.main.path(forResource: language.rawValue, ofType: ".strings")
        if let path = languageFilePath {
            return NSDictionary(contentsOfFile: path) as? [String: String]
        } else {
            print("could not find specified language file")
        }
        return nil
    }
}

extension Language {

    /// 检查是否中文
    ///
    /// - Returns: true 是中文，false 不是
    fileprivate static func checkLocalChinese() -> Bool {
        if let chinese = NSLocale.preferredLanguages.first, chinese.contains("zh-Han") {
            return true
        }
        return false
    }


    /// 根据手机本地选中的语言给出对应要展示的语言
    ///
    /// - Returns: 返回你所支持的多语言。
    fileprivate static func detectLanguage() -> Language {
        if checkLocalChinese() {
            return .zh_CN
        }

        // other country language lcoalization
        if let currentLanguage = NSLocale.preferredLanguages.first,
            let country = currentLanguage.split(separator: "-").first,
            let localIdentifier = Language(rawValue: String(country))  {
            return localIdentifier
        }

        return .en
    }
}

/// 多语言对应的字典数据
fileprivate var languageDic: [String: String]?
public func lang(_ key: String, default: String? = nil) -> String {
    if languageDic == nil {
        languageDic = Language.dic(Language.current)
    }

    if let dic = languageDic, let value = dic[key] {
        return value
    } else {
        return `default` ?? key
    }
}
