//
//  DefaultNetworkSession.swift
//  essentia-network-core-ios
//
//  Created by Pavlo Boiko on 7/18/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation

public extension URLSession {
    static var defaultNetworkSession: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadRevalidatingCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }
}
