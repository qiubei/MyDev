//
//  RxNetworkManager.swift
//  essentia-network-core-ios
//
//  Created by Pavlo Boiko on 7/18/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import RxSwift

public class RxNetworkManager: RxNetworkManagerInterface {
    private let networkManager: NetworkManager
    
    public init(url: String) {
        self.networkManager = NetworkManager(url)
    }
    
    public func request<SuccessModel: Decodable>(_ request: RequestProtocol) -> Observable<SuccessModel> {
        return Observable.create({ (observer) -> Disposable in
            self.networkManager.request(request, result: { (result: NetworkResult<SuccessModel>) in
                switch result {
                case .success(let object):
                    observer.onNext(object)
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        })
    }
    
    public func requestData(_ request: RequestProtocol) -> Observable<Data> {
        return Observable.create({ (observer) -> Disposable in
            self.networkManager.requestData(request, result: { (data, error) in
                guard let data = data else {
                    guard let error = error else {
                        observer.onError(EssentiaNetworkError.unknownError)
                        return
                    }
                    observer.onError(error)
                    return
                }
                observer.onNext(data)
            })
            return Disposables.create()
        })
    }
}
