//
//  CurrencyRankDaemonInterface.swift
//  TOP
//
//  Created by Jax on 10/5/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public protocol CurrencyRankDaemonInterface {
    func update()
    func update(callBack: @escaping () -> Void)
}
