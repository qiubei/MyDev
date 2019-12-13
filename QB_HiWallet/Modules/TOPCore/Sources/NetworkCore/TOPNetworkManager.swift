//
//  TOPRequest.swift
//  TOPCore
//
//  Created by Anonymous on 2019/10/15.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import Moya
import Result
import SwiftyJSON

public typealias EmptyBlock = () -> Void
public typealias ActionBlock<M> = (M) -> Void

public typealias SuccessListResponse<M> = (_ response: [M]?, _ pageInfo: PageInfoModel?) -> Void
public typealias SuccessResponse = (ResponseModel) -> Void
public typealias FailureResponse = (TOPHttpError) -> Void

private let showLog = true // 显示日志

public class TOPNetworkManager<TopTarget: TargetType, M> {
    fileprivate class func request(_ target: TopTarget, success: SuccessResponse? = nil, failure: FailureResponse? = nil) {
        let completion = { (result: Result<Moya.Response, MoyaError>) -> Void in
            switch result {
            case let .success(response):

                let string = String(data: response.data, encoding: .utf8)
                if let data = string?.data(using: .utf8) {
                    success?(ResponseModel(data))
                }
            case let .failure(error):

                let message = error.localizedDescription
                let _error = TOPHttpError.serverResponse(message: message, code: error.errorCode)
                failure?(_error)
            }
        }

        let provider = getProvider()

        provider.request(target, completion: completion)
    }

    /// 获取 MoyaProvider
    ///
    /// - Returns: MoyaProvider
    fileprivate class func getProvider() -> MoyaProvider<TopTarget> {
        let providerParameter = TOPHttpProviderParameter<TopTarget>()
        let provider = MoyaProvider<TopTarget>(endpointClosure: providerParameter.endpointClosure, requestClosure: providerParameter.requestClosure, stubClosure: providerParameter.stubClosure, callbackQueue: nil, manager: .default, plugins: providerParameter.plugins, trackInflights: false)
        return provider
    }

    /// 取消所有请求
    public class func cancelAllRequest() {
        getProvider().manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

    /// 取消所有请求
    public class func cancelRequestWith(urlStr: String) {
        getProvider().manager.session.getAllTasks { tasks in

            tasks.forEach({ task in
                if task.currentRequest?.url?.absoluteString == urlStr {
                    task.cancel()
            } })
        }
    }
}

public struct TOPHttpProviderParameter<TopTarget: TargetType> {
    // endpoint
    var endpointClosure = { (target: TopTarget) -> Endpoint in
        // 可以在此处统一配置header，或者通过manager的方式配置
        var dic: [String: String] = [:]

        let headers = dic
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: headers)
    }

    // request
    var requestClosure = { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
        do {
            var urlRequest = try endpoint.urlRequest()
            urlRequest.timeoutInterval = 20
            closure(.success(urlRequest))
        } catch let MoyaError.requestMapping(url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch let MoyaError.parameterEncoding(error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }

    // stub
    var stubClosure = { (_: TopTarget) -> StubBehavior in
        .never
    }

    // plugins
    var plugins: [PluginType] {
        let hudPlugin = NetworkHUDPlugin<TopTarget>()
        #if DEBUG
            return [hudPlugin, RequestHeaderPlugin<TopTarget>(), NetworkLoggerPlugin<TopTarget>()]
        #else
            return [hudPlugin, RequestHeaderPlugin<TopTarget>()]
        #endif
    }
}

public extension TOPNetworkManager where M: HandyJSON {
    class func requestModel(_ target: TopTarget, success: ActionBlock<M>? = nil, failure: FailureResponse? = nil) {
        request(target, success: { response in
            if let result = response.mapResultModel(type: M.self) {
                success?(result)
            } else {
                DLog("request is \(target.path)")
                let message = response.message ?? "message is empty!"
                let error = TOPHttpError.jsonSerializationFailed(message: message)
                failure?(error)
            }
        }, failure: failure)
    }

    class func requestModelList(_ target: TopTarget, success: SuccessListResponse<M>? = nil, failure: FailureResponse? = nil) {
        request(target, success: { response in

            do {
                _ = try response.filterSuccessfulStatusCodes()

                if response.code == ResponseCode.noContant {
                    success?([], nil)
                } else {
                    if let list = response.mapResultListModel(type: M.self) {
                        let pageInfo = response.mapInfoModel(type: PageInfoModel.self)
                        success?(list, pageInfo)
                    } else {
                        let message = response.message ?? "message is empty!"
                        let error = TOPHttpError.jsonSerializationFailed(message: message)
                        failure?(error)
                    }
                }
            } catch {
                failure?(error as! TOPHttpError)
            }
        }, failure: failure)
    }
}

public extension TOPNetworkManager where M: Codable {
    class func requestModel(_ target: TopTarget, success: ActionBlock<M>? = nil, failure: FailureResponse? = nil) {
        request(target, success: { response in
            if let result = response.mapResultModel(type: M.self) {
                success?(result)
            } else {

                let message = response.message ?? "message is empty!"
                let error = TOPHttpError.jsonSerializationFailed(message: message)
                failure?(error)
            }

        }, failure: failure)
    }

    class func requestModelList(_ target: TopTarget, success: SuccessListResponse<M>? = nil, failure: FailureResponse? = nil) {
        request(target, success: { response in

            do {
                _ = try response.filterSuccessfulStatusCodes()

                if response.code == ResponseCode.noContant {
                    success?([], nil)
                } else {
                    if let list = response.mapResultListModel(type: M.self) {
                        success?(list, response.mapInfoModel(type: PageInfoModel.self))
                    } else {

                        let message = response.message ?? "message is empty!"
                        let error = TOPHttpError.jsonSerializationFailed(message: message)
                        failure?(error)
                    }
                }
            } catch {
                failure?(error as! TOPHttpError)
            }
        }, failure: failure)
    }
}

// hud plugin(hud提示, 可根据项目自由配置,这里先注释掉)
private final class NetworkHUDPlugin<TopTarget: TargetType>: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// networkLogger plugin(请求debug log)
private final class NetworkLoggerPlugin<TopTarget: TargetType>: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        let requestLogString = """
        ******************************************* NetworkRequestLogger:*******************************************
        Url: \(request.request?.url?.absoluteString ?? "空")
        Method: \(target.method)
        Parameter: \(target.task)
        Header: \(request.request?.allHTTPHeaderFields ?? [:])
        """
        if showLog {
            DLog(requestLogString)
        }
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        var responseLogString = """
        *******************************************NetworkResponseLogger:*******************************************
        """
        switch result {
        case let .success(response):
            do {
                _ = try response.filterSuccessfulStatusCodes()
                let jsonData = JSON(response.data)
                let successLogString = """
                StatusCode: "\(response.statusCode)"
                RquestSuccesseData: "\(jsonData)"
                """
                if showLog {
                    DLog(successLogString)
                }
            } catch {
                let jsonData = JSON(response.data)
                let errCode = jsonData["code"].intValue
                let errMsg = jsonData["msg"].stringValue
                let failureLogString = """
                StatusCode: "\(errCode)"
                ErrorCode: "\(errMsg)"
                """
                if showLog {
                    DLog(failureLogString)
                }
            }

        case let .failure(error):
            var failureLogString = """
            ErrorCode: "\((error as NSError).code)"
            ErrorMsg: "\(error.localizedDescription)"
            """
            if let errorData = error.response?.data {
                failureLogString += """
                ErrorResponseData: "\(errorData)"
                """
            }
            responseLogString += failureLogString
        }

        if showLog {
            DLog(responseLogString)
        }
    }
}

// request header plugin
private final class RequestHeaderPlugin<TopTarget: TargetType>: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        // 添加签名

        var request = request

        var dic: [String: String] = [:]
        dic["accessid"] = NetworkConfig.default.accessID
        if let body = request.httpBody {
            let bodyStr = String(bytes: body.bytes, encoding: .utf8)
            let sign = bodyStr?.hmac(algorithm: .sha1, key: NetworkConfig.default.accessKey).urlEncode()
            dic["signature"] = sign
        }
        dic["Content-Type"] = NetworkConfig.default.contentType
        request.allHTTPHeaderFields = dic
        return request
    }
}

public extension TargetType {
    // 默认参数类型
    func defaultEcodingRequestTaskWith(parameters: [String: Any?]) -> Task {
        // 过滤parameters中value=nil的参数
        var filterOptionalParameters = [String: Any]()
        parameters.forEach {
            if let any = $1 {
                filterOptionalParameters[$0] = any
            }
        }

        return Task.requestParameters(parameters: filterOptionalParameters, encoding: URLEncoding.default)
    }

    // MARK: - 通用参数统一处理

    var baseURL: URL {
        return URL(string: NetworkConfig.default.baseURL)!
    }

    var headers: [String: String]? {
        return nil
    }

    // moya提供的stubs功能，暂时不使用
    var sampleData: Data {
        return Data()
    }
}
