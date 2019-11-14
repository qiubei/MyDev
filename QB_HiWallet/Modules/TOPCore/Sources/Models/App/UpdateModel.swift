//
//  UpdateModel.swift
//  TOPModel
//
//  Created by Jax on 2019/8/1.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation

public struct UpdateModel: Codable {
    public var hasUpdate: String // 是否有更新
    public var downloadUrl: String? // 下载url
    public var description: String? // 描述
    public var isForcedUpdates: Int? // 是否强制更新
    public var version: String? // 版本
}
