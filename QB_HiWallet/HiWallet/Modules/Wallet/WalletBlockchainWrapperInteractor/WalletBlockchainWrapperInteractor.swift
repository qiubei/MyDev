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
import Moya
import TOPCore

public class WalletBlockchainWrapperInteractor: WalletBlockchainWrapperInteractorInterface {
    private var cryptoWallet: CryptoWallet

    public init() {
        cryptoWallet = CryptoWallet(bridgeApiUrl: TOPConstants.bridgeUrl,
                                    etherScanApiKey: TOPConstants.ethterScanApiKey)
    }

    public func getCoinBalance(for coin: ChainType, address: String, balance: @escaping (Double) -> Void, failure: @escaping () -> Void) {
        switch coin {
            case .bitcoin, .bitcoinCash, .litecoin, .dash:
               let utxoWallet = cryptoWallet.utxoWallet(coin: coin)
               utxoWallet.getBalance(for: address) { result in
                   switch result {
                   case let .success(obect):
                       balance(obect)
                   case .failure:
                       failure()
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

        default:
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

    public func txRawParametrs(for asset: AssetInterface, toAddress: String, ammountInCrypto: String, data: Data) throws -> (value: Wei, address: String, data: Data) {
        switch asset {
        case let token as Token:
            let value = Wei(integerLiteral: 0)
            let erc20Token = ERC20(contractAddress: token.contractAddress, decimal: token.decimals, symbol: token.symbol)
            let data = try Data(hex: erc20Token.generateSendBalanceParameter(toAddress: toAddress,
                                                                             amount: ammountInCrypto).toHexString().addHexPrefix())
            return (value: value, token.contractAddress, data: data)
        case is ChainType:
            let value = try WeiEthterConverter.toWei(ether: ammountInCrypto)
            let data = data
            return (value: value, address: toAddress, data: data)
        default:
            throw TOPError.unexpectedBehavior
        }
    }

    public func getTxHistoryByWallet(_ wallet: WalletProtocol, pageNum: NSInteger, transactions: @escaping ([HistoryTxModel]) -> Void, failure: @escaping (TOPHttpError) -> Void) {
        switch wallet.asset {
        case let token as Token:

            TOPNetworkManager<ETHServices, TOPEthereumTransactionDetail>.requestModelList(.getEthTokenTxHistory(address: wallet.address.lowercased(), action: "tokentx", contractAddress: token.contractAddress, pageIndex: pageNum, pageSize: 20), success: { tx, _ in
                if let list = tx {
                    transactions(self.mapTransactions(list, address: wallet.address, asset: token))
                }
            }, failure: { error in
                failure(error)
            })

        case let coin as ChainType:
            switch coin {
            case .bitcoin, .bitcoinCash, .litecoin, .dash:
                let utxoWallet = cryptoWallet.utxoWallet(coin: coin)
                utxoWallet.getTransactionsHistory(for: wallet.address) { [unowned self] result in
                    switch result {
                    case let .success(tx):
                        if pageNum == 1 {
                            transactions(self.mapTransactions(tx.items, address: wallet.address, asset: coin))
                        } else {
                            transactions([])
                        }
                    case let .failure(error):
                        let error = TOPHttpError.other(message: error.localizedDescription, code: -1)
                        failure(error)
                    }
                }
            case .ethereum:

                TOPNetworkManager<ETHServices, TOPEthereumTransactionDetail>.requestModelList(.getETHTransactionhistory(address: wallet.address, pageNum: pageNum, pageSize: 20), success: { tx, _ in
                    if let list = tx {
                        transactions(self.mapTransactions(list, address: wallet.address, asset: coin))
                    }
                }, failure: { error in
                    failure(error)
                })

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

    public func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (String) -> Void, failure: @escaping (TOPHttpError) -> Void) throws {
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
                failure(TOPHttpError.other(message: "Error", code: -1))
                return
            }

            TOPNetworkManager<ETHServices, SendResultModel>.requestModel(.sendTransaction(hexValue: txData.toHexString().addHexPrefix()), success: { sendResult in
                result(sendResult.hash)
            }, failure: { error in
                failure(error)
            })

        }) { error in
            failure(error)
        }
    }

    private func showError(_ error: EssentiaNetworkError) {
        Toast.showToast(text: error.localizedDescription)
    }
}

extension WalletBlockchainWrapperInteractor {
    //

    private func mapTransactions(_ transactions: [UtxoTransactionValue], address: String, asset: AssetInterface) -> [HistoryTxModel] {
        return [HistoryTxModel](transactions.map({
            HistoryTxModel(
                chainType: asset.chainSymbol,
                asset: asset,
                txhash: $0.txid,
                toAddress: $0.vout.first!.scriptPubKey.addresses?.first ?? "",
                fromAddress: $0.vin.first?.addr ?? "",
                myAddress: address,
                ammount: $0.transactionAmmount(for: address) ?? 0,
                status: $0.status,
                type: $0.type(for: address),
                date: TimeInterval($0.time),
                fee: "\(NSDecimalNumber(string: String(format: "%.15f", $0.fees ?? 0)))"
            )
        }))
    }

    private func mapTransactions(_ transactions: [TOPEthereumTransactionDetail], address: String, asset: AssetInterface) -> [HistoryTxModel] {
        return [HistoryTxModel](transactions.map({
            HistoryTxModel(
                chainType: asset.chainSymbol,
                asset: asset,
                txhash: $0.hash,
                toAddress: $0.to,
                fromAddress: $0.from,
                myAddress: address,
                ammount: asset.type == .coin ? CryptoFormatter.WeiToEther(valueStr: $0.value) : CryptoFormatter.WeiToTokenBalance(valueStr: $0.value, decimals: (asset as! Token).decimals, radix: 10),
                status: $0.status,
                type: $0.type(walletAddress: address),
                date: TimeInterval($0.timeStamp) ?? 0,
                fee: $0.fee,
                note: asset.type == .token ? nil : $0.input
            )
        }))
    }
}
