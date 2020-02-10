//
//  RequestProtocol.swift
//  essentia-bridges-api-ios
//
//  Created by Pavlo Boiko on 05.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public typealias HTTPHeader = [String: String]
public typealias HTTParametrs = [String: Any]

fileprivate enum Constants {
    static var jsonContentType = "application/json"
}

public enum RequestType {
    case post, get, put, patch, delete, head, trace, connect
    public var description: String {
        return String(describing: self).uppercased()
    }
}

public enum RequestContentType {
    case json
    public var description: String {
        switch self {
        case .json:
            return Constants.jsonContentType
        }
    }
}

public protocol RequestProtocol {
    var path: String { get }
    var extraHeaders: HTTPHeader? { get }
    var parameters: HTTParametrs? { get }
    var requestType: RequestType { get }
    var contentType: RequestContentType { get }
}
