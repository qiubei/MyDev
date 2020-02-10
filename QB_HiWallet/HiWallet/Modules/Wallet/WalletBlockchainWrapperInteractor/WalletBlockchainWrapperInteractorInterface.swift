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

import TOPCore

public protocol WalletBlockchainWrapperInteractorInterface {
    func getCoinBalance(for coin: ChainType, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void)
    func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void)
    func txRawParametrs(for asset: AssetInterface, toAddress: String, ammountInCrypto: String, data: Data) throws -> (value: Wei, address: String, data: Data)
    func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (String) -> Void, failure: @escaping (TOPHttpError) -> Void) throws
    func getTxHistoryByWallet(_ wallet: WalletProtocol, pageNum: NSInteger, transactions: @escaping ([HistoryTxModel]) -> Void, failure: @escaping (TOPHttpError) -> Void)

}
