//
//  AssetManagementController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetsManagementController: BaseViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.searchBar.delegate = self
//        self.tableview.dataSource = self
//        self.tableview.delegate = self
    }
    
//    override func setup() {
//        self.searchBar.delegate = self
//        self.tableview.dataSource = self
//        self.tableview.delegate = self
//    }

    //MARK: - tableview method
    private let datalist = ["", "", "", "", "", ""]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "top.cell.identifier.asset"
        
        let cell: AssetSwitchCell
        if let re_cell = tableview.dequeueReusableCell(withIdentifier: identifier ) as? AssetSwitchCell {
            cell = re_cell
        } else {
            cell = Nib.load(name: "AssetSwitchCellXIB").view as! AssetSwitchCell
        }
        
        cell.iconimageView.image = #imageLiteral(resourceName: "TOP_icon")
        cell.symbolLabel.text = "BTC"
        cell.fullnameLabel.text = "Bitcoin"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83.5
    }
}
