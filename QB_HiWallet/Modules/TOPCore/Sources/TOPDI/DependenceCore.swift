//
//  DependenceCore.swift
//  TOP
//
//  Created by Jax on 17.07.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

fileprivate let diEngine = DIEngine()

public func prepareInjection<T: Any>(_ injection: T, memoryPolicy: ObjectScope) {
    let key = String(describing: T.self)
    diEngine.load(dependence: injection as AnyObject, key: key, scope: memoryPolicy)
}

public func inject<T>() -> T {
    let key = String(describing: T.self)
    let result = diEngine.resolve(key: key) as T?
    return result!
}

public func relese<T>(_ injection: T) {
    let key = String(describing: T.self)
    diEngine.relese(key: key)
}
