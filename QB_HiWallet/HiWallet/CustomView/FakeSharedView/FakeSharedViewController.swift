//
//  FakeSharedViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import Then
import SnapKit


struct FakeSharedModel {
    let text: String
    let image: UIImage
}

protocol FakeUIService: class {
    func dismissAction()
    func shareAction()
    func refreshAction()
    func copyLinkAction()
    func openInSafariAction()
}

class FakeSharedViewController: BaseViewController {
    
    private let sharedViewHeight: CGFloat = 340
    weak var uiAction: FakeUIService!
    var datalist: [[FakeSharedModel]] = []
    
    private func loadData() {
        let model01 = FakeSharedModel(text: "分享".localized(), image: UIImage.init(named: "icon_share_dark")!)
        let model10 = FakeSharedModel(text: "刷新页面".localized(), image: UIImage.init(named: "icon_refresh")!)
        let model11 = FakeSharedModel(text: "复制链接".localized(), image: UIImage.init(named: "icon_copy_link")!)
        let model12 = FakeSharedModel(text: "在 Safari 中打开".localized(), image: UIImage.init(named: "icon_safari")!)
        
        datalist.append([model01])
        datalist.append([model10, model11, model12])

    }
    
    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
    
    private let tableview = UITableView(frame: .zero, style: .grouped)
    private let imageView = UIImageView()
    private let button = UIButton()
    private let headerLineView = UIView()
    override func setup() {
        super.setup()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.addSubview(tableview)
        
        headerLineView.backgroundColor = App.Color.lineColor
        headerView.addSubview(imageView)
        headerView.addSubview(button)
        headerView.addSubview(headerLineView)
        imageView.cornerRadius = 10
        imageView.image = UIImage.init(named: "icon_app")
        let image = UIImage.init(named: "icon_share_close")
        button.setImage(image, for: .normal)
        button.bk_(whenTapped: { [weak self] in
            self?.dismissAnimation(completion: {
                if self?.uiAction == nil { return }
                self?.uiAction.dismissAction()
            })
        })
        
        tableview.separatorStyle = .none
        tableview.tableHeaderView = headerView
        tableview.isScrollEnabled = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(WebSharedViewCell.self, forCellReuseIdentifier: WebSharedViewCell.identifier)
    }
    
    override func layout() {
        super.layout()
        
        tableview.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(sharedViewHeight)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(15)
        }
        
        button.snp.makeConstraints {
            $0.height.width.equalTo(30)
            $0.right.equalTo(-15)
            $0.centerY.equalToSuperview()
        }
        
        headerLineView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(imageView.snp.bottom).offset(15)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.popAnimation()
        tableview.addRounderCorner(corners: [.topLeft, .topRight], radius: CGSize(width: 8, height: 8))
    }
}

extension FakeSharedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WebSharedViewCell.identifier) as! WebSharedViewCell
        let model = datalist[indexPath.section][indexPath.row]
        cell.titleLabel.text = model.text
        cell.accessoryImageview.image = model.image
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var corners: UIRectCorner = []
        
        // first row, cornerRadius set with topLeft and topRight
        if 0 == indexPath.row {
            corners = [.topLeft, .topRight]
        }
        
        // last row. cornerRadius set with bottomLeft and bottomRight
        if (datalist[indexPath.section].count - 1) == indexPath.row {
            corners.insert([.bottomLeft, .bottomRight])
            if let _cell = cell as? WebSharedViewCell {
                _cell.lineView.isHidden = true
            }
        }
        
        let _bounds = CGRect(x: 15, y: 0, width: cell.bounds.width - 30, height: cell.bounds.height)
        let path = UIBezierPath(roundedRect: _bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 12, height: 12))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        cell.layer.mask = shape
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if uiAction == nil { return }
        
        dismissAnimation { [weak self] in
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                self?.uiAction.shareAction()
            case (1,0):
                self?.uiAction.refreshAction()
            case (1,1):
                self?.uiAction.copyLinkAction()
            case (1,2):
                self?.uiAction.openInSafariAction()
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 13.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension FakeSharedViewController {
    func popAnimation() {
        tableview.frame.origin.y = view.bounds.height
        UIView.animate(withDuration: 0.25) {
            self.tableview.frame.origin.y = self.view.bounds.height - self.sharedViewHeight
        }
    }
    
    func dismissAnimation(completion: EmptyAction?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.tableview.frame.origin.y = self.view.bounds.height
        }) { (flag) in
            if flag {
                self.tableview.removeFromSuperview()
                self.dismiss(animated: false, completion: {
                    completion?()
                })
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissAnimation(completion: nil)
    }
}
