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
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setup()
        layout()
        localizedString()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setup() {}

    func layout() {}

    func localizedString() {}
    
    deinit {
        DLog("deinit" + self.debugDescription)
        NotificationCenter.default.removeObserver(self)
    }
}
