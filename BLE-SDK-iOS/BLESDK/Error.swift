//
//  Error.swift
//  BLESDK
//
//  Created by HyanCat on 2018/5/17.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation

/// 所有的 Error
public enum InnerpeaceError: Error {
    case timeout
    case invalid(message: String)
    case busy
}
