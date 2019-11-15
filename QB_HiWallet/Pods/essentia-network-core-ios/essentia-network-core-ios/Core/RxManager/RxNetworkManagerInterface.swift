//
//  RxNetworkManagerInterface.swift
//  essentia-network-core-ios
//
//  Created by Pavlo Boiko on 7/18/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import RxSwift

public protocol RxNetworkManagerInterface {
    func request<SuccessModel: Decodable>(_ request: RequestProtocol) -> Observable<SuccessModel>
    func requestData(_ request: RequestProtocol) -> Observable<Data>
}
