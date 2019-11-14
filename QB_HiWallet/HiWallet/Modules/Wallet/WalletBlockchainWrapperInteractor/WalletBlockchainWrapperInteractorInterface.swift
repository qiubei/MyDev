//
//  WalletBlockchainWrapperInteractorInterface.swift
//  TOP
//
//  Created by Jax on 10/4/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import EssentiaBridgesApi
import EssentiaNetworkCore
import Foundation
import HDWalletKit
import TOPCore

public protocol WalletBlockchainWrapperInteractorInterface {
    func getCoinBalance(for coin: MainCoin, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void)
    func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void)
    func getTokenTxHistory(address: EssentiaBridgesApi.Address, smartContract: EssentiaBridgesApi.Address, result: @escaping (NetworkResult<EthereumTokenTransactionByAddress>) -> Void)

//    func getGasSpeed(prices: @escaping (Double, Double, Double) -> Void)
    func getEthGasEstimate(fromAddress: String, toAddress: String, data: String, result: @escaping (NetworkResult<EthereumNumberValue>) -> Void)

    func txRawParametrs(for asset: AssetInterface, toAddress: String, ammountInCrypto: String, data: Data) throws -> (value: Wei, address: String, data: Data)
    func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (TOPNetworkResult<String>) -> Void) throws
    func getTransactionsByWallet(_ wallet: WalletProtocol, transactions: @escaping ([ViewTransaction]) -> Void, failure: @escaping (TOPHttpError) -> Void)
}
