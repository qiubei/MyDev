//
//  TPPageControl.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/6.
//  Copyright © 2019 TOP. All rights reserved.
//

import UIKit

class TOPPageControl: UIPageControl {
    var currentWidth = 16
    var indicatorWidth = 8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayout()
    }
    
    override var currentPage: Int {
        didSet {
            self.updateLayout()
        }
    }
    
    private func updateLayout() {
        guard let _view = self.subviews.first else { return }
        var lastView = _view
        let leftMargin = (self.bounds.width - CGFloat((2 * self.numberOfPages) * indicatorWidth)) / 2
        for (index, view) in self.subviews.enumerated() {
            if index == 0 {
                view.snp.remakeConstraints {
                    $0.left.equalTo(leftMargin)
                    $0.centerY.equalToSuperview()
                    $0.height.equalTo(view.bounds.height)
                    if index == currentPage {
                        $0.width.equalTo(currentWidth)
                    } else {
                        $0.width.equalTo(indicatorWidth)
                    }
                }
                lastView = view
                continue
            }
            
            view.snp.remakeConstraints {
                $0.left.equalTo(lastView.snp.right).offset(6)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(view.bounds.height)
                if index == currentPage {
                    $0.width.equalTo(currentWidth)
                } else {
                    $0.width.equalTo(indicatorWidth)
                }
            }
            lastView = view
        }
    }
}
