//
//  ViewController.swift
//  HiWallet
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 TOP. All rights reserved.
//

import TOPCore
import UIKit

typealias ActionBlock<T> = (T) -> Void
typealias EmptyAction = () -> Void

class BaseViewController: UIViewController, NibLoadable {
    lazy var navigationView: UIView = {
        let nav = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: navigationHeight))
        nav.backgroundColor = .clear
        return nav
    }()

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
