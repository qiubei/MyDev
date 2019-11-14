//
//  KCID.swift
//  HiWallet
//
//  Created by Jax on 2019/7/12.
//  Copyright © 2019 TOP. All rights reserved.
//  封装获取唯一识别码

import UIKit
import KeychainAccess

class KCID: NSObject {
    
    class func getKCID() -> String {
        
        if let KCID = getKCIDFromKeyChain() {
            return KCID
        }
        else{
            let uuid = NSUUID.init().uuidString
            saveKCID(kcid: uuid)
            return uuid
        }
    }
    
    
    class  func getKCIDFromKeyChain() -> String? {
        
        let keychain =  Keychain(service:"org.topnetwork.KCID")
        return keychain["KCID"]
    }
    
    private  class func saveKCID(kcid:String){
        
        let keychain =  Keychain(service:"org.topnetwork.KCID")
        keychain["KCID"] = kcid
        
    }
    
}
