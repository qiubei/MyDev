//
//  PopViewModel.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/18.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

enum SendSpeedFeeType: Int {
    case none
    case fast
    case normal
    case slow
}

struct NormalPopModel {
    var speedDesc: String
    var Fee: String
    var image: UIImage?
}

// 视图模型
struct SendPopViewModel {
    var title: String // 标题
    var topDesc: String // 右上描述
    var bottomDesc: String // 右下描述
    var nextList: [NormalPopModel]?
    init(title: String, topDesc: String, bottomDesc: String, nextList:[NormalPopModel]? = nil) {
        self.title = title
        self.topDesc = topDesc
        self.bottomDesc = bottomDesc
        self.nextList = nextList
    }
}
