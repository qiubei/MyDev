//
//  SearchCoin.swift
//  TOPModel
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 TOP. All rights reserved.
//

import HandyJSON
import UIKit

public class ServiceCoinModel: BaseModel {
    private var mainChain: Bool = true // 是否是主链
    public var englishName: String = "" // fullName
    public var chineseName: String?
    public var contractAddress: String?
    public var introduce: String = ""
    public var id: Int = 0
    public var iconUrl: String = "" //
    public var decimals: Int?
    public var infoURL: String? // 代币的详情地址
    public var symbol: String = "" // symbol
    public var chainType: String = "" // 主链类型

    public var isMainChain: Bool {
        return mainChain
    }
}

//public protocol AssetInterface {
//    var name: String { get }
////    var localizedName: String { get }
//    var symbol: String { get }
//    var iconUrl: String { get }
//    var type: CryptoType { get }
//    var shadowColor: UIColor { get }
//    var minimumTransactionAmmount: Double { get }
//    var assetID: String { get }
//    func isValidAddress(_ address: String) -> Bool
//}
//
//public protocol WalletProtocol {
//    
//    var accountIndex: Int32 { get }
//    var address: String { get }
//    var privateKey: String { get }
//    var asset: AssetInterface { get }
//    var name: String { get set }
//    var createTime: Double { get }
//    var fullName: String { get }
//
//}
//
//public protocol ViewWalletInterface: WalletProtocol, ThreadConfined {
//    var logoUrl: String { get } // overlap
//    var symbol: String { get } // overlap
//    var isMainCoin: Bool { get } // overlap
//    var chainSymbol: String { get } //
//    var formattedBalance: String { get }
//    var lastBalance: Double { get set}
//
//    func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double
//    func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double  //暂时不用
//    func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String
//}
//
//public struct ViewWalletObject: Hashable {
//    public static func == (lhs: ViewWalletObject, rhs: ViewWalletObject) -> Bool {
//        return lhs.address == rhs.address && lhs.name == rhs.name
//    }
//
//    public var address: String
//    public var name: String
//}
//
//extension ViewWalletInterface {
//    public var viewWalletObject: ViewWalletObject {
//        return ViewWalletObject(address: address, name: name)
//    }
//}
