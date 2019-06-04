//
//  Log.swift
//  BLESDK
//
//  Created by HyanCat on 2018/5/25.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation

var __enableLog = true

func DLog(_ items: Any...) {
    if __enableLog {
        print("[INNERPEACE-SDK] \(items)")
    }
}
