//
//  NetworkManagerInterface.swift
//  essentia-bridges-api-ios
//
//  Created by Pavlo Boiko on 05.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public protocol NetworkManagerInterface {
    
    func request<SuccessModel: Decodable> (
        _ request: RequestProtocol,
        result: @escaping (NetworkResult<SuccessModel>) -> Void
    )
    
    func requestData(_ request: RequestProtocol, result: @escaping (Data?, Error?) -> Void)
}
