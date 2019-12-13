//
//  ViewController.swift
//  HiWallet
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import UIKit

typealias ActionBlock<T> = (T)->()
typealias EmptyAction = ()->()

class BaseViewController: UIViewController, NibLoadable {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        layout()
        localizedString()
    }


    func setup() {}

    func layout() {}

    func localizedString() {}
    
    deinit {
        DLog("deinit" + self.debugDescription)
        NotificationCenter.default.removeObserver(self)
    }
}
