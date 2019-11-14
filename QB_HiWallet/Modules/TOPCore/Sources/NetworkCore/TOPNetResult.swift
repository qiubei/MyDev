//
//  TOPNetResult.swift
//  TOPCore
//
//  Created by Jax on 2019/9/26.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

public enum TOPNetworkResult<Object: Decodable> {
    case success(Object)
    case failure(String)
}
