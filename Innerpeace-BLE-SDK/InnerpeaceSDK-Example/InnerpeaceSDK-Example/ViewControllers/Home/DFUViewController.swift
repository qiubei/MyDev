//
//  DFUViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import BLESDK
import SVProgressHUD

class DFUViewController: UIViewController {
    private let fileURL = URL(string: "https://naptime-test.oss-cn-hangzhou.aliyuncs.com/firmwares%2F1.1.97.zip?OSSAccessKeyId=LTAIC1sff9kM7r9d&Expires=1561924085&Signature=pKWQXg27%2BrmYxqySwPHPr33D4EA%3D")!
    private var packageURL: URL!


    @IBOutlet weak var currentFirmwareVersion: UILabel!
    @IBOutlet weak var packageInfo: UILabel!
    @IBAction func startDFU(_ sender: UIButton) {
        do {
            try Innerpeace.ble.dfu(fileURL: self.packageURL)
        } catch(let error) {
            print(error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadTask()

        NotificationCenter.default.addObserver(self, selector: #selector(self.update(notification:)), name: NotificationName.dfuStateChanged.name, object: nil)
        self.currentFirmwareVersion.text = lang("当前固件版本：\n") + Innerpeace.ble.deviceInfo.firmware
        self.currentFirmwareVersion.adjustsFontSizeToFitWidth = true
    }



    /// DFU： the handler of DFU
    /// ** Note ** you have to disconnect the device after dfu successed.
    /// - Parameter notification: using the parmeter you can get the DFU state when processing DFU.
    @objc private func update(notification: Notification) {
        let info = notification.userInfo
        let dfuState = info?[NotificationKey.dfuStateKey] as? DFUState
        self.packageInfo.text = "\(dfuState!)"

        switch dfuState! {
        case .succeeded:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500)) {
                Innerpeace.ble.disconnect()
            }
        default:
            break
        }
    }


    func downloadTask() {
        let request = URLRequest(url: fileURL)
        let session = URLSession.shared
        session.downloadTask(with: request) { [weak self](url, response, error) in
            do {
                guard error == nil else {
                    SVProgressHUD.showError(withStatus: lang("下载固件失败"))
                    return
                }
                guard let url = url else {
                    SVProgressHUD.showError(withStatus: lang("下载固件失败"))
                    return
                }
                let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("innerpeace_update.zip")
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    try FileManager.default.removeItem(at: fileURL)
                }
                try FileManager.default.moveItem(at: url, to: fileURL)
                self?.packageURL = fileURL
            } catch {
                print("dfu error: \(error)")
            }
        }.resume()
    }
}
