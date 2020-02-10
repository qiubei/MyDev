//
//  SegmentView.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/7.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit
import SnapKit

protocol SegmentViewDelegate: class {
    /// this method will called when the selectedIndex value changed or segment item view changed.
    /// - Parameter index: current selected index.
    func segmentView(didSelect index: Int)
}

class SegmentView: UIView {
    private let magicNum = 1010
    
    let itemTitles: [String]
    
    init(frame: CGRect, itemTitles: [String]) {
        self.itemTitles = itemTitles
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: SegmentViewDelegate?
    /// selected segment item index. the default value is 0
    var selectedIndex = 0 {
        willSet {
            if newValue != selectedIndex, newValue < itemTitles.count {
                let originView = stackView.arrangedSubviews[selectedIndex] as! SegmentItem
                let destinationView = stackView.arrangedSubviews[newValue] as! SegmentItem
                originView.isSelected = false
                destinationView.isSelected = true
                
                self.delegate?.segmentView(didSelect: newValue)
            }
        }
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
    }
    
    private let selectedTipView = UIView().then {
        $0.layer.cornerRadius = 1.5
        $0.backgroundColor = App.Color.mainColor
    }
    
    private func setup() {
        addSubview(stackView)
        addSubview(selectedTipView)
        
        for (index, title) in itemTitles.enumerated() {
            let view = SegmentItem(frame: .zero)
            if index == selectedIndex {
                view.isSelected = true
            }
            view.tag = magicNum + index
            view.titleLabel.text = title
            view.bk_(whenTapped: {[weak self] in
                guard let self = self else { return }
                self.animationDidSelected(from: self.selectedIndex, to: view.tag % self.magicNum)
                self.selectedIndex = view.tag % self.magicNum
            })
            
            stackView.addArrangedSubview(view)
        }
    }
    
    private func layout() {
        guard let firstView = stackView.arrangedSubviews.first else { return }
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-6)
            $0.height.equalTo(24)
        }
        
        selectedTipView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(6)
            $0.width.equalTo(27)
            $0.height.equalTo(3)
            $0.centerX.equalTo(firstView.snp.centerX)
        }
    }

}

extension SegmentView {
    private func animationDidSelected(from: Int, to index: Int) {
        guard index < stackView.arrangedSubviews.count && from < stackView.arrangedSubviews.count else { return }
        let originV = stackView.arrangedSubviews[from] as! SegmentItem
        let destinationV = stackView.arrangedSubviews[index] as! SegmentItem
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.selectedTipView.center.x = destinationV.center.x
        }) { (flag) in
            originV.isSelected = false
            destinationV.isSelected = true
        }
    }
}
