//
//  HomeViewController.swift
//  HiWallet
//
//  Created by Jax on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import TOPCore
import UIKit
import LYEmptyView

class HomeViewController: BaseViewController, UINavigationControllerDelegate {
    @IBOutlet var headView: HomeHeadView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navView: UIView!
    @IBOutlet var titeLabel: UILabel!
    @IBOutlet var navWidthConstraint: NSLayoutConstraint!

    private var blackNav: Bool = false
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        titeLabel.text = "区块链新青年".localized()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: NotificationConst.userInfoChange), object: nil)
        NotificationName.deleteAllNotification.observe(sender: self,
                                                       selector: #selector(deleteUserAction))
        navigationController?.delegate = self

        headView.height = screenWidth / 375.8 * 566
        headView.delegate = self
        headView.startAnimation()

        let localStr = LocalizationLanguage.systemLanguage.isChinese ? "CN" : "EN"
        let image = UIImage.init(named: "Home_Help_" + localStr)
        headView.helpImageView.image = image
        headView.balanceBgView.bk_(whenTapped: { [weak self] in
            let controller = RewardDetailViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
    }

    override func layout() {
        navWidthConstraint.constant = navigationHeight
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppHandler.shared.checkAppUpdate(self)
        reloadData()
    }
}

extension HomeViewController {
    @objc func reloadData() {
        viewModel.loadData { [weak self] in

            self?.headView.balanceLalel.text = self?.viewModel.balance
            self?.tableView.reloadData()
            self?.headView.reloadCoin(coinInfoList: self?.viewModel.getShowCoin() ?? [])
        }
    }

    @objc func deleteUserAction() {
        headView.clearData()
    }
}

extension HomeViewController: homeheadViewDelegate {
    func loadNewCoin() {
        headView.reloadCoin(coinInfoList: viewModel.getShowCoin())
    }

    func takeCoin(awardID: String) {
        viewModel.takeCoin(awardID: awardID)
    }

    func showHelp() {
        WebMannager.showGameWebViewWithUrl(url: "http://192.168.10.25:3000/raiders", controller: self, gameID: "0")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeGameCellID") as! HomeTableViewCell
        cell.setData(model: viewModel.activityList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "区块链挑战联盟".localized()
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * App.widthRatio
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.activityList[indexPath.row]
        WebMannager.showGameWebViewWithUrl(url: model.activityUrl, controller: self, gameID: model.aid)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y > 10 {
            if blackNav { return }
            blackNav = true
            UIView.animate(withDuration: 0.3) {
                self.navView.backgroundColor = .white
                self.titeLabel.textColor = .black
            }

        } else {
            if !blackNav { return }
            blackNav = false
            UIView.animate(withDuration: 0.3) {
                self.navView.backgroundColor = .clear
                self.titeLabel.textColor = .white
            }
        }
    }
}

extension HomeViewController {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.isEqual(self), animated: true)
    }
}
