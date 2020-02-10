//
//  DiscoveryViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/21.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit


class DiscoveryViewController: BaseViewController {
    let _view = DiscoveryView(frame: .zero)
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "发现".localized()
        
        var testImages: [UIImage] = []
        for index in 1...6 {
            let image = UIImage.init(named: "img_test_\(index)")!
            testImages.append(image)
        }
        
        _view.images = testImages
    }
    private let identifier = "top.cell.identifier.asset"
    override func setup() {
        super.setup()
        
        _view.tableview.delegate = self
        _view.tableview.dataSource = self
        _view.tableview.register(DiscoveryCell.self, forCellReuseIdentifier: identifier)
        _view.tableview.register(DiscoverySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    private var datalist: [DiscoveryModel] = {
        let cell1 = DiscoveryModel.DiscoveryCellModel(title: "Staking",
                                                          info: "TOP Network的Staking项目",
                                                          image: UIImage.init(named: "icon_test_1")!)
        let cell2 = DiscoveryModel.DiscoveryCellModel(title: "EOSBET",
                                                           info: "基于EOS区块链的去中心化博彩游戏平台",
                                                           image: UIImage.init(named: "icon_test_2")!)
        let model1 = DiscoveryModel(sectionTitle: "为你推荐", cellList: [cell1, cell2, cell1])
        
        let model2 = DiscoveryModel(sectionTitle: "探索更多", cellList: [cell2, cell1, cell1])
        
        return [model1, model2]
    }()
}


extension DiscoveryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist[section].cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! DiscoveryCell
        let model = datalist[indexPath.section].cellList[indexPath.row]
        cell.setup(model: model)
        
        if datalist[indexPath.section].cellList.count - 1 == indexPath.row {
            cell.showLine = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! DiscoverySectionHeaderView
        
        headerview.titleLabel.text = datalist[section].sectionTitle
        
        switch section {
        case 0:
            headerview.actionLabel.bk_(whenTapped: { [weak self] in
                //TODO: detail with type
                
                let controller = UIViewController()
                controller.view.backgroundColor = UIColor.random()
                controller.title = "Detail"
                self?.navigationController?.pushViewController(controller, animated: true)
            })
        case 1:
            headerview.actionLabel.bk_(whenTapped: { [weak self] in
                //TODO: detail with type
                
                let controller = UIViewController()
                controller.view.backgroundColor = UIColor.random()
                controller.title = "Detail"
                self?.navigationController?.pushViewController(controller, animated: true)
            })
        default: break
        }
        
        return headerview
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiscoveryCell {
    func setup(model: DiscoveryModel.DiscoveryCellModel) {
        titleLabel.text = model.title
        infoLabel.text = model.info
        iconView.image = model.image
    }
}

struct DiscoveryModel {
    struct DiscoveryCellModel {
        var title: String
        var info: String
        var image: UIImage
    }
    
    var sectionTitle: String
    var cellList: [DiscoveryCellModel]
}
