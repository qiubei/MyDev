//
//  AssetCardFlowLayout.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/2.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class AssetCardFlowLayout: UICollectionViewFlowLayout {
    
//    var pageSize = CGSize(width: 100, height: 100)
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepare() {
        super.prepare()
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let elements = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        guard let collectionV = self.collectionView else {
            return nil
        }
        let centerX = collectionV.contentOffset.x + collectionV.bounds.width * 0.5
        for element in elements {
            let delta = abs(element.center.x - centerX)
            let scale = 1.0 / (1 + delta * 0.0004)
            element.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        
        return elements
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var rect = CGRect.zero
        rect.origin.y = 0
        rect.origin.x = proposedContentOffset.x
        rect.size = self.collectionView!.frame.size
        
        let elements = super.layoutAttributesForElements(in: rect)!
        let centerX = proposedContentOffset.x + collectionView!.bounds.width * 0.5
        var minDelta = CGFloat(MAXFLOAT)
        for element in elements {
            if abs(minDelta) > abs(element.center.x - centerX) {
                minDelta = element.center.x - centerX
            }
        }
        let x = proposedContentOffset.x + minDelta
        let y = proposedContentOffset.y
        return CGPoint(x: x, y: y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
