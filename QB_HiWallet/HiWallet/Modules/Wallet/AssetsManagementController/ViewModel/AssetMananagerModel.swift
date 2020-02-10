//
//  AssetMananagerViewModel.swift
//  HiWallet
//
//  Created by Jax on 2019/11/18.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import RealmSwift
import TOPCore

class AssetMananagerModel {
    var isSearching: Bool = false
    var showViewList: [AssetManagerCellViewModel] {
        return (isSearching ? searchWalletViewList : walletViewList)
    }

    private var walletViewList: [AssetManagerCellViewModel] = []
    private var searchWalletViewList: [AssetManagerCellViewModel] = []

    func clearSearchData() {
        searchWalletViewList.removeAll()
    }

    func loadInitData(update: Bool = false, success: EmptyBlock?) {
        walletViewList.removeAll()
        let realm = try! Realm()
        let hotCoinList = realm.objects(ServiceCoinModel.self)

        DLog(hotCoinList.count)
        let localCoinList = (inject() as WalletInteractorInterface).getAllWalletGroup()

        for group in localCoinList {
            let viewModel = AssetManagerCellViewModel(hotCoinModel: group.first!)
            walletViewList.append(viewModel)
        }
        if hotCoinList.isEmpty {
            loadHotCoinData {
                success?()
            }
            return
        }

        for coinInfo in hotCoinList {
            let viewModel = AssetManagerCellViewModel(hotCoinModel: coinInfo)
            if !walletViewList.contains(where: {
                $0.assetID == viewModel.assetID
            }) {
                walletViewList.append(viewModel)
            }
        }

        success?()
        //更新热门数据
        if update {
            loadHotCoinData(update: true, success:nil)
        }
    }

    //更新热门数据
    func loadHotCoinData(update: Bool = false, success: EmptyBlock?) {
        //写入数据库

        TOPNetworkManager<CommonServices, ServiceCoinModel>.requestModelList(.hotCoinSpecies, success: { list, _ in

            if update {
                //删除数据库
                DispatchQueue.global().async {
                    let realm = try? Realm()
                    let hotCoinList = realm!.objects(ServiceCoinModel.self)
                    realm?.beginWrite()
                    realm?.delete(hotCoinList)
                    try? realm?.commitWrite()
                    DLog(hotCoinList.count)
                    for coinInfo in list! {
                        //写入数据库
                        realm?.beginWrite()
                        realm?.add(coinInfo)
                        try? realm?.commitWrite()
                    }
                    DLog(hotCoinList.count)
                }

            } else {
                for coinInfo in list! {
                    let viewModel = AssetManagerCellViewModel(hotCoinModel: coinInfo)
                    if !self.walletViewList.contains(where: {
                        $0.assetID == viewModel.assetID
                    }) {
                        self.walletViewList.append(viewModel)
                    }

                    //写入数据库
                    DispatchQueue.global().async {
                        let realm = try? Realm()
                        try! realm!.write {
                            realm?.add(coinInfo)
                        }
                    }
                }
            }
            success?()

        }) { error in
            if error.code == 6 {
            } else {
                Toast.showToast(text: error.message)
            }
        }
    }

    func searchCoin(content: String, result: @escaping EmptyBlock) {
        //先取消相同的搜索
        let target = CommonServices.searchCoin(coinName: content)
        TOPNetworkManager<CommonServices, Any>.cancelRequestWith(urlStr: target.baseURL.absoluteString + target.path)
        TOPNetworkManager<CommonServices, ServiceCoinModel>.requestModelList(target, success: { list, _ in

            self.searchWalletViewList.removeAll()

            for coinInfo in list! {
                let viewModel = AssetManagerCellViewModel(hotCoinModel: coinInfo)
                self.searchWalletViewList.append(viewModel)

                if self.walletViewList.contains(where: {
                    $0.assetID == viewModel.assetID && $0.isOn
                }) {
                    viewModel.isOn = true
                } else {
                    viewModel.isOn = false
                }
            }

            result()

        }, failure: { error in
            
        })
    }
    
    func appendUpload(wallets: [ViewWalletInterface]) {
        PushManager.shared.uploadWallets(assets: wallets)
    }
    
    func appendRemove(wallets: [ViewWalletInterface]) {
        PushManager.shared.removeWallets(assets: wallets)
    }
}
