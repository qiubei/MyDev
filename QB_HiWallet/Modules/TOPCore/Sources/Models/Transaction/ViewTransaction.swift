//
//  ViewTransaction.swift
//  TOP
//
//  Created by Jax on 10/23/18.
//  Copyright © 2018 TOP. All rights reserved.
//

import Foundation

public struct ViewTransaction {
    public var hash: String
    public var address: String
    public var ammount: NSAttributedString
    public var status: TransactionStatus
    public var type: TransactionType
    public var date: TimeInterval

    public var originalData:Any
    
    public var stringDate: String {
        let txDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter(formate: DateFormat.dateTime)
        return dateFormatter.string(from: txDate)
    }
    
    public init(hash: String, address: String, ammount: NSAttributedString, status: TransactionStatus, type: TransactionType, date: TimeInterval,originalData:Any) {
        self.hash = hash
        self.address = address
        self.ammount = ammount
        self.status = status
        self.type = type
        self.date = date
        self.originalData = originalData
    }
    

    public var statusDesc:String {
            
            switch (status) {
            case .failure:
                return "交易失败"
            case .pending:
                return "打包中"
            case .success:
                return "交易成功"
            }
    }

}
