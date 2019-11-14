//
//  TestViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import HandyJSON
import TOPCore
import SwiftyJSON
import Alamofire

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // successed
//        self.testCheckup()
//        hotCoinSpecies()
//        
//        DispatchQueue.global().async {
//            self.findCoin()
//            self.coinSpecies()
//        }
//        findCoin()
//        coinSpecies()
//        testETCGasFee()
//        testBTCGasFee()
//        testSwitch()
//        testETHNonce()
//        testGetETHBalance()
//        testERC20Balance()
//
//        // pending
        testETHTokenTxlist()
//        testETHTxlist() // f71f8b865bdea078846f7af5f27e6362 //419ffde88ff078bbb7aee18eaf9c409b
//        testSendTx()
    }
}

//extension TestViewController {
//    0xe41d2489571d322189246dafa5ebde1f4699f498
    func testETHTokenTxlist() {
        TOPNetworkManager<ETHServices, TOPEthereumTransactionDetail>.requestModelList(.getEthTokenTxHistory(address: "0x7AB38077ab29DeE6Bc2dD87CB0eFDf06D18962Dd", action: "tokentx", contractAddress: "0xe41d2489571d322189246dafa5ebde1f4699f498"), success: { (list, pageInfo) in
            DLog("token list result is \(list) and pageInfo is \(pageInfo)")
        }, failure: nil)
    }
//    
//    func testETHTxlist() {
//        TOPNetworkManager<ETHServices, TOPEthereumTransactionDetail>.requestModelList(.getETHTransactionhistory(address: "0x7AB38077ab29DeE6Bc2dD87CB0eFDf06D18962Dd", pageNum: 1, pageSize: 100), success: { (list, pageInfo) in
//            DLog("get rx list result is \(list?.count) \n >>>>>> pageInfo is \(pageInfo)")
//        }, failure: nil)
//    }
//    
//    func testSendTx() {
//        TOPNetworkManager<ETHServices, SendResultModel>.requestModel(.sendTransaction(hexValue: ""), success: { (model) in
//            DLog("send tx result is \(model)")
//        }, failure: nil)
//    }
//    
//    func testETHNonce() {
//        TOPNetworkManager<ETHServices, NonceModel>.requestModel(.getNonce(address: "0x7AB38077ab29DeE6Bc2dD87CB0eFDf06D18962Dd"), success: { (model) in
//            DLog("get nonce result is \(model)")
//        }, failure: nil)
//    }
//    
//    func testERC20Balance() {
//        TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getERC20Balance(address: "0x7AB38077ab29DeE6Bc2dD87CB0eFDf06D18962Dd", contract: "0xdcd85914b8ae28c1e62f1c488e1d968d5aaffe2b"), success: { (model) in
//            DLog("get eth balance \(model)")
//        }, failure: nil)
//    }
//    
//    func testGetETHBalance() {
//        TOPNetworkManager<ETHServices, BalanceModel>.requestModel(.getBalance(address: "0x7AB38077ab29DeE6Bc2dD87CB0eFDf06D18962Dd"), success: { (model) in
//            DLog("get balance \(model)")
//        }, failure: nil)
//    }
//    
//    func testETCGasFee() {
//        TOPNetworkManager<ETHServices, GasSpeed>.requestModel(.getFeeList, success: { model in
//            DLog("get eth fee list is \(model)")
//        }) { error in
//            DLog("get btc \(error)")
//        }
//    }
//    
//    func testBTCGasFee() {
//        TOPNetworkManager<BTCServices, BtcFeeList>.requestModel(.getFeeList, success: { (model) in
//            DLog("get btc fee list is \(model)")
//        }, failure: { error in
//            DLog("get btc \(error)")
//        })
//    }
//    
//    func hotCoinSpecies() {
//        
//        TOPNetworkManager<NormalService, ServiceCoinModel>.requestModelList(.hotCoinSpecies(["BTC","ETH"], "ABYSS", 1, 1, 100), success: { (modelList, pageinfo) in
//            DLog("pageInfo \(pageinfo?.totalCount) >>> get hot hot hot list count is \(modelList)")
//        }, failure: nil)
//    }
//    
//    func findCoin() {
//        TOPNetworkManager<NormalService, CoinIntroduceModel>.requestModel(.findCoin("Ethereum", 1), success: { (model) in
//            DLog("find coin >>>" + (model.introduce  ?? "nil"))
//        }){ error in
//            DLog("find coin request failed \(error)")
//        }
//    }
//    
//    func coinSpecies() {
//        TOPNetworkManager<NormalService, ServiceCoinModel>.requestModelList(.searchCoin(["BTC","ETH"], "ABYSS", 0, true), success: { (modelList, pageInfo) in
//            DLog("pageInfo \(pageInfo?.totalCount) >>> get coin species list count is \(modelList)")
//            modelList?.forEach({
//                DLog("the value is \($0.englishName)")
//            })
//        }) { (error) in
//            DLog("coin species request failed \(error)")
//        }
//    }
//    
//    func testCheckup() {
//        TOPNetworkManager<NormalService, UpdateModel>.requestModel(.checkAppVersion("1.0.1"), success: { (model) in
//            DLog(model)
//        }) { (error) in
//            DLog("check app version request failed \(error)")
//        }
//    }
//    
//    func testSwitch() {
//        TOPNetworkManager<NormalService, StakingSwitchModel>.requestModel(.getStakingSwitch("1.0.1"), success: { (model) in
//            DLog("get staking switch result \(model)")
//        }, failure: nil)
//    }
//}
//
//class TResult: HandyJSON {
//    required init() {
//            
//    }
//}
