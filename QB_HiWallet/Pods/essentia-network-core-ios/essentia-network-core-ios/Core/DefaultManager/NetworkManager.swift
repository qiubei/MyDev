//
//  NetworkManager.swift
//  essentia-bridges-api-ios
//
//  Created by Pavlo Boiko on 05.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation

public class NetworkManager: NetworkManagerInterface {
    private var urlSession: URLSession
    private let serverUrl: String

    public init(_ serverUrl: String) {
        self.serverUrl = serverUrl
        urlSession = URLSession.defaultNetworkSession
    }

    public func request<SuccessModel: Decodable>(
        _ request: RequestProtocol,
        result: @escaping (NetworkResult<SuccessModel>) -> Void
    ) {
        requestData(request) { data, error in
            DispatchQueue.main.async {
                self.handleResponse(response: (data, error), result: result)
            }
        }
    }

    public func requestData(_ request: RequestProtocol, result: @escaping (Data?, Error?) -> Void) {
        let requestBuilder = RequestBuilder(request: request)
        let urlRequest = requestBuilder.build(for: serverUrl)
        switch request.contentType {
        case .json:
            urlSession.dataTask(with: urlRequest) { data, _, error in
                result(data, error)
            }.resume()
        }
        Logger.shared.logEvent(.httpRequest(urlRequest))
    }

    private func handleResponse<SuccessModel: Decodable>(
        response: (Data?, Error?),
        result: @escaping (NetworkResult<SuccessModel>) -> Void
    ) {
        guard let data = response.0 else {
            guard let error = response.1 else {
                result(.failure(.unknownError))
                return
            }
            result(.failure(EssentiaNetworkError.defaultError(error)))
            return
        }
        do {
            let object = try JSONDecoder().decode(SuccessModel.self, from: data)
            result(.success(object))
        } catch {
            Logger.shared.logEvent(.errorEvent(.warning, error))
            handleError(response: data, result: result)
        }
    }

    private func handleError<SuccessModel: Decodable>(
        response: Data,
        result: @escaping (NetworkResult<SuccessModel>) -> Void
    ) {
        let decoder = JSONDecoder()
        do {
            let failedObject = try decoder.decode(EssentiaNetworkError.self, from: response)
            Logger.shared.logEvent(.message(.error, String(describing: failedObject)))
            result(.failure(failedObject))
        } catch {
            Logger.shared.logEvent(.errorEvent(.error, error))
            result(.failure(.unknownError))
        }
    }
}
