//
//  CryptoFormatter.swift
//  TOPCore
//
//  Created by Jax on 5/30/19.
//  Copyright © 2019 Jax. All rights reserved.
//

import Foundation
import UIKit

public class CryptoFormatter {
    
    public static func formattedAmmount(amount: Double?, type: TransactionType, asset: AssetInterface) -> NSAttributedString {
        let ammountFormatter = BalanceFormatter(asset: asset)
        let formattedAmmount = ammountFormatter.formattedAmmountWithSymbol(amount: amount)
        let separeted = formattedAmmount.split(separator: " ")
        guard separeted.count == 2 else { return NSAttributedString() }
        let attributed = NSMutableAttributedString(string: String(separeted[0]),
                                                   attributes: [NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 16)!])
        attributed.append(NSAttributedString(string: " "))
        attributed.append(NSAttributedString(string: String(separeted[1]),
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8)]))
        switch type {
        case .recive:
            attributed.insert(NSAttributedString(string: "+"), at: 0)
            attributed.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "Color_Main")!], range: NSRange(location: 0, length: attributed.length))
        case .send:
            attributed.insert(NSAttributedString(string: "-"), at: 0)
        default: break
        }
        return attributed
    }

    //不带+-
    public static func formattedAmmountNoDropSymbol(amount: Double?, type: TransactionType, asset: AssetInterface) -> String {
        let ammountFormatter = BalanceFormatter(asset: asset)
        let formattedAmmount = ammountFormatter.formattedAmmountWithSymbol(amount: amount)
        return formattedAmmount
    }

    public static func attributedHex(amount: String, type: TransactionType, asset: AssetInterface) -> NSAttributedString {
        guard let wei = BInt(amount, radix: 10),
            let etherAmmount = try? WeiEthterConverter.toEther(wei: wei) else {
            return NSAttributedString()
        }
        return formattedAmmount(amount: (etherAmmount as NSDecimalNumber).doubleValue, type: type, asset: asset)
    }

    public static func attributedHex(amount: String, type: TransactionType, decimals: Int, asset: AssetInterface) -> NSAttributedString {
        guard let convertedAmmount = try? WeiEthterConverter.toToken(balance: amount, decimals: decimals, radix: 10) else {
            return NSAttributedString()
        }
        return formattedAmmount(amount: (convertedAmmount as NSDecimalNumber).doubleValue, type: type, asset: asset)
    }

    public static func WeiToEther(valueStr: String) -> Double {
        guard let wei = BInt(valueStr, radix: 10),
            let etherAmmount = try? WeiEthterConverter.toEther(wei: wei) else {
            return 0
        }
        return (etherAmmount as NSDecimalNumber).doubleValue
    }

    /// deprecated
    public static func WeiToTokenBalance(valueStr: String, decimals: Int, radix: Int) -> Double {
        guard let convertedAmmount = try? WeiEthterConverter.toToken(balance: valueStr, decimals: decimals, radix: 10) else {
            return 0
        }
        return (convertedAmmount as NSDecimalNumber).doubleValue
    }
    
    public static func decimalNumberTokenBalance(valueStr: String, decimals: Int, radix: Int) -> NSDecimalNumber {
        guard let convertedAmmount = try? WeiEthterConverter.toToken(balance: valueStr, decimals: decimals, radix: 10) else {
            return 0
        }
        return convertedAmmount as NSDecimalNumber
    }
    
    public static func decimalNumberToEther(valueStr: String) -> NSDecimalNumber {
        guard let wei = BInt(valueStr, radix: 10),
            let etherAmmount = try? WeiEthterConverter.toEther(wei: wei) else {
            return 0
        }
        return etherAmmount as NSDecimalNumber
    }
}
