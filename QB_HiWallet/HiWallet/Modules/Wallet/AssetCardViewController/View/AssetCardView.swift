//
//  AssetCardView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/12/11.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore

protocol AssetCardViewDelegate: class {
    func numberOfAssetCard(assetcardView: AssetCardView) -> Int
    func assetCardView(assetcardView: AssetCardView, cardFor index: Int) -> AssetCard
    func assetCardView(assetcardView: AssetCardView, didSelected index: Int)
    func assetCardView(assetcardView: AssetCardView)
    func assetCardView(assetcardView: AssetCardView, didSelectedInfoCell indexPath: IndexPath)
    func assetCardView(assetcardView: AssetCardView, unSelected index: Int)
    
    func assetCardViewTapAddCardAction()
}

private let cardRatio: CGFloat = 170.0/343
private let magicNum = 12580
private let visibleFieldOfBottomCard: CGFloat = 68
class AssetCardView: UIView {
    
    let cardInfoView = AssetCardInfoView(frame: .zero)
    weak var delegate: AssetCardViewDelegate?
    var pendingTxNubmer = 0 {
        didSet {
            cardInfoView.pendingTxNubmer = pendingTxNubmer
        }
    }
    private var isSelected = true
    private var animationDuration = 0.35
    private var selectedIndex = 0
    private var cards: [AssetCard] = []
    private let edgeMargin: CGFloat = 16
    private let yCardsMargin: CGFloat = 16
    private let yStartPosition: CGFloat = 67
    private let bottomMarginValue: CGFloat = statusHeight > 20 ? 30 : 0
    private var cardHeight: CGFloat {
        return (screenWidth - 2 * edgeMargin) * cardRatio
    }
    
    private var selectedCard: AssetCard!
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
        $0.text = "最多可创建 3 个".localized()
    }
    
    private lazy var cardAddView: AssetCardAddView = {
        return AssetCardAddView(frame: .zero)
    }()
    
    private lazy var addCard: AssetAddCard = {
        AssetAddCard(frame: .zero).then {
            $0.isUserInteractionEnabled = true
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    private func setup() {
        cardInfoView.delegate = self
        cardInfoView.card.copyActionBlock = { [unowned self] in
            self.delegate?.assetCardView(assetcardView: self)
        }
        addSubview(titleLabel)
        addSubview(cardInfoView)
        addSubview(bottomLabel)
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
        
        bottomLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(16 + bottomMarginValue))
        }
    }
    
    private var selectecIndex = 0
    /// 默认展开 index 卡片。index 以 0 开始。
    /// - Parameter index: 卡片的索引，添加卡片的顺序，从 0 开始
    func defaultSelected(index: Int) {
        selectedIndex = index
        reloadData()
    }
    
    private func reloadData() {
        removeCards()
        addCards()
        addEvent()
        cardsUpdateLayout()
        
        setupData()
    }
    
    private func setupData() {
        if selectedIndex >= cards.count { return }
        selectedCard = cards[selectedIndex]
        cardInfoView.isHidden = false
        selectedCard.isHidden = true
        isSelected = true
        
        cardInfoView.card.colors = selectedCard.colors
        cardInfoView.card.setupWith(name: selectedCard.nameLabel.text ?? "",
                                    address: selectedCard.addressLabel.text ?? "",
                                    amount: selectedCard.amountLabel.text ?? "",
                                    balance: selectedCard.balanceLabel.text ?? "",
                                    iconImage: selectedCard.bgIconview.image ?? UIImage())
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
    
    var smallScreenOffset: CGFloat = 0
    
    //TODO: 考虑使用比例约束
    private func cardsUpdateLayout() {
        if cards.isEmpty { return }
        
        var index: CGFloat = CGFloat(cards.count - 1)
        self.cards.forEach { (card) in
            if card.tag % magicNum == self.selectedIndex {
                card.snp.makeConstraints {
                    $0.left.equalTo(16)
                    $0.right.equalTo(-16)
                    $0.top.equalTo(10)
                    $0.height.equalTo(card.snp.width).multipliedBy(cardRatio)
                }
                return
            }
            
            card.snp.makeConstraints {
                $0.left.equalTo(16)
                $0.right.equalTo(-16)
                $0.height.equalTo(card.snp.width).multipliedBy(cardRatio)
                $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-index * visibleFieldOfBottomCard - smallScreenOffset)
            }
            index -= 1
        }
        
        setupAddCardView()
        setupAddCard()
    }
    
    private func setupAddCardView() {
        if cards.count == 1 {
            addSubview(cardAddView)
            cardAddView.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
                $0.height.equalTo(59)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-(16 + bottomMarginValue))
            }
            
            cardAddView.bk_(whenTapped: { [weak self] in
                guard let self = self else { return }
                if !self.isAnimating {
                    self.delegate?.assetCardViewTapAddCardAction()
                }
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
                $0.bottom.equalToSuperview().offset(visibleFieldOfBottomCard + bottomMarginValue)
            }
            
            addCard.bk_(whenTapped: { [weak self] in
                guard let self = self else { return }
                if !self.isAnimating {
                    self.delegate?.assetCardViewTapAddCardAction()
                }
            })
            
            addCard.isHidden = true
        } else {
            addCard.removeFromSuperview()
        }
    }
    
    private func addEvent() {
        cardInfoView.card.bk_(whenTapped: { [unowned self] in
            if !self.isAnimating {
                self.isSelected = !self.isSelected
            }
            self.didSelected(index: self.selectedIndex)
        })
        
        cards.forEach { card in
            card.bk_(whenTapped: { [weak self] in
                guard let self = self else { return }
                if !self.isAnimating {
                    self.isSelected = !self.isSelected
                }
                self.didSelected(index: card.tag % magicNum)
            })
        }
    }
    
    var isAnimating = false // 去除多点触控
    private func didSelected(index: Int) {
        if isAnimating { return }
        if index >= cards.count || cards.count == 1 { return }
        if isSelected {
            selectedIndex = index
            selectedCard = cards[index]
            delegate?.assetCardView(assetcardView: self, didSelected: index)
            cardInfoView.card.colors = selectedCard.colors
            cardInfoView.card.setupWith(name: selectedCard.nameLabel.text ?? "",
                                        address: selectedCard.addressLabel.text ?? "",
                                        amount: selectedCard.amountLabel.text ?? "",
                                        balance: selectedCard.balanceLabel.text ?? "",
                                        iconImage: selectedCard.bgIconview.image ?? UIImage())
            startAnimation(selectedIndex: index, completion: { [weak self] in
                self?.cardInfoView.isHidden = false
                self?.selectedCard.isHidden = true
            })
        } else {
            
            if selectedCard != nil {
                delegate?.assetCardView(assetcardView: self, unSelected: selectedCard.tag % magicNum)
                selectedCard.isHidden = false
            }
            cardInfoView.isHidden = true
            resumeAnimation(completion: { [weak self] in
                self?.addCard.isHidden = false
            })
        }
    }
}

//MARK: - AssetCardInfoDelegate

extension AssetCardView: AssetCardInfoDelegate {
    func assetCardInfoCell(infoView: AssetCardInfoView, didSelect index: IndexPath) {
        self.delegate?.assetCardView(assetcardView: self, didSelectedInfoCell: index)
    }
}

// MARK: - Animation

extension AssetCardView {
    private func startAnimation(selectedIndex: Int, completion: EmptyAction?) {
        isAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 0
            var count: CGFloat = CGFloat(self.cards.count - 1)
            self.cards.forEach { (card) in
                if card.tag % magicNum == selectedIndex {
                    card.transform = card.transform.translatedBy(x: 0, y: -card.upwardOffset)
                    return
                }
                
                let cardOffset = count * visibleFieldOfBottomCard
                card.transform = card.transform.translatedBy(x: 0, y: self.cardHeight - visibleFieldOfBottomCard + card.downwardOffset - cardOffset - 2 * self.bottomMarginValue)
                count -= 1
            }
            
            if self.cards.count == 2 {
                self.addCard.transform = self.addCard.transform.translatedBy(x: 0, y: self.addCard.downwardOffset + self.addCard.bounds.height)
            }
        }, completion: { _ in
            self.isAnimating = false
            completion?()
        })
    }
    
    private func resumeAnimation(completion: EmptyAction?) {
        isAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1
            var count: CGFloat = CGFloat(self.cards.count - 1)
            self.cards.forEach { (card) in
                let index = CGFloat(card.tag % magicNum)

                if card.tag % magicNum == self.selectedIndex {
                    let offset = card.frame.origin.y - (index * (self.cardHeight + self.yCardsMargin) + self.yStartPosition)
                  card.transform = card.transform.translatedBy(x: 0, y: -offset)
                    return
                }

                let offset = index * (self.cardHeight + self.yCardsMargin) + self.yStartPosition
                card.transform = card.transform.translatedBy(x: 0, y: offset - card.frame.origin.y)
                count -= 1
            }

            if self.cards.count == 2 {
                self.addCard.transform = self.addCard.transform.translatedBy(x: 0, y: 2 * (self.cardHeight + self.yCardsMargin) + self.yStartPosition - self.addCard.frame.origin.y)
            }
        }, completion: { _ in
            self.isAnimating = false
            completion?()
        })
    }
}

extension AssetCardView {
    func updateSelectedCardInfo(wallet: ViewWalletInterface) {
        cardInfoView.card.setupWith(name: wallet.name,
                                    address: wallet.address,
                                    amount: wallet.formattedBalance,
                                    balance: "≈ " + wallet.formattedBalanceInCurrentCurrencyWithSymbol,
                                    iconImage: selectedCard.bgIconview.image ?? UIImage())
        selectedCard.setupWith(name: wallet.name,
                               address: wallet.address,
                               amount: wallet.formattedBalance,
                               balance: "≈ " + wallet.formattedBalanceInCurrentCurrencyWithSymbol,
                               iconImage: selectedCard.bgIconview.image ?? UIImage())
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
        return screenHeight - frame.origin.y - bounds.height
    }
}
