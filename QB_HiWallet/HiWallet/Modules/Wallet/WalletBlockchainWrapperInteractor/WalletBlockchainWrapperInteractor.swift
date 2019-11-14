//
//  WalletBlockchainWrapperInteractor.swift
//  TOP
//
//  Created by Jax on 10/4/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import EssentiaBridgesApi
import EssentiaNetworkCore
import Foundation
import HDWalletKit
import Moya
import TOPCore

public class WalletBlockchainWrapperInteractor: WalletBlockchainWrapperInteractorInterface {
    private var cryptoWallet: CryptoWallet

    public init() {
        cryptoWallet = CryptoWallet(bridgeApiUrl: TOPConstants.bridgeUrl,
                                    etherScanApiKey: TOPConstants.ethterScanApiKey)
    }

    public func getCoinBalance(for coin: MainCoin, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void) {
        switch coin {
        case .bitcoin, .bitcoinCash, .litecoin, .dash:
            let utxoWallet = cryptoWallet.utxoWallet(coin: coin)
            utxoWallet.getBalance(for: address) { result in
                switch result {
                case let .success(obect):
                    balance(obect)
                case .failure:
                    failure()
                    Toast.hideHUD()
                }
            }
        case .ethereum:

            TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getBalance(address: address), success: { model in

                balance(Double(model.balance) ?? 0)

            }, failure: { _ in
                failure()
            })

        case .topnetwork:

            TOPNetworkManager<TOPService, BalanceModel>.requestModel(.getBalance(address: address), success: { model in
                balance(Double(model.balance) ?? 0)
            }) { _ in
                failure()
            }

        case .unknowCoin:
            return
        }
    }

    public func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void) {
        TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getERC20Balance(address: address, contract: token.contractAddress), success: { model in

            let balanceNum = (Decimal(string: model.balance)! / pow(10, token.decimals)) as NSDecimalNumber
            balance(balanceNum.doubleValue)

        }, failure: { _ in
            failure()
        })
    }

    public func getTokenTxHistory(address: EssentiaBridgesApi.Address, smartContract: EssentiaBridgesApi.Address, result: @escaping (NetworkResult<EthereumTokenTransactionByAddress>) -> Void) {
        cryptoWallet.ethereum.getTokenTxHistory(for: address, smartContract: smartContract, result: result)
    }

    public func getEthGasEstimate(fromAddress: String, toAddress: String, data: String, result: @escaping (NetworkResult<EthereumNumberValue>) -> Void) {
        cryptoWallet.ethereum.getGasEstimate(from: fromAddress, to: toAddress, data: data, result: result)
    }

    public func txRawParametrs(for asset: AssetInterface, toAddress: String, ammountInCrypto: String, data: Data) throws -> (value: Wei, address: String, data: Data) {
        switch asset {
        case let token as Token:
            let value = Wei(integerLiteral: 0)
            let erc20Token = ERC20(contractAddress: token.contractAddress, decimal: token.decimals, symbol: token.symbol)
            let data = try Data(hex: erc20Token.generateSendBalanceParameter(toAddress: toAddress,
                                                                             amount: ammountInCrypto).toHexString().addHexPrefix())
            return (value: value, token.contractAddress, data: data)
        case is MainCoin:
            let value = try WeiEthterConverter.toWei(ether: ammountInCrypto)
            let data = data
            return (value: value, address: toAddress, data: data)
        default:
            throw EssentiaError.unexpectedBehavior
        }
    }

    public func getTransactionsByWallet(_ wallet: WalletProtocol, transactions: @escaping ([ViewTransaction]) -> Void, failure: @escaping (TOPHttpError) -> Void) {
        switch wallet.asset {
            
        case let token as Token:
            let _action = "tokentx"

            TOPNetworkManager<ETHServices, TOPEthereumTransactionDetail>.requestModelList(.getEthTokenTxHistory(address: wallet.address, action: _action, contractAddress: token.contractAddress), success: { tx, _ in
                if let list = tx {
                    transactions(self.mapTransactions(list, address: wallet.address, forToken: token))
                }
            }, failure: { error in
                failure(error)
            })

        case let coin as MainCoin:
            switch coin {
            case .bitcoin, .bitcoinCash, .litecoin, .dash:
                let utxoWallet = cryptoWallet.utxoWallet(coin: coin)
                utxoWallet.getTransactionsHistory(for: wallet.address) { [unowned self] result in
                    switch result {
                    case let .success(tx):
                        transactions(self.mapTransactions(tx.items, address: wallet.address, asset: wallet.asset))
                    case let .failure(error):
                        let error = TOPHttpError.other(message: error.description, code: -1)
                        failure(error)
                    }
                }
            case .ethereum:

                TOPNetworkManager<ETHServices, EthereumTransactionDetail>.requestModelList(.getETHTransactionhistory(address: wallet.address, pageNum: 1, pageSize: 1000), success: { result, _ in
                    transactions(self.mapTransactions(result!, address: wallet.address, asset: wallet.asset))
                }) { error in
                    failure(error)
                }

            case .topnetwork:
                // 获取top交易历史
                break

            case .unknowCoin:

                break
            }
        default:
            return
        }
    }

    public func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (TOPNetworkResult<String>) -> Void) throws {
        let txRwDetails = try txRawParametrs(for: wallet.asset,
                                             toAddress: transacionDetial.address,
                                             ammountInCrypto: transacionDetial.ammount.inCrypto,
                                             data: Data(hex: transacionDetial.data))

        TOPNetworkManager<ETHServices, NonceModel>.requestModel(.getNonce(address: wallet.address), success: { model in

            let transaction = EthereumRawTransaction(value: txRwDetails.value,
                                                     to: txRwDetails.address,
                                                     gasPrice: transacionDetial.gasPrice,
                                                     gasLimit: transacionDetial.gasLimit,
                                                     nonce: model.nonce,
                                                     data: txRwDetails.data)
            let dataPk = Data(hex: wallet.privateKey)
            #if DEBUG
                let ChainId_Num = UserDefaults.standard.bool(forKey: UserDefautConst.ETHChain_Main) ? ETHRPCServer.main.chainID : ETHRPCServer.rinkeby.chainID
            #else
                let ChainId_Num = ETHRPCServer.main.chainID
            #endif

            let signer = EIP155Signer(chainId: ChainId_Num) // 4是测试链 1是正式
            guard let txData = try? signer.sign(transaction, privateKey: dataPk) else {
                result(.failure("签名失败".localized()))
                return
            }

            TOPNetworkManager<ETHServices, SendResultModel>.requestModel(.sendTransaction(hexValue: txData.toHexString().addHexPrefix()), success: { sendResult in
                result(.success(sendResult.hash))
            }, failure: { error in
                result(.failure(error.message))
            })

        }) { error in
            result(.failure(error.message))
        }
    }

    private func mapTransactions(_ transactions: [UtxoTransactionValue], address: String, asset: AssetInterface) -> [ViewTransaction] {
        return [ViewTransaction](transactions.map({
            let ammount = $0.transactionAmmount(for: address)
            let type = $0.type(for: address)
            var otherAddress = ""
            if type == .send {
                otherAddress = ($0.vout.first!.scriptPubKey.addresses?.first!)!
            } else {
                otherAddress = ($0.vin.first!.addr)!
            }
            return ViewTransaction(hash: $0.txid,
                                   address: otherAddress,
                                   ammount: CryptoFormatter.formattedAmmount(amount: ammount, type: type, asset: asset),
                                   status: $0.status,
                                   type: type,
                                   date: TimeInterval($0.time),
                                   originalData: $0
            )
        }))
    }

    private func mapTransactions(
        _ transactions: [EthereumTransactionDetail],
        address: String,
        asset: AssetInterface) -> [ViewTransaction] {
        //        let nonTokenTx = transactions.filter({ return $0.value != "0" })  //不筛选交易为0的项目
        return [ViewTransaction](transactions.map({
            let txType = $0.type(for: address)
            let txAddress = txType == .recive ? $0.from : $0.to
            return ViewTransaction(
                hash: $0.hash,
                address: txAddress,
                ammount: CryptoFormatter.attributedHex(amount: $0.value, type: txType, asset: asset),
                status: $0.status,
                type: $0.type(for: address),
                date: TimeInterval($0.timeStamp) ?? 0,
                originalData: $0
            )
        }))
    }

    private func mapTransactions(_ transactions: [EthereumTokenTransactionDetail], address: String, forToken: Token) -> [ViewTransaction] {
        return [ViewTransaction](transactions.map({
            let txType = $0.type(for: address)
            let txAddress = txType == .recive ? $0.from : $0.to
            return ViewTransaction(
                hash: $0.hash,
                address: txAddress,
                ammount: CryptoFormatter.attributedHex(amount: $0.value, type: txType, decimals: forToken.decimals, asset: forToken),
                status: $0.status,
                type: $0.type(for: address),
                date: TimeInterval($0.timeStamp) ?? 0,
                originalData: $0
            )
        }))
    }

    private func showError(_ error: EssentiaNetworkError) {
        Toast.showToast(text: error.localizedDescription)
    }
}

extension WalletBlockchainWrapperInteractor {
    private func mapTransactions(_ topTranscations: [TOPEthereumTransactionDetail], address: String, forToken: Token) -> [ViewTransaction] {
        return [ViewTransaction](topTranscations.map({
            let txType = $0.type(for: address)
            let txAddress = txType == .recive ? $0.from : $0.to
            return ViewTransaction(
                hash: $0.hash,
                address: txAddress,
                ammount: CryptoFormatter.attributedHex(amount: $0.value, type: txType, decimals: forToken.decimals, asset: forToken),
                status: $0.status,
                type: $0.type(for: address),
                date: TimeInterval($0.timeStamp) ?? 0,
                originalData: $0
            )
        }))
    }
}

public extension TOPEthereumTransactionDetail {
    var status: TransactionStatus {
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }

    func type(for: String) -> TransactionType {
        switch `for`.uppercased() {
        case to.uppercased():
            return .recive
        case from.uppercased():
            return .send
        default:
            return .send
        }
    }
}
