//
//  EthereumMessageSigner.swift
//  HiWallet
//
//  Created by James Chen on 2018/11/30.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import HDWalletKit
import secp256k1

/// Ethereum Message Signer
// TODO: Web3swift should've already provided these.
public struct EthereumMessageSigner {
    public enum SignError: Error {
        
        case invalidPrivateKey
        case invalidSignature
    }
    public init(){} 
    public func signPersonalMessage(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try sign(message: appendPersonalMessagePrefix(for: message), privateKey: privateKey, useExtraEntropy: useExtraEntropy)
    }

    public func sign(message: Data, privateKey: String, useExtraEntropy: Bool = true) throws -> String? {
        return try signHash(hashMessage(message), privateKey: privateKey, useExtraEntropy: useExtraEntropy).toHexString().addHexPrefix()
    }

    public func hashMessage(_ message: Data) -> Data {
        return message.sha3(.keccak256)
    }

    public func hashPersonalMessage(_ personalMessage: Data) -> Data? {
        return hashMessage(appendPersonalMessagePrefix(for: personalMessage))
    }
}

private extension EthereumMessageSigner {
    func signHash(_ hash: Data, privateKey: String, useExtraEntropy: Bool) throws -> Data {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw SignError.invalidPrivateKey
        }
        let serializedSignature = try? Crypto.sign(hash, privateKey: privateKeyData)

        guard var signature = serializedSignature else {
            throw SignError.invalidSignature
        }
        signature[64] += 27
        return signature
    }

    func appendPersonalMessagePrefix(for message: Data) -> Data {
        let prefix = "\u{19}Ethereum Signed Message:\n\(message.count)"
        let prefixData = prefix.data(using: .ascii)!
        if message.count >= prefixData.count && prefixData == message[0 ..< prefixData.count] {
            return message
        } else {
            return prefixData + message
        }
    }
}
