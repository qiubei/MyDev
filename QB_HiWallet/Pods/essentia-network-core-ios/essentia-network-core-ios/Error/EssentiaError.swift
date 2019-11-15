//
//  EssentiaError.swift
//  essentia-network-core-ios
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public enum EssentiaNetworkError: Error, Decodable {
    case error(ErrorMessage)
    case unknownError
    case defaultError(Error)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let leftValue = try container.decode(String.self, forKey: .error)
            self = .error(ErrorMessage(error: leftValue))
        } catch {
            self = .unknownError
        }
    }
    
    enum CodingKeys: CodingKey {
        case unknownError, error
    }
    
    public var localizedDescription: String {
        switch self {
        case .unknownError:
            return "Unknows error"
        case .error(let message):
            return message.error
        case .defaultError(let error):
            return error.localizedDescription
        }
    }
}
