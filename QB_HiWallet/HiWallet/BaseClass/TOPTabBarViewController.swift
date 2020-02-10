//
//  TOPTabBarViewController.swift
//  HiWallet
//
//  Created by Jax on 2019/8/21.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class TOPTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers?[0].title = "新青年".localized()
        viewControllers?[1].title = "钱包".localized()
        viewControllers?[2].title = "个人中心".localized()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
