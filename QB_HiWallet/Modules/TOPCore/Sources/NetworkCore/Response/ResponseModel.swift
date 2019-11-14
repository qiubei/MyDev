//
//  ResponseModel.swift
//  TOPCore
//
//  Created by Anonymous on 2019/10/15.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import SwiftyJSON
import ObjectMapper

/// * 网络请求响应数据 Model
/// *
/// *  "code":"信息编号",
/// *   "message":"提示信息",
/// * "servertime":"服务器时间",
/// *   "name":"应用程序名称",
/// *   "logno":"日志编号",
/// *   "result":{
/// *   <--响应内容，只有在信息编号为200的时候返回（详见接口文档）-->
/// *   },
/// *   <--分页信息，只有在信息编号为200及分页查询接口中会返回-->
/// *   "pageInfo": {
/// *       "totalCount": "总记录数"
/// *   }
/// *
/// 网络请求响应数据 Model
public struct ResponseModel {
    
    private let json: JSON
    public init(_ data: Data) {
        self.json = JSON(data)
    }
    
    public var code: Int {
        return json["code"].intValue
    }
    
    public var logno: String? {
        return json["logno"].stringValue
    }
    
    public var message: String? {
        return json["message"].stringValue
    }
    
    public var name: String? {
        return json["name"].stringValue
    }
    
    public var servertime: String? {
        return json["servertime"].stringValue
    }
    
    public var result: JSON? {
        let resultJson = json["result"]
        if let jsonStr = resultJson.rawString(), jsonStr.count > 0 {
            return resultJson
        }
        return nil
    }
    
    public var pageInfo: JSON? {
        let resultJson = json["pageInfo"]
        if let jsonStr = resultJson.rawString(), jsonStr.count > 0 {
            return resultJson
        }
        return nil
    }
}


//MARK: - Decode response model with HandyJSON
public extension ResponseModel {
    /// get resut model with HandyJSON Model
    /// - Parameter type: HandyJSON Model
    func mapResultModel<M: HandyJSON>(type: M.Type) -> M? {
        return M.deserialize(from: result?.rawString())
    }
    
    
    /// get info model with HandyJSON Model
    /// - Parameter type: HandyJSON Model
    func mapInfoModel<M: HandyJSON>(type: M.Type) -> M? {
        return M.deserialize(from: pageInfo?.rawString())
    }
    
    func mapResultListModel<M: HandyJSON>(type: M.Type) -> [M]? {
        if let list = [M].deserialize(from: result?.rawString()) {
            let modelList = list.map { $0 ?? M() }
            return modelList
        }
        return nil
    }
}

//MARK: - Decode response model with Codable
public extension ResponseModel {
    func mapResultModel<M: Codable>(type: M.Type) -> M? {
        if let data = try? result?.rawData() {
            return try? JSONDecoder().decode(type, from: data)
        }
        return nil
    }
    
    func mapPageinfoModel<M: Codable>(type: M.Type) -> M? {
        if let data = try? pageInfo?.rawData() {
            return try? JSONDecoder().decode(type, from: data)
        }
        
        return nil
    }
    
    func mapResultListModel<M: Codable>(type: M.Type) -> [M]? {
        if let data = try? result?.rawData() {
            return try? JSONDecoder().decode([M].self, from: data)
        }
        return nil
    }
}

//MARK: - Decode response model with Mappable
public extension ResponseModel {
    func mapResultModel<M: Mappable>(type: M.Type) -> M? {
        if let jsonStr = result?.rawString() {
            return M.init(JSONString: jsonStr)
        }
        return nil
    }
    
    func mapInfoModel<M: Mappable>(type: M.Type) -> M? {
        if let jsonStr = pageInfo?.rawString() {
            return M.init(JSONString: jsonStr)
        }
        return nil
    }
    
    func mapResultListModel<M: Mappable>(type: M.Type) -> [M]? {
        if let jsonString = result?.rawString() {
            let list = Mapper<M>().mapArray(JSONfile: jsonString)
            
            return list
        }
        return nil
    }
}
