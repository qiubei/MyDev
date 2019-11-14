//
//  BulletinDataSource.swift
//  HiWallet
//
//  Created by Jax on 2019/9/18.
//  Copyright © 2019 TOP. All rights reserved.
//

import BLTNBoard
import Foundation

enum BulletinDataSource {
    
    //先转菊花的完成弹框
    static func makeCompletionPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "")
        page.image = #imageLiteral(resourceName: "complate_icon")
        page.appearance = PageItemAppearance.default

        page.descriptionText = "发送成功".localized()
        page.actionButtonTitle = "完成".localized()
        page.alternativeButtonTitle = "再转一笔".localized()

        page.shouldStartWithActivityIndicator = true
        page.isDismissable = false

        page.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }

        return page
    }
    
    //先转菊花的完成弹框
    static func makeSendFailPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "")
        page.image = UIImage.init(named: "SendFailState_icon")
        page.appearance = PageItemAppearance.default

        page.descriptionText = "发送失败".localized()
        page.actionButtonTitle = "重新发送".localized()
        page.alternativeButtonTitle = "返回".localized()

        page.isDismissable = false

        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }

        return page
    }
}
