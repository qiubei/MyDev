//
//  BannerView.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/21.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit

protocol BannerViewDelegate {
    func bannerView(didSelect index: Int)
}

class BannerView: UIView {
    var images: [UIImage] = [] {
        didSet {
            updateScrollable()
        }
    }
    
    let cellLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: screenWidth - 32, height: (screenWidth - 32) / 343 * 144)
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.scrollDirection = .horizontal
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.cellLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    let pageControl = TOPPageControl().then {
        $0.pageIndicatorTintColor = .green
        $0.currentPageIndicatorTintColor = .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateScrollable() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.snp.remakeConstraints {
            $0.height.equalTo(6)
            $0.right.equalTo(-16)
            $0.width.equalTo((images.count - 1) * 12 + 10)
            $0.bottom.equalTo(-16)
        }
        
        let indexPath = IndexPath(row: images.count * 500, section: 0)
        collectionView.reloadData()
        
        collectionView.contentOffset = CGPoint(x: CGFloat (500 * images.count) * collectionView.width, y: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    private let cellId = "collection_cell_banner"
    private var imageviews: [UIImageView] = []
    private func setup() {
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.random()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        pageControl.currentWidth = 10
        pageControl.indicatorWidth = 6
    }
    
    private func layout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}

extension BannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        self.pageControl.currentPage = index
    }
}

extension BannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count * 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row % images.count
        pageControl.currentPage = index
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! BannerCell
        cell.imageview.image = images[index]
        return cell
    }
}
