//
//  PushManager.swift
//  TOPCore
//
//  Created by Jax on 2019/12/13.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import RealmSwift
import UIKit

public enum ResultBlock<M, N: Error> {
    case success(model: M)
    case failure(error: N)
}

public class PushManager: NSObject {
    fileprivate var readQueue = DispatchQueue(label: "top.network.DB.read", attributes: [])
    public static let shared = PushManager()

    public var unReadCountNum: Int {
        return getUnReadCountNum()
    }

    public var deviceToken: String? //推送ID,获取到要进行赋值

    public var deviceID: String { //设备ID
        return KCID.getKCID()
    }

    public var AllMessage: [PushMessage] {
        return loadAllMessage()
    }
}

//上报操作
public extension PushManager {
    
    //设置推送ID
    func setDeviceToken(deviceToken: String) {
        self.deviceToken = deviceToken
    }

    func uploadDevice() {
        guard deviceToken != nil else {
            return
        }
        TOPNetworkManager<PushServices, EmptyResult>.requestModel(.uploadDevice, success: { _ in
            DLog("LOGGER: upload device!")
        }) { error in
            DLog(error)
        }
    }
    
    func removeUser() {
        TOPNetworkManager<PushServices, EmptyResult>.requestModel(.removeUser, success: { _ in
            DLog("LOGGER: remove user!")
        }) { error in
            DLog(error)
        }
    }
    
    
    func removeWallets(assets: [ViewWalletInterface]) {
        TOPNetworkManager<PushServices, EmptyResult>.requestModel(.removeWallets(assets: assets), success: { _ in
            DLog("LOGGER: remove assets!")
        }) { error in
            DLog(error)
        }
    }

    func uploadWallets(assets: [ViewWalletInterface]) {
        TOPNetworkManager<PushServices, EmptyResult>.requestModel(.uploadWallets(assets: assets), success: { _ in
            DLog("LOGGER: upload assets!")
        }) { error in
            DLog(error)
        }
    }
}

//数据库存储
extension PushManager {
    
    public func readAllMessage(completion: EmptyBlock?) {
        readQueue.async {
            let realm = try! Realm()
            let result = realm.objects(LocalNoticationMessage.self).filter({ !$0.isRead})
            try! realm.write {
                for element in result {
                    element.isRead = true
                }
                
                completion?()
            }
        }
    }
    
    public func readMessage(messageID: String) {
        let result = (try! Realm()).objects(LocalNoticationMessage.self).filter({
            $0.id == messageID
        }).first

        if let msg = result {
            try! Realm().write {
                msg.isRead = true
            }
        }
    }

    //获取所有未读
    private func loadAllMessage() -> [PushMessage] {
        do {
            let results = try Realm().objects(LocalNoticationMessage.self)
            return results.map { PushMessage(localMessage: $0) }.sorted { $0.time > $1.time }
        } catch {
            DLog("laod message realm failed")
            return []
        }
    }

    //插入一条新消息

    @discardableResult
    public func insertNewMessage(message: PushMessage) -> Bool {
        if message.type == .AWAKEN || message.type == .TRANSACTION { return false }
        do {
            if checkExist(id: message.id) {
                return true
            }
            let realm = try Realm()
            let msg = LocalNoticationMessage(model: message)
            try realm.write {
                realm.add(msg)
            }
            return true
        } catch {
            return false
        }
    }

    private func checkExist(id: String) -> Bool {
        do {
            let realm = try Realm()
            let results = realm.objects(LocalNoticationMessage.self)
            let object = results.filter { $0.id == id }
            return object.count > 0
        } catch {
            DLog("read message realm failed!")
            return false
        }
    }
    
    //获取未读消息的数目
    private func getUnReadCountNum() -> Int {
        return (try! Realm()).objects(LocalNoticationMessage.self).filter({
            $0.isRead == false && $0.type != "TRANSACTION"
        }).count
    }

    //h删除钱包的时候清空数据库

    @discardableResult
    public func deleteAllMessage() -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(LocalNoticationMessage.self))
            }
            return true
        } catch {
            return false
        }
    }
}
