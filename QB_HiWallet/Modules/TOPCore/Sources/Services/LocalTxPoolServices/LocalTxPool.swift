//
//  EthereumLocalTxPool.swift
//  Cyton
//
//  Created by 晨风 on 2018/12/27.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

import RealmSwift

public class LocalTxModel: Object {
    @objc dynamic var chainType = ""
    @objc dynamic var txHash = ""
    @objc dynamic var assetID = ""
    @objc dynamic var from = ""
    @objc dynamic var to = ""
    @objc dynamic var value = "" //
    @objc dynamic var fee = "" //以太坊单位为Wei
    @objc dynamic var date = Date()
    @objc dynamic var note = "" //
    @objc dynamic var blockNumber = "" //
    @objc private dynamic var statusValue: Int = TransactionStatus.unconfirmed.rawValue

    public var status: TransactionStatus {
        get { return TransactionStatus(rawValue: statusValue)! }
        set { statusValue = newValue.rawValue }
    }

    /// 生成本地记录
    /// - Parameter txHash: 交易哈希
    /// - Parameter from: 发送人地址
    /// - Parameter to: 接受人地址
    /// - Parameter value: 数量
    /// - Parameter fee: 费用
    /// - Parameter note: 备注，如果没有传空字符串
    public required convenience init(txHash: String, from: String, to: String, value: String, fee: String, note: String, assetID: String) {
        self.init()
        self.txHash = txHash
        self.from = from
        self.to = to
        self.value = value
        self.fee = fee
        self.note = note
        self.assetID = assetID
    }

    @objc public override class func primaryKey() -> String? { return "txHash" }
}

public class LocalTxPool: NSObject {
    public static let didUpdateTxStatus = Notification.Name("EthereumLocalTxPool.didUpdateTxStatus")
    public static let didAddLocalTx = Notification.Name("EthereumLocalTxPool.didAddLocalTx")
    public static let txKey = "tx"
    public static let pool = LocalTxPool()

    public func register() {}

    public func insertLocalTx(localTx: LocalTxModel, asset: AssetInterface) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(localTx)
            }
            let tx = localTx.getTx(asset: asset)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: LocalTxPool.didAddLocalTx, object: nil, userInfo: [LocalTxPool.txKey: tx])
            }
        } catch {
            DLog("插入失败")
        }
    }

    public func getTransactions(wallet: ViewWalletInterface) -> [HistoryTxModel] {
        return (try! Realm()).objects(LocalTxModel.self).filter({
            $0.from.uppercased() == wallet.address.uppercased() && $0.assetID.uppercased() == wallet.asset.assetID.uppercased()
        }).map({
            $0.getTx(asset: wallet.asset)
        })
    }

    public func remove(hash: String) {
        let result = (try! Realm()).objects(LocalTxModel.self).filter({
            $0.txHash.uppercased() == hash.uppercased()
        })

        if let model = result.first {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(model)
            }
        }
    }

    // MARK: - Private

    private var observers = [NotificationToken]()

    private override init() {
        super.init()
        DispatchQueue.global().async {
            self.checkLocalTxList()
        }
        let realm = try! Realm()
        observers.append(realm.objects(LocalTxModel.self).observe { change in
            switch change {
            case .update(_, deletions: _, let insertions, modifications: _):
                guard insertions.count > 0 else { return }
                DispatchQueue.global().async {
                    self.checkLocalTxList()
                }
            default:
                break
            }
        })
    }

    private var checking = false
    private let timeInterval: TimeInterval = 4.0

    @objc private func checkLocalTxList() {
//        guard checking == false else { return }
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(checkLocalTxList), object: nil)
//        let realm = try! Realm()
//        let results = realm.objects(LocalTxModel.self).filter({ $0.status == .pending })
//        guard results.count > 0 else { return }
//        checking = true
//        results.forEach { localTx in
//            guard localTx.status == .pending else { return }
//            self.checkLocalTxStatus(localTx: localTx)
//        }
//        checking = false
//        checkLocalTxList()
//        perform(#selector(checkLocalTxList), with: nil, afterDelay: timeInterval)
    }

    private func checkLocalTxStatus(localTx: LocalTxModel) {
//        guard let blockNumber = localTx.blockNumber else { return }
//        guard let currentBlockNumber = try? localTx.web3.eth.getBlockNumber() else { return }
//        let realm = try! Realm()
//        var status: LocalTxPool.TxStatus = .success
//        if localTx.transactionReceipt?.status == .ok {
//            if Int(currentBlockNumber) - Int(blockNumber) < 12 {
//                return
//            }
//            status = .success
//        } else if localTx.transactionReceipt?.status == .failed {
//            status = .failure
//        }
//        if localTx.status == .pending && localTx.date.timeIntervalSince1970 + 60 * 60 * 48 < Date().timeIntervalSince1970 {
//            status = .failure
//        }
//
//        try? realm.write {
//            localTx.status = status
//        }
//
//        if localTx.status == .success || localTx.status == .failure {
//            let tx = localTx.getTx()
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: LocalTxPool.didUpdateTxStatus, object: nil, userInfo: [LocalTxPool.txKey: tx])
//            }
//        }
    }
}

extension LocalTxModel {
    public func getTx(asset: AssetInterface) -> HistoryTxModel {
        var tx = HistoryTxModel(chainType: asset.chainSymbol,
                                asset: asset,
                                txhash: txHash,
                                toAddress: to,
                                fromAddress: from,
                                myAddress: from,
                                ammount: Double(value) ?? 0,
                                status: .unconfirmed,
                                type: .send,
                                date: date.timeIntervalSince1970,
                                fee: fee,
                                note: note.count == 0 ? nil : note)

        switch status {
        case .unconfirmed:
            tx.status = .unconfirmed
        case .pending:
            tx.status = .pending
        case .success:
            tx.status = .success
        case .failure:
            tx.status = .failure
        }

        return tx
    }
}
