//
//  DateFormat.swift
//  TOPModel
//
//  Created by Jax on 12/26/18.
//  Copyright © 2018 Jax. All rights reserved.
//

import Foundation

public enum DateFormat: String {
    case UTCFullDate = "yyyy-MM-dd'T'HH:mm:ss"
    case UTCFullDateZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case date = "dd.MM.yy"
    case dateTime = "yyyy/MM/dd HH:mm:ss"
    case dayMonth = "d MMMM YYYY"
}

public extension DateFormatter {
    convenience init(formate: DateFormat) {
        self.init()
        dateFormat = formate.rawValue
    }
}
