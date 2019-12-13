//
//  NewVerifyMnemonicController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/9.
//  Copyright © 2019 TOP. All rights reserved.
//

import BlocksKit
import UIKit
import TOPCore

class MnemonicVerifyController: BaseViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var selectedViews: [BackupMnemonicCell]!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmAction(_ sender: UIButton) {
        for (normalIndex, randomIndex) in checkingData {
            if randomIndex < 0 {
                Toast.showToast(text: "请输入助记词！".localized())
                return
            }
            if normalList[normalIndex] != randomList[randomIndex] {
                Toast.showToast(text: "助记词不正确".localized())
                return
            }
        }
        (inject() as UserStorageServiceInterface).update({ (user) in
            user.backup?.currentlyBackup?.add(.mnemonic)
        })
        Toast.showToast(text: "备份成功".localized())
        let count = self.navigationController!.viewControllers.count
        let controller = self.navigationController!.viewControllers[count - 4]
        self.navigationController?.popToViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var mnemonic: String! {
        didSet {
            let list = mnemonic.split(separator: " ").map { String($0) }
            for (index, value) in list.enumerated() {
                normalList[index] = value
            }

            var random = [String]()
            for (_, value) in normalList.enumerated() {
                let randomIndex = Int(arc4random_uniform(UInt32(random.count)))
                random.insert(value.value, at: randomIndex)
            }
            
            for (_index, value) in random.enumerated() {
                randomList[_index] = value
            }
            pickingData = randomList
        }
    }

    /// checkingData
    /// key: is the index of normal list for the selected word
    /// value: is the index of random list for the selected word
    private var datalist: [(key: Int, value: String)] = []
    private var checkingData: [Int: Int] = [:]
    private var normalList = [Int: String]()
    private var pickingData: [Int: String] = [:]
    private var randomList: [Int: String] = [:]
    override func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackupMnemonicCell.self, forCellWithReuseIdentifier: "BackupMnenomicCellID")
        let itemWidth = Int((UIScreen.main.bounds.width - 18 - 44) / 4.0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 38)
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 10
        
        randomSelectView()
    }

    override func localizedString() {
        title = "确认助记词".localized()
        infoLabel.text = "请选择以下编号所对应的单词".localized()
        confirmButton.setTitle("确认".localized(), for: .normal)
    }
    
    private func randomSelectView() {
        while checkingData.count < 3 {
            if let item = self.normalList.randomElement() {
                for (index, value) in normalList.enumerated() {
                    if item == value, !checkingData.keys.contains(index) {
                        checkingData[index] = -1
                    }
                }
            }
        }

        var index = 0
        for (key, _) in checkingData.sorted(by: { $0.key < $1.key}) {
            let _view = selectedViews[index]
            _view.tag = key
            _view.cellState = .choosed
            _view.numberLabel.text = "\(key + 1)"
            _view.cornerRadius = 8
            _view.backgroundColor = App.Color.mnemonicVerifyCellBg
            // add Event
            _view.bk_(whenTapped: {
                if let value = self.checkingData[_view.tag], value != -1 {
                    self.pickingData[value] = self.randomList[value]
                    self.checkingData[_view.tag] = -1
                    self.updateSelection()
                }
            })
            index += 1
            if index > 2 { break }
        }
        // setup views
        reloadSelectedView()
    }

    private func reloadSelectedView() {
        var index = 0
        for (_, value) in checkingData.sorted(by: { $0.key < $1.key}) {
            let _view = selectedViews[index]
            if value == -1 {
                _view.textLabel.text = ""
            } else {
                _view.textLabel.text = "\(self.randomList[value]!)"
            }

            index += 1
            if index > 2 { break }
        }
    }

    private func updateSelection() {
        reloadSelectedView()
        collectionView.reloadData()
    }
}

extension MnemonicVerifyController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.datalist = pickingData.map { $0 }.filter { $0.value != "" }.sorted {$0.key < $1.key }
        let count = self.datalist.count
        if (count % 4) == 0 {
           return count / 4
        }
        return count / 4 + 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = pickingData.filter { $0.value != "" }.count
        if (section + 1) * 4 > count {
            return count % 4
        }
        
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackupMnenomicCellID", for: indexPath) as! BackupMnemonicCell
        let index = indexPath.row + (indexPath.section * 4)
        let dic = datalist[index]
        cell.backgroundColor = App.Color.mnemonicVerifyCellBg
        cell.cornerRadius = 6
        cell.cellState = .none
        cell.numberLabel.text = "\(index + 1)"
        cell.textLabel.text = dic.value
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.datalist.count <= (self.normalList.count  - 3) { return }
        let index = indexPath.row + indexPath.section * 4
        let dic = datalist[index]
        // `delete` random list value
        pickingData.removeValue(forKey: dic.key)
        // add value to checking data list
        let list = checkingData.sorted(by: { $0.key < $1.key})
        for (key, value) in list {
            if value == -1 {
                checkingData[key] = dic.key
                break
            }
        }
        // update view
        updateSelection()
    }
}
