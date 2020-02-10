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

class ReceiveTableViewController: BaseViewController {
    var wallet: ViewWalletInterface?

    @IBOutlet var iconImageview: UIImageView!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var ercodeImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet weak var copyIcon: UIImageView!
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrCodeVsButtonMarginConstraint: NSLayoutConstraint!
    
    private func updateConstraints() {
        var ratio = App.heightRatio
        if App.isSmallScreen {
            ratio *= 0.5
        }
        topMarginConstraint.constant = 62 * ratio
        qrCodeVsButtonMarginConstraint.constant = 74 * ratio
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.view is GradientView {
            (view as? GradientView)?.colors = App.Color.sharedBgColors
            (view as? GradientView)?.showVertical = true
        }
        
        guard let _wallet = wallet else {
            Toast.showToast(text: "data error!")
            return
        }
        shareButton.setTitle("分享收款地址".localized(), for: .normal)
        iconImageview.sd_setImage(with: URL(string: _wallet.logoUrl)!, completed: nil)
        symbolLabel.text = _wallet.symbol
        ercodeImageView.image = generate(from: _wallet.address)
        addressLabel.text = _wallet.address
        iconImageview.setIconWithWallet(model: _wallet)
        addEvents()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem?.image = UIImage.init(named: "icon_navigation_back_white")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.titleView = UILabel().then {
            $0.text = "收款二维码".localized()
            $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            $0.textColor = .white
        }
    }
    
    private func addEvents() {
        addressLabel.isUserInteractionEnabled = true
        addressLabel.bk_(whenTapped: { [weak self] in
            self?.handleCopyingAddress()
        })
        
        copyIcon.isUserInteractionEnabled = true
        copyIcon.bk_(whenTapped: { [weak self] in
            self?.handleCopyingAddress()
        })
    }

    private func handleCopyingAddress() {
        UIPasteboard.general.string = self.wallet!.address
        Toast.showToast(text: "复制成功".localized())
    }
    
    private func generate(from string: String) -> UIImage? {
        let context = CIContext()
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
        view.addSubview(imageView)
        let imageToShare = imageView.getImageFromView()
        imageView.isHidden = true
        let items = [imageToShare] as [Any]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            imageView.removeFromSuperview()
        }
        present(activityVC, animated: true, completion: { () -> Void in
            imageView.removeFromSuperview()
        })
    }
}
