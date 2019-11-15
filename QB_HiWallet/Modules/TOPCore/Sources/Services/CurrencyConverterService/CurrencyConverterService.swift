//
//  CurrencyConverterService.swift
//  TOP
//
//  Created by Jax on 10/3/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation
import EssentiaNetworkCore



fileprivate struct Constants {
    static var sourceUrl = "https://api.coingecko.com/api/v3"
    static var rankPath = "CurrencyRanks"
}

public class CurrencyConverterService: CurrencyConverterServiceInterface {
    let networkManager: NetworkManager
    let fileStorage: LocalFilesServiceInterface
    
    public init() {
        networkManager = NetworkManager(Constants.sourceUrl)
        fileStorage = LocalFilesService()
    }
    
    public func convertBalance(value: Double, from asset: AssetInterface, to currency: FiatCurrency, convertedValue: @escaping (Double) -> Void) {
        getPrice(for: asset, in: currency) { (price) in
            convertedValue(price * value)
        }
    }
    
    public func getPrice(for asset: AssetInterface, in currency: FiatCurrency, price: @escaping (Double) -> Void) {
        getCoinInfo(from: asset, to: currency) { (info) in
            price(info.currentPrice)
        }
    }
    
    //获取某个币种的价格
    public func getCoinInfo(from asset: AssetInterface, to currency: FiatCurrency, info: @escaping (CoinGeckoCurrencyModel) -> Void) {
        var coinName = asset.name.lowercased().replacingOccurrences(of: " ", with: "-")
        if coinName == "top"{
            coinName = "top-network"
        }
        
        let endpoint = CurrencyConverterEndpoint.getPrice(forCoin: coinName, inCurrency: currency )
        networkManager.request(endpoint) {[weak self] (result: NetworkResult<[CoinGeckoCurrencyModel]>) in
            guard let self = self else { return }
            switch result {
            case .success(let objects):
                guard let object = objects.first else { return }
                self.storeCoinInfo(object, from: asset, to: currency)
                info(object)
            case .failure: break
                
            }
        }
        guard let stored = getCoinInfoFromStorage(from: asset, to: currency) else { return }
        info(stored)
    }
    
    private func storeCoinInfo(_ info: CoinGeckoCurrencyModel, from asset: AssetInterface, to currency: FiatCurrency) {
        _ = try? fileStorage.storeFile(file: info, to: path(with: asset), with: currency.rawValue)
    }
    
    private func getCoinInfoFromStorage(from asset: AssetInterface, to currency: FiatCurrency) -> CoinGeckoCurrencyModel? {
        return try? fileStorage.getFile(path: path(with: asset), name: currency.rawValue)
    }
    
    private func path(with asset: AssetInterface) -> LocalFolderPath {
        return LocalFolderPath.subFolder(Constants.rankPath, .final(asset.name))
    }
}
