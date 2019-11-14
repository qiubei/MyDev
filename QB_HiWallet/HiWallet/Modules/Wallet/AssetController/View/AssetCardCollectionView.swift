//
//  AssetCardCollectionView.swift
//  HiWallet
//
//  Created by Anonymous on 2019/8/30.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit
import TOPCore
import BlocksKit

class AssetCardCollectionView: UIView {
    
    var _walletList:[ViewWalletInterface] = []
    var walletList: [ViewWalletInterface] {
        set {
            _walletList = newValue
            pageControl.numberOfPages = newValue.count > 1 ? newValue.count : 0

            // update UI colors with coin
            if let first = walletList.first {
                let coin = MainCoin.getTypeWithSymbol(symbol: first.chainSymbol)
                pageControl.currentPageIndicatorTintColor = UIColor.init(cgColor: coin.getColors().first!)
                cellColors = coin.getColors()
            }
            collectionview.reloadData()
        }
        get {
            return _walletList
        }
    }
    weak var uiService: AssertCardCollectionActionService!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.layout()
    }
    
    // collectionview
    private let ratio: CGFloat = App.assetCardRatio
    private let itemWidth = (UIScreen.main.bounds.width - 64)
    private var collectionview: UICollectionView!
    private var pageControl = TOPPageControl()
    private func setup() {
        let layout = AssetCardFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth) / ratio)
        
        self.collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        collectionview.setContentOffset(CGPoint(x: 32, y: 0), animated: false)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .white
        collectionview.isScrollEnabled = true
        collectionview.register(UINib(nibName: "AssetAccountCardXIB", bundle: Bundle.main), forCellWithReuseIdentifier: "AssetAccountCardID")
        
        pageControl.numberOfPages = self.walletList.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        
        self.addSubview(collectionview)
        self.addSubview(pageControl)
        
        self.collectionview.panGestureRecognizer.addTarget(self, action: #selector(self.scrollviewPanGestureAction(_:)))
    }
    
    private func layout() {
        collectionview.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(-5)
            $0.height.equalTo(itemWidth / ratio + 30)
        }
        
        pageControl.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(10)
            $0.bottom.equalTo(-10)
            $0.centerX.equalToSuperview()
        }
    }
    
    var currentIndex: CGFloat = 0
    private var cellColors: [CGColor] = []
    
    
    ///  选中哪一行
    ///
    /// - Parameters:
    ///   - cardIndex: cell 的 index，默认 0 开始
    ///   - animated: 是否动画
    func selectCard(index: Int, animated: Bool) {
        let offsetX = CGFloat(index) * itemWidth - 32
        let offset = CGPoint(x: offsetX, y: 0)
        collectionview.setContentOffset(offset, animated: animated)
        self.currentIndex = CGFloat(index)
        
        if self.pageControl.currentPage != Int(self.currentIndex) {
            if uiService == nil { return }
            self.uiService.collectionViewDidSelected(indexPath: IndexPath(row: Int(self.currentIndex), section: 0))
        }
        self.pageControl.currentPage = Int(self.currentIndex)
    }
}


//MARK: - collectionview
extension AssetCardCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.walletList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetAccountCardID", for: indexPath) as! AssetCardCollectionCell
        
        self.setupCellAction(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func setupCellAction(cell: AssetCardCollectionCell, indexPath: IndexPath) {
        cell.colors = cellColors
        cell.setupWith(wallet: self.walletList[indexPath.row], index: indexPath.row)
        if uiService == nil { return }
        cell.managerButton.bk_(whenTapped: {
            self.uiService.assetCardManagerAction(indexPath: indexPath)
        })
        cell.addressLabel.isUserInteractionEnabled = true
        
        cell.addressLabel.gestureRecognizers?.removeAll()
        cell.addressLabel.bk_(whenTapped: {
            self.uiService.assetCardCopyAction(indexPath: indexPath,
                                               selectedString: self.walletList[indexPath.row].address)
        })
        
        cell.copyButton.gestureRecognizers?.removeAll()
        cell.copyButton.bk_(whenTapped: {
            self.uiService.assetCardCopyAction(indexPath: indexPath,
                                               selectedString: self.walletList[indexPath.row].address)
        })
        
        cell.sendButton.gestureRecognizers?.removeAll()
        cell.sendButton.bk_(whenTapped: {
            self.uiService.assetCardSendAction(indexPath: indexPath)
        })

        cell.receiveButton.gestureRecognizers?.removeAll()
        cell.receiveButton.bk_(whenTapped: {
            self.uiService.assetCardReceiveAction(indexPath: indexPath)
        })
    }
}

//MARK: - paging
extension AssetCardCollectionView {
    @objc
    private func scrollviewPanGestureAction(_ gesture: UIPanGestureRecognizer) {
        let vectory = gesture.velocity(in: self.collectionview)

        if gesture.state == .ended {
            var index = (self.collectionview.contentOffset.x / itemWidth * 1.0).rounded()
            if Float(vectory.x) < -800 {
                index = (self.currentIndex + 1) >= CGFloat(self.walletList.count) ? CGFloat(self.walletList.count - 1) : (self.currentIndex + 1)
            }
            if Float(vectory.x) > 800 {
                index = (self.currentIndex - 1) <= 0 ? 0 : (self.currentIndex - 1)
            }
           DLog("\(collectionview.contentOffset.x) index is \(index)")
            self.selectCard(index: Int(index), animated: true)
        }
    }
}
