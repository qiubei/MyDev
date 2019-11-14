//
//  Nib.swift
//  FlowtimeUI
//
//  Created by Anonymous on 2019/3/29.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

struct Nib<V> where V: UIView {
    var nib: UINib
    var name: String
    var owner: Any?
}


extension Nib {
    var view: V? {
        return self.nib.instantiate(withOwner: self.owner, options: nil).first as? V
    }
}

extension Nib {
    static func load(name: String, withOwner: Any? = nil) -> Nib {
        return Nib(nib: UINib(nibName: name, bundle: nil), name: name, owner: withOwner)
    }
}
