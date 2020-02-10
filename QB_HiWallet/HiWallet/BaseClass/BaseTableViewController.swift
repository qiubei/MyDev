//
//  BaseTableViewController.swift
//  HiWallet
//
//  Created by apple on 2019/5/24.
//  Copyright © 2019 TOP. All rights reserved.
//

import Foundation
import UIKit
import TOPCore


class BaseTabViewController: UITableViewController ,NibLoadable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localizedString()
    }
    
    func localizedString() {
       
    }
    
    deinit {
       DLog("deinit" + self.debugDescription)
        NotificationCenter.default.removeObserver(self)
    }
}
