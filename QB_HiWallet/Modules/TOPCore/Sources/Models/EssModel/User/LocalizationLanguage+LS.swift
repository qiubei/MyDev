//
//  LocalizationLanguage+LS.swift
//  TOP
//
//  Created by Jax on 1/10/19.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation


extension LocalizationLanguage {
    public var titleString: String {
        switch self {
        case .english:
            return "LocalizationLanguage.English"
        case .korean:
            return  "LocalizationLanguage.Korean"
        case .chinese:
            return "LocalizationLanguage.Chinese"
        }
    }
}
