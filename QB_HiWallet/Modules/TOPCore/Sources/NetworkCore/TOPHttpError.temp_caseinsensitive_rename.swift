//
//  RainHttpError.swift
//  RainHttpManager
//
//  Created by rainedAllNight on 2018/5/10.
//  Copyright © 2018年 luowei. All rights reserved.
//

import Foundation

public struct ResponseCode {
    static let successResponseStatus = 200     // 接口调用成功
    static let forceLogoutError = 1000    // 请重新登录
    //...
}

public enum TOPHttpError: Error {
    
    // json解析失败
    case jsonSerializationFailed(message: String)
    
    // json转字典失败
    case jsonToDictionaryFailed(message: String)
    
    // 服务器返回的错误
    case serverResponse(message: String, code: Int)
    
    //其他
    case other(message: String, code: Int)
}

extension TOPHttpError {
    
    var message: String {
        switch self {
        case .serverResponse(let message, _):
            return message
            
        case .jsonToDictionaryFailed(let message):
            return "json转字典失败: \(message)"
            
        case .jsonSerializationFailed(let message):
            return "json解析失败: \(message)"
            
        case .other(let message, _):
            return message
        }
    }
    
    var code: Int {
        switch self {
        case .serverResponse(_, let code):
            return code

        case .other(_, let code):
            return code
            
        default:
            return -1
        }
    }
}


