//
//  ReceiveTableViewController.swift
//  HiWallet
//
//  Created by apple on 2019/6/3.
//  Copyright © 2019 TOP. All rights reserved.
//

import BlocksKit
import TOPCore
import UIKit

class ReceiveTableViewController: BaseTabViewController {
    var wallet: ViewWalletInterface?

    @IBOutlet var iconImageview: UIImageView!
    @IBOutlet var ercodeImageView: UIImageView!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var addressView: UIView!
    @IBOutlet var shareButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _wallet = wallet else {
            Toast.showToast(text: "data error!")
            return
        }
        shareButton.setTitle("分享".localized(), for: .normal)
        title = "收款二维码".localized()
        iconImageview.sd_setImage(with: URL(string: _wallet.logoUrl)!, completed: nil)
        symbolLabel.text = _wallet.symbol
        ercodeImageView.image = generate(from: _wallet.address)
        addressLabel.text = _wallet.address
        iconImageview.setIconWithWallet(model: _wallet)
        addEvents()
    }

    private func addEvents() {
        addressView.bk_(whenTapped: { [weak self] in
            guard let self = self else { return }
            UIPasteboard.general.string = self.wallet!.address
            Toast.showToast(text: "复制成功".localized())
        })
    }

    private func generate(from string: String) -> UIImage? {
        let context = CIContext()
//        let data = string.data(using: String.Encoding.ascii)
        let data = string.data(using: String.Encoding.utf8)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)
            if let output = filter.outputImage?.transformed(by: transform), let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }

    @IBAction func shareClick(_ sender: Any) {
        let imageView = ReceiveImageView.loadImageView()
        imageView.imageView.image = ercodeImageView.image
        imageView.walletName.text = wallet?.symbol
        imageView.addressLabel.text = wallet?.address
        imageView.walletIconview.sd_setImage(with: URL(string: wallet?.logoUrl ?? ""), completed: nil)

        //        let textToShare = "百度"
        //        let urlToShare = NSURL.init(string: "http://www.baidu.com")
        let imageToShare = imageView.getImageFromView()
        let items = [imageToShare] as [Any]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
        }
        present(activityVC, animated: true, completion: { () -> Void in

        })
    }
}
