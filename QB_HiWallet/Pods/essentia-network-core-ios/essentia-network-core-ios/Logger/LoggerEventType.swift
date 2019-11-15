//
//  LoggerEventType.swift
//  essentia-bridges-api-ios
//
//  Created by Pavlo Boiko on 09.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static var infoMarker = "🔷 "
    static var warningMarker = "⚠️ "
    static var errorMarker = "❗️ "
    static var httpRequestMarker = "🌏 "
}

public enum LoggerEventMessageType {
    case info
    case warning
    case error
    
    var consoleMarker: String {
        switch self {
        case .info:
            return Constants.infoMarker
        case .warning:
            return Constants.warningMarker
        case .error:
            return Constants.errorMarker
        }
    }
}

public enum LoggerEventType {
    case message(LoggerEventMessageType, String?)
    case errorEvent(LoggerEventMessageType, Error)
    case httpRequest(URLRequest)
    
    var consoleMarker: String {
        switch self {
        case .errorEvent(let event, _):
            return event.consoleMarker
        case .message(let event, _):
            return event.consoleMarker
        case .httpRequest:
            return Constants.httpRequestMarker
        }
    }
}
