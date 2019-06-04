//
//  BaseNavigationController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/8/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        self.performSegue(withIdentifier: "toFileList", sender: self)
    }
}
