//
//  MnemonicServiceInterface.swift
//  TOP
//
//  Created by Jax on 19.07.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation


public protocol MnemonicServiceInterface {
    func wordList() -> [String]
    func wordList(with language: MnemonicLanguage) -> [String]
    func newMnemonic(with language: MnemonicLanguage) -> String
    func seed(from mnemonic: String) -> String
    func keyStoreFile(stringData: String, passwordData: Data) throws -> Data
    func data(from keystoreFile: Data, passwordData: Data) throws -> Data
    func languageForCurrentLocale() -> MnemonicLanguage
}
