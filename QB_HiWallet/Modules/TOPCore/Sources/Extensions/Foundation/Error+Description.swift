//
//  Error+Description.swift
//  TOPCore
//
//  Created by Jax on 2/14/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation
import EssentiaNetworkCore


public extension Error {
    var description: String {
        switch self {
        case let error as EssentiaNetworkError:
            return error.localizedDescription
        case let error as EssentiaError:
            return error.localizedDescription
        default:
            return localizedDescription
        }
    }
}
