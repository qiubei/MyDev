//
//  FeeCaculator.swift
//  HiWallet
//
//  Created by Anonymous on 2019/11/27.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import TOPCore

//MARK: ETH Fee Caculate
struct FeeCaculator {
    private static let defaultETHGasLimit = 21000
    private static let defaultDustValue: UInt64 = 2730
    
    static func getETHfee(gasPrice: Int, gasLimit: Int = defaultETHGasLimit) -> String {
        let gas = BInt(gasPrice) * BInt(gasLimit)
        let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(gas)")
        let fee = NSDecimalNumber(string: String(format: "%.15f", gasValue))
        return "\(fee)"
    }
    
    static func getEthTotalAmountWith(_ amount: Double, _ feePrice: String, _ gasLimit: Int = defaultETHGasLimit) -> NSNumber {
        let fee = getETHGas(gas: Double(feePrice)! / 10, gasLimit: gasLimit).doubleValue
        let num = NSDecimalNumber(string: String(format: "%.8f", amount + fee))
        return num
    }
    
    static func getETHGas(gas: Double, gasLimit: Int = defaultETHGasLimit) -> NSNumber {
        let num = Int(gas * pow(10, 9))
        let bigInt = BInt(num) * BInt(gasLimit) // 计算费用按照21000，发送的时候，gasLimit设置为 1000000
        let gasValue = CryptoFormatter.WeiToEther(valueStr: "\(bigInt)")
        let num2 = NSDecimalNumber(string: String(format: "%.15f", gasValue))
        return num2
    }
}

//MARK: BTE Fee Caculate
extension FeeCaculator {
    static func getBTCTotalAmountWith(_ utxos: [UnspentTransaction], _ amount: Double, _ feePrice: String) -> NSNumber {
        let fee = caculateBtcFee(utxos: utxos, amount: amount, sat: feePrice).doubleValue
        let num = NSDecimalNumber(string: String(format: "%.8f", amount + fee))
        return num
    }
    
    static func caculateBtcFee(utxos: [UnspentTransaction], amount: Double, sat: String) -> NSNumber {
        do {
            let utxoSelector = UtxoCalculater(feePerByte: UInt64(sat)!, dustThreshhold: defaultDustValue)
            let selectedTx = try utxoSelector.select(from: utxos, targetValue: BitcoinConverter(bitcoin: amount).inSatoshi)
            let feeInSatoshi = selectedTx.fee
            return NSDecimalNumber(string: String(format: "%.15f", Double(BitcoinConverter(satoshi: feeInSatoshi).inBitcoin)))
        } catch {
            return NSDecimalNumber(string: String(format: "%.15f", Double(sat)! / 100000000.0 * 226))
        }
    }
}
