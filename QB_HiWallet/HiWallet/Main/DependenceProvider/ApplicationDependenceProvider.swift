//
//  ApplicationDependenceProvider.swift
//  TOP
//
//  Created by Jax on 17.07.18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import TOPCore

class ApplicationDependenceProvider {
    // MARK: - Services
    public func loadDependences() {
        prepareInjection(CurrencyRankDaemon() as CurrencyRankDaemonInterface, memoryPolicy: .viewController)
        prepareInjection(AppStateEventProxy() as AppStateEventProxyInterface, memoryPolicy: .viewController)
        prepareInjection(MnemonicService() as MnemonicServiceInterface, memoryPolicy: .viewController)
        prepareInjection(ViewUserStorageService() as ViewUserStorageServiceInterface, memoryPolicy: .viewController)
        prepareInjection(LocalFilesService() as LocalFilesServiceInterface, memoryPolicy: .viewController)
        prepareInjection(KeychainService() as KeychainServiceInterface, memoryPolicy: .viewController)
        prepareInjection(CurrencyConverterService() as CurrencyConverterServiceInterface, memoryPolicy: .viewController)
        prepareInjection(WalletBlockchainWrapperInteractor() as WalletBlockchainWrapperInteractorInterface, memoryPolicy: .viewController)
        prepareInjection(WalletInteractor() as WalletInteractorInterface, memoryPolicy: .viewController)
    }
}
