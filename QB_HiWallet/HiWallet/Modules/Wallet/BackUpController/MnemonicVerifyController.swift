//
//  MnemonicVerifyController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/9.
//  Copyright © 2019 TOP. All rights reserved.
//

import BlocksKit
import UIKit
import TOPCore

class MnemonicVerifyController: BaseViewController {
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var selectedViews: [BackupMnemonicCell]!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var confirmButton: UIButton!
    
    var mnemonic: String! {
        didSet {
            if mnemonic == nil { return }
            viewModel = MnemonicVerifyViewModel(mnemonic: mnemonic)
        }
    }
    
    private var pickedList: [Int: String] = [:]
    private var remainList: [String] = []
    private var viewModel: MnemonicVerifyViewModel?
    @IBAction func confirmAction(_ sender: UIButton) {
        viewModel?.verifyMnemonic(completion: { (result) in
            switch result {
            case .success:
                (inject() as UserStorageServiceInterface).update({ (user) in
                    user.backup?.currentlyBackup?.add(.mnemonic)
                })
                Toast.showToast(text: "备份成功".localized())
                let count = self.navigationController!.viewControllers.count
                let controller = self.navigationController!.viewControllers[count - 4]
                self.navigationController?.popToViewController(controller, animated: true)
            case .failure(let error):
                switch error {
                case .empty:
                    Toast.showToast(text: "请输入助记词！".localized())
                    return
                default:
                    Toast.showToast(text: "助记词不正确".localized())
                }
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackupMnemonicCell.self, forCellWithReuseIdentifier: "BackupMnenomicCellID")
        let itemWidth = Int((UIScreen.main.bounds.width - 18 - 44) / 4.0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 38)
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 10
        
        setupView()
    }

    override func localizedString() {
        title = "确认助记词".localized()
        infoLabel.text = "请选择以下编号所对应的单词".localized()
        confirmButton.setTitle("确认".localized(), for: .normal)
    }
    
    private func setupView() {
        selectedViews.forEach { selectedView in
            selectedView.bk_(whenTapped: { [weak self] in
                self?.viewModel?.deselected(deselectedItem: selectedView.textLabel.text ?? "", completion: { (picked, remain) in
                    self?.updateViews(pickedList: picked, list: remain)
                })
            })
        }
        
        viewModel?.loadRandomData(block: { [weak self] (pickedList, remainList) in
            self?.updateViews(pickedList: pickedList, list: remainList)
        })
    }
    
    private func updateViews(pickedList: [Int: String], list: [String]) {
        for (index, dic) in pickedList.sorted(by: { $0.key < $1.key}).enumerated() {
            if index >= selectedViews.count { return }
            selectedViews[index].numberLabel.text = "\(dic.key + 1)"
            selectedViews[index].textLabel.text = dic.value
            selectedViews[index].cellState = .choosed
        }
        
        remainList = list
        collectionView.reloadData()
    }
}

extension MnemonicVerifyController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = self.remainList.count
        if (count % 4) == 0 {
           return count / 4
        }
        return count / 4 + 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.remainList.count
        if (section + 1) * 4 <= count {
            return 4
        }
        return count % 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackupMnenomicCellID", for: indexPath) as! BackupMnemonicCell
        DLog("section - row \(indexPath.section) - \(indexPath.row)")
        let index = indexPath.row + (indexPath.section * 4)
        let value = remainList[index]
        cell.cellState = .none
        cell.numberLabel.text = "\(index + 1)"
        cell.textLabel.text = value
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row + (indexPath.section * 4)
        let value = remainList[index]
        viewModel?.didSelect(selectedItem: value, completion: { [weak self] (picked, remain) in
            self?.updateViews(pickedList: picked, list: remain)
        })
    }
}
