//
//  KeychainService.swift
//  TOPCore
//
//  Created by Jax on 4/15/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation
import KeychainAccess

fileprivate var keychainService = "TOP.HiWallet"

public enum KeychainOperation<T> {
    case success(T)
    case failure(Error)
}

public typealias KeychainOperationUpdate = (KeychainOperation<Void>) -> Void
public typealias KeychainOperationGet = (KeychainOperation<String?>) -> Void

public class KeychainService: KeychainServiceInterface {
    private let keychain: Keychain
    private let keychainQueue: DispatchQueue
    private let responceQueue: DispatchQueue
    
    public init() {
        keychain = Keychain(service: keychainService)
        keychainQueue = DispatchQueue(label: keychainService, qos: .utility, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        responceQueue = DispatchQueue.main
    }
    
    public func storePassword(userId: String, password: String, result: @escaping KeychainOperationUpdate) {
        keychainQueue.async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .touchIDAny)
                    .set(password, key: userId)
                self.responceQueue |> (KeychainOperation.success(()), result)
            } catch {
                self.responceQueue |> (KeychainOperation.failure(error), result)
            }
        }
    }
    
    public func getPassword(userId: String, result: @escaping KeychainOperationGet) {
        keychainQueue.async {
            do {
             let pass = try self.keychain
                .authenticationPrompt("从钥匙串中获取密码")
                .get(userId)
                self.responceQueue |> (KeychainOperation.success(pass), result)
            } catch {
                 self.responceQueue |> (KeychainOperation.failure(error), result)
            }
        }
    }
    
    public func removePassword(userId: String, result: @escaping KeychainOperationUpdate) {
        keychainQueue.async {
            do {
                try self.keychain.remove(userId)
                self.responceQueue |> (KeychainOperation.success(()), result)
            } catch {
                self.responceQueue |> (KeychainOperation.failure(error), result)
            }
        }
    }
}
