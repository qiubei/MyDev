//
//  RFAssetCardViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class RFAssetCardViewController: BaseViewController {
    var viewModel: AssetCardViewModel!
    private let assetCardView: AssetCardView = AssetCardView(frame: .zero)
    
    override func loadView() {
        super.loadView()
        view = assetCardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
