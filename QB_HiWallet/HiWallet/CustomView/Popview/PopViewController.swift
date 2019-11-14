//
//  PopViewController.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/10.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class PopViewController: BaseViewController {
    var balanceText: NSAttributedString? {
        didSet {
            sendPopview.balanceLabel.attributedText = balanceText
        }
    }

    var tipText: String = "" {
        didSet {
            sendPopview.tipLabel.text = tipText
        }
    }

    var selectedSpeedAction: ActionBlock<Int>?
    var cancelAction: EmptyAction?

    var confirmAction: EmptyAction?
    var _height: CGFloat = 0
    var datalist: [SendPopViewModel]! {
        didSet {
            _height = 48 + 72 + 16 + 86 + 64 * CGFloat(datalist.count) + 24
            sendPopview = SendPopView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: _height))
            speedPopview = SendSpeedPopView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: _height))
            sendPopview.datalsit = datalist
        }
    }

    func reloadData(data: [SendPopViewModel]) {
        sendPopview.reloadData(list: data)
    }

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private var sendPopview: SendPopView!
    private var speedPopview: SendSpeedPopView!

    override func setup() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 1

        addPopView()
    }

    private func addPopView() {
        sendPopview.titleLabel.text = "发送".localized()
        sendPopview.rightButton.bk_(whenTapped: { [weak self] in
            if let cancelAction = self?.cancelAction {
                cancelAction()
            }
            self?.dismiss()
        })
        sendPopview.submitButton.bk_(whenTapped: { [weak self] in
            self?.confirmAction?()
        })
        sendPopview.actionDelegate = self
        popViews.append(sendPopview)
        stackView.addArrangedSubview(sendPopview)

        speedPopview.titleLabel.text = "选择到账时间".localized()
        speedPopview.leftButton.bk_(whenTapped: { [weak self] in
            self?.scrollView.isUserInteractionEnabled = false
            self?.pop()
        })
        speedPopview.selectedActionBlock = { [weak self] (index: IndexPath) in
            self?.scrollView.isUserInteractionEnabled = false
            self?.pop()
            self?.selectedSpeedAction?(index.row)
        }

        stackView.addArrangedSubview(speedPopview)
    }

    override func layout() {
        scrollView.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalTo(_height)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        scrollView.frame.origin.y = view.bounds.height

        stackView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
            $0.height.equalTo(_height)
            $0.width.equalToSuperview().multipliedBy(2)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.frame.origin.y = view.bounds.height
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.frame.origin.y = self.view.bounds.height - self._height
        }, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendPopview.addRounderCorner(corners: [.topLeft, .topRight], radius: CGSize(width: 16, height: 16))
        speedPopview.addRounderCorner(corners: [.topLeft, .topRight], radius: CGSize(width: 16, height: 16))
    }

    var popViews: [BasePopview] = []
    private func push(popView: BasePopview) {
        let offset = scrollView.contentOffset.x + scrollView.bounds.width
        let point = CGPoint(x: offset, y: 0)
        scrollView.setContentOffset(point, animated: true)
        // ugly implementation
        popViews.append(popView)
        if popViews.count >= 2 {
            scrollView.isScrollEnabled = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollView.isUserInteractionEnabled = true
        }
    }

    private func pop() {
        let offset = scrollView.contentOffset.x - scrollView.bounds.width
        let point = CGPoint(x: offset, y: 0)
        scrollView.setContentOffset(point, animated: true)
        popViews.removeLast()
        if popViews.count <= 1 {
            scrollView.isScrollEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollView.isUserInteractionEnabled = true
        }
    }

    private func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.frame.origin.y = self.view.bounds.height
        }, completion: { _ in
            self.popViews.removeAll()
            self.dismiss(animated: false, completion: nil)
        })
    }

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss()
//    }
}

extension PopViewController: PopActionService {
    func tableviewDidSelected(_ popView: BasePopview, indexpath: IndexPath) {
        if let list = datalist[indexpath.row].nextList {
            speedPopview.datalist = list
        }
        scrollView.isUserInteractionEnabled = false
        push(popView: popView)
    }
}

extension PopViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0 {
            self.scrollView.isScrollEnabled = false
        }
    }
}
