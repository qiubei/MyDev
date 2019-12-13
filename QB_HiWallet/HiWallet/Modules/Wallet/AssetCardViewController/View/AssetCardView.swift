//
//  AssetCardView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

//TODO: 可以重构一下，把 tableview 相关的内容放到 info 里面去做
protocol AssetCardViewDelegate: class {
    func numberOfAssetCard(assetcardView: AssetCardView) -> Int
    func assetCardView(assetcardView: AssetCardView, cardFor index: Int) -> AssetCard
    func assetCardView(assetcardView: AssetCardView, didSelected index: Int)
    func assetCardView(assetcardView: AssetCardView, copyFor index: Int)
    func assetCardView(assetcardView: AssetCardView, didSelectedInfoCell indexPath: IndexPath)
    
    func startRefreshAction()
    func addCardAction()
}

private let cardRatio: CGFloat = 170.0/343
private let magicNum = 12580
class AssetCardView: UIView {
    
    var pendingTxNubmer = 88 {
        didSet {
            if pendingTxNubmer > 0 {
                cardInfoView.tableview.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            }
        }
    }
    weak var delegate: AssetCardViewDelegate?
    private let datalist = [("发送".localized(), UIImage.init(named: "icon_asset_send")),
                            ("接受".localized(), UIImage.init(named: "icon_asset_receive")),
                            ("交易记录".localized(), UIImage.init(named: "icon_tx_history")),
                            ("管理".localized(), UIImage.init(named: "icon_asset_manage"))]
    private let cardInfoView = AssetCardInfoView(frame: .zero)
    private var cards: [AssetCard] = []
    private var titleLabel = UILabel().then {
        $0.textColor = App.Color.titleColor
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        $0.text = "我的账户".localized()
    }
    
    private var bottomLabel = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.textColor = App.Color.createCard
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
        $0.text = "最多可创建3个".localized()
    }
    
    private var bottomSafaGuideView = UIView().then {
        $0.backgroundColor = App.Color.bgColorWhite
    }
    
    private lazy var cardAddView: AssetCardAddView = {
        return AssetCardAddView(frame: .zero)
    }()
    
    private lazy var addCard: AssetAddCard = {
        AssetAddCard(frame: .zero).then {
            $0.isUserInteractionEnabled = true
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    private func setup() {
        cardInfoView.isHidden = true
        cardInfoView.tableview.refreshControl = UIRefreshControl().then {
            $0.addTarget(self, action: #selector(self.refreshAction), for: .valueChanged)
        }
        cardInfoView.tableview.delegate = self
        cardInfoView.tableview.dataSource = self
        cardInfoView.tableview.register(LocalTableviewCell.self, forCellReuseIdentifier: "cell_reuse_id")
        addSubview(titleLabel)
        addSubview(cardInfoView)
        addSubview(bottomLabel)
        addSubview(bottomSafaGuideView)
        bringSubviewToFront(bottomSafaGuideView)
    }
    
    @objc
    private func refreshAction() {
        self.delegate?.startRefreshAction()
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.equalTo(18)
            $0.height.equalTo(37)
        }
        
        cardInfoView.snp.makeConstraints {
            $0.bottom.top.left.right.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomSafaGuideView.snp.top).offset(-16)
        }
        
        bottomSafaGuideView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    /// 停止刷新
    func stopRefresh() {
        cardInfoView.tableview.refreshControl?.endRefreshing()
    }
    
    //TODO: 是否传入 card 会更好一点，毕竟是 view 的接口。
    /// 默认展开 index 卡片。index 以 0 开始。
    /// - Parameter index: 卡片的索引，添加卡片的顺序，从 0 开始
    func defaultSelected(index: Int) {
        reloadData()
        isSelected = true
        didSelected(index: index)
    }
    
    func reloadData() {
        cardInfoView.isHidden = true
        removeCards()
        addCards()
        addEvent()
        cardsUpdateLayout()
    }
    
    func didSelected(index: Int, animated: Bool) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeCards() {
        cards.forEach {
            $0.removeFromSuperview()
        }
        cards.removeAll()
    }
    
    private func addCards() {
        if let delegate = delegate {
            let cardCount = delegate.numberOfAssetCard(assetcardView: self)
            for index in 0..<cardCount {
                let card = delegate.assetCardView(assetcardView: self, cardFor: index)
                card.tag = index + magicNum
                
                cards.append(card)
                addSubview(card)
            }
        }
    }
    
    //TODO: 考虑使用比例约束
    private func cardsUpdateLayout() {
        if cards.isEmpty { return }
        
        cards[0].snp.makeConstraints {
            $0.top.equalTo(67)
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.height.equalTo(cards[0].snp.width).multipliedBy(cardRatio)
        }
        
        for index in 1..<cards.count {
            cards[index].snp.makeConstraints {
                $0.left.right.width.height.equalTo(cards[0])
                $0.top.equalTo(cards[index - 1].snp.bottom).offset(16)
            }
        }
        
        setupAddCardView()
        setupAddCard()
    }
    
    private func setupAddCardView() {
        if cards.count == 1 {
            addSubview(cardAddView)
            cardAddView.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
                $0.bottom.equalTo(bottomSafaGuideView.snp.top).offset(-12)
                $0.height.equalTo(59)
                $0.centerX.equalToSuperview()
            }
            
            cardAddView.bk_(whenTapped: { [weak self] in
                self?.delegate?.addCardAction()
            })
        } else {
            cardAddView.removeFromSuperview()
        }
    }
    
    private func setupAddCard() {
        if cards.count == 2 {
            addSubview(addCard)
            addCard.snp.makeConstraints {
                $0.left.equalTo(16)
                $0.right.equalTo(-16)
                $0.height.equalTo(79)
                $0.top.equalTo(cards.last!.snp.bottom).offset(16)
            }
            
            addCard.bk_(whenTapped: { [weak self] in
                self?.delegate?.addCardAction()
            })
        } else {
            addCard.removeFromSuperview()
        }
    }
    
    private var selectedIndex = 1
    private var isSelected = false
    
    private func addEvent() {
        cardInfoView.card.bk_(whenTapped: { [unowned self] in
            self.isSelected = !self.isSelected
            self.didSelected(index: self.selectedIndex)
        })
        
        cards.forEach { card in
            card.bk_(whenTapped: { [weak self] in
                guard let self = self else { return }
                self.selectedIndex = card.tag % magicNum
                self.isSelected = !self.isSelected
                self.didSelected(index: card.tag % magicNum)
            })
            card.copyActionBlock = { [unowned self] in
                self.delegate?.assetCardView(assetcardView: self, copyFor: card.tag % magicNum )
            }
        }
    }
    
    var selectedCard: AssetCard!
    private func didSelected(index: Int) {
//        if index >= cards.count || cards.count == 1 { return }
        if index >= cards.count { return }
        delegate?.assetCardView(assetcardView: self, didSelected: index)
        if isSelected {
            selectedCard = self.cards[index]
            cardInfoView.card.setupWith(name: selectedCard.nameLabel.text ?? "",
                                        address: selectedCard.addressLabel.text ?? "",
                                        amount: selectedCard.amountLabel.text ?? "",
                                        balance: selectedCard.balanceLabel.text ?? "")
            startAnimation(selectedIndex: index, completion: { [weak self] in
                self?.cardInfoView.isHidden = false
                self?.selectedCard.isHidden = true
            })
        } else {
            cardInfoView.isHidden = true
            selectedCard.isHidden = false
            resumeAnimation(comletion: nil)
        }
    }
}

extension AssetCardView {
    //TODO: 计算有点问题。
    private func startAnimation(selectedIndex: Int, completion: EmptyAction?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.titleLabel.alpha = 0
            
            var count: CGFloat = -1 // 用来辅助计算底部的偏移量
            self.cards.forEach { (card) in
                if card.tag % magicNum == selectedIndex {
                    card.transform = CGAffineTransform(translationX: 0, y: -card.upwardOffset)
                    return
                }
                card.transform = CGAffineTransform(translationX: 0, y: card.downwardOffset + count * 0.33 * card.bounds.height)
                count += 1
            }
            
            if self.cards.count == 2 {
                self.addCard.transform = CGAffineTransform(translationX: 0, y: self.addCard.downwardOffset + self.addCard.bounds.height)
            }
        }, completion: { _ in
            completion?()
        })
    }
    
    private func resumeAnimation(comletion: EmptyAction?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 1
            self.cards.forEach {
                $0.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            self.addCard.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { _ in
            comletion?()
        })
    }
}

extension AssetCardView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuse_id") as! LocalTableviewCell
        
        cell.selectionStyle = .none
        cell.titleLabel.text = datalist[indexPath.row].0
        cell.iconView.image = datalist[indexPath.row].1
        
        if indexPath.row == 2 && pendingTxNubmer > 0 {
            cell.rightView = NumberView(number: pendingTxNubmer)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.assetCardView(assetcardView: self, didSelectedInfoCell: indexPath)
    }
}

private let startYPosition: CGFloat = 10
fileprivate extension UIView {
    /// 用来计算卡片选中时向上移动的动画偏移量
    var upwardOffset: CGFloat {
        return self.frame.origin.y - startYPosition
    }
    
    /// 用来计算卡片向下移动的动画偏移量
    var downwardOffset: CGFloat {
        return screenHeight - bounds.height - frame.origin.y
    }
}
