//
//  NewRemindBackupController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/9.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore

class RemindBackupController: BaseViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextAction(_ sender: UIButton) {
        let controller = MnemonicVerifyController.loadFromSettingStoryboard()
        controller.mnemonic = self.mnenomic
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let mnenomic = TOPStore.shared.currentUser.mnemonic!
    private var datalist = [String]()
    override func setup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(BackupMnemonicCell.self, forCellWithReuseIdentifier: "BackupMnenomicCellID")
        let itemWidth = ((UIScreen.main.bounds.width - 18 - 40) / 4.0).rounded()
        flowLayout.itemSize = CGSize(width: itemWidth, height: 38)
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 10
        self.datalist = mnenomic.split(separator: " ").map { String($0) }
    }
    
    override func localizedString() {
        title = "备份助记词".localized()
        infoLabel.text = "以下是钱包的助记词，请仔细抄写并存于安全的地方，一旦丢失将无法找回。".localized()
        infoLabel.setLine(space: 6, font: UIFont.systemFont(ofSize: 14))
        tipLabel.text = "请不要使用截图的方式保存助记词，以防手机信息被非法窃取。谨慎查看周围环境，确保身边没有可疑人物和正在监控的摄像及录像设备。".localized()
        tipLabel.setLine(space: 6, font: UIFont.systemFont(ofSize: 13, weight: .medium))
        nextButton.setTitle("下一步".localized(), for: .normal)
    }
}

extension RemindBackupController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.datalist.count / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackupMnenomicCellID", for: indexPath) as! BackupMnemonicCell
        let index = indexPath.row + (indexPath.section * 4)
        cell.backgroundColor = App.Color.mnemonicVerifyCellBg
        cell.cornerRadius = 6
        cell.cellState = .normal
        cell.numberLabel.text = "\(index + 1)"
        cell.textLabel.text = datalist[index]
        return cell
    }
}
