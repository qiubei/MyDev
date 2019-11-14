//
//  TranstonServices.swift
//  HiWallet
//
//  Created by Jax on 2019/9/19.
//  Copyright © 2019 TOP. All rights reserved.
//
enum ValidInputMessageType {
    case success
    case toast(String)
    case alert(String)
}

protocol TranstonInterface {
    var amount: String { get set }
    var address: String { get set }
    var note: String { get set }
    var gasLimit: Int { get set }

    func validInput() -> ValidInputMessageType // 输入是否有效
    func confirmVerify(callback: @escaping (_ result: ValidInputMessageType) -> Void) // 确认之后检测

    func loadData(callback: @escaping (_ result: Bool) -> Void) // 获取必要数据
    func loadFeeData(callback: @escaping (_ result: Bool) -> Void) // 获取Fee
    func getPopData() -> [SendPopViewModel] // 弹框数据
    func reloadPopDataWithIndex(index: Int) -> [SendPopViewModel] // 更新弹框数据
    func sendTranstion(callback: @escaping (_ result: (Bool, String)) -> Void) // 发送
}
