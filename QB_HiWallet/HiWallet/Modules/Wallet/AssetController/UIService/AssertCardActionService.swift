//
//  AssertCardActionService.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

protocol AssertCardCollectionActionService: class {
    func assetCardManagerAction(indexPath: IndexPath)
    func assetCardCopyAction(indexPath: IndexPath, selectedString: String)
    func assetCardSendAction(indexPath: IndexPath)
    func assetCardReceiveAction(indexPath: IndexPath)
    func collectionViewDidSelected(indexPath: IndexPath)
}
