//
//  ViewController.swift
//  URLSchemeDemo
//
//  Created by Anonymous on 2019/10/30.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openURLAction(_ sender: UIButton) {
        let url = URL(string: "hiwallet:///payment?id=urlDemo&address=0x1a11b2b3b23b41235&price=2.34")
//        let url = URL(string: "myphotoapp:Vacation?index=1")
        
//        "prefs:root=Apps&path=Your+App+Display+Name"
        
        

        UIApplication.shared.open(url!) { (result) in
            if result {
               // The URL was delivered successfully!
                print(">>> open successed!!")
            }
        }
    }
    
}

