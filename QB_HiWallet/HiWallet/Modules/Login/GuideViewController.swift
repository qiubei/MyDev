//
//  GuideViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/5.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController, UIScrollViewDelegate {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var importButton: UIButton!
    @IBOutlet var pageControl: TOPPageControl!
    @IBOutlet var guide1TextLabel: UILabel!
    @IBOutlet var guide1detailLabel: UILabel!
    @IBOutlet var guide2TextLabel: UILabel!
    @IBOutlet var guide2detailLabel: UILabel!
    @IBOutlet var guide3TextLabel: UILabel!
    @IBOutlet var guide3detailLabel: UILabel!

    @IBOutlet var scrollview: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setup() {
        scrollview.delegate = self
        startButton.setTitle("开启钱包".localized(), for: .normal)
        importButton.setTitle("导入钱包".localized(), for: .normal)
        guide1TextLabel.text = "多链钱包 专业便捷".localized()
        guide1detailLabel.text = "一套助记词管理多链钱包，用户自主管理私钥。".localized()
        guide2TextLabel.text = "简单流畅 极致用户体验".localized()
        guide2detailLabel.text = "一键创建多个钱包，随意切换，自由管理。".localized()
        guide3TextLabel.text = "TOP 生态指定钱包".localized()
        guide3detailLabel.text = "HiWallet，您的专属数字钱包。".localized()
    }

    @IBAction func startAction(_ sender: UIButton) {
        let controller: AuthenticationViewController = UIStoryboard(name: .authentication).instantiateViewController()
        controller.handleType = .setPassword
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

    @IBAction func importAction(_ sender: UIButton) {
        let controller = ImportWalletController.loadFromWalletStoryboard()
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: scrollview method

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = (scrollview.contentOffset.x / view.bounds.width * 1.0).rounded()
        pageControl.currentPage = Int(index)
    }
}
