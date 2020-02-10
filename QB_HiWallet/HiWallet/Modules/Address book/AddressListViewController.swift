//
//  AddressListViewController.swift
//  HiWallet
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 TOP. All rights reserved.
//

import LYEmptyView
import TOPCore
import UIKit


fileprivate let emptyViewHeight: CGFloat = 108
class AddressListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let user = TOPStore.shared.currentUser

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    // 是否是选择
    var isSelectModel = false
    var selectType: String?

    // 选择回的回调
    var callBack: ((_ contacts: Contacts) -> Void)?

    private var dataArray: [Contacts] = []
    private var resultArray: [Contacts] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func setup() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消".localized()
        let _textField = searchBar.value(forKey: "searchField") as? UITextField
        _textField?.attributedPlaceholder = NSAttributedString.init(string: "搜索名称".localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        _textField?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func config() {
        tableView.keyboardDismissMode = .onDrag
        title = "地址簿_address".localized()
        let item = UIBarButtonItem(image: UIImage(named: "Address_add"), style: .plain, target: self, action: #selector(rightBarAction))
        item.tintColor = App.Color.addressNavigationBar

        navigationItem.rightBarButtonItem = item
        tableView.ly_emptyView = LYEmptyView.empty(with: UIImage(named: "noData_icon"), titleStr: "暂无地址".localized(), detailStr: "")
        tableView.ly_emptyView.contentViewOffset = -(navigationHeight + emptyViewHeight) / 2
    }

    @objc func rightBarAction() {
        let dvc = AddressDetailTableViewController.loadFromSettingStoryboard()
        if let type = selectType {
            dvc.seletcSymbol = type
            dvc.saveCallBack = { contacts in

                if let callback = self.callBack {
                    callback(contacts)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        navigationController?.pushViewController(dvc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataArray.removeAll()
        for contast in user.addressBook {
            dataArray.append(contast)
        }
        //把常用的放在前面
        dataArray.sort { $0.commonlyUsed && !$1.commonlyUsed}

        if isSelectModel {
            dataArray = dataArray.filter { $0.symble == selectType }
        }
        resultArray = dataArray

        tableView.reloadData()

    }
}

extension AddressListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contacts = resultArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        cell.noteLabel.text = contacts.note
        cell.addressLabel.text = contacts.address
        cell.iconImageView.image = UIImage(named: contacts.symble + "_icon")
        cell.commonUsed.isHidden = !contacts.commonlyUsed
        cell.editIcon.isHidden = isSelectModel
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if isSelectModel {
            if let callback = callBack {
                callback(resultArray[indexPath.row])
                navigationController?.popViewController(animated: true)
            }
        } else {
            let dvc = AddressDetailTableViewController.loadFromSettingStoryboard()
            dvc.contacts = resultArray[indexPath.row]
            navigationController?.pushViewController(dvc, animated: true)
        }
    }
}

extension AddressListViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        resultArray = dataArray
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultArray = dataArray.filter({ (model) -> Bool in
            model.note.lowercased().contains(searchText.lowercased())
        })
        if searchText.isEmpty {
            resultArray = dataArray
        }
        tableView.reloadData()
    }
}
