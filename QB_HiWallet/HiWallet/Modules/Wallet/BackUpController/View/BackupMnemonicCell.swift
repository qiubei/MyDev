//
//  BackupMnemonicCell.swift
//  HiWallet
//
//  Created by Anonymous on 2019/9/9.
//  Copyright © 2019 TOP. All rights reserved.
//

import SnapKit
import Then
import UIKit

enum MnenomicCellState: String {
    case none
    case normal
    case choosed
}

class BackupMnemonicCell: UICollectionViewCell {
    var cellState = MnenomicCellState.none {
        didSet {
            switch cellState {
            case .none:
                leftTopBGColor = .clear
                setNeedsDisplay()
                numberLabel.isHidden = true
            case .normal:
                leftTopBGColor = App.Color.mainColor
                setNeedsDisplay()
                numberLabel.isHidden = false
            case .choosed:
                leftTopBGColor = App.Color.mainColor
                setNeedsDisplay()
                numberLabel.isHidden = false
            }
        }
    }

    var numberLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: "DIN Alternate", size: 11)
        $0.textAlignment = .center
        $0.isHidden = true
    }

    var textLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.adjustsFontSizeToFitWidth = true
    }

    private var leftTopBGColor = UIColor.red
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        layout()
    }

    private func setup() {
        addSubview(numberLabel)
        addSubview(textLabel)
        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        cornerRadius = 6
    }

    private func layout() {
        numberLabel.snp.makeConstraints { 
            $0.top.equalTo(1)
            $0.left.equalTo(0)
            $0.height.equalTo(14)
            $0.width.equalTo(16)
        }

        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(20)
            $0.left.right.equalToSuperview()
        }
    }

    // add left top bg color
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        leftTopBGColor.setFill()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 26))
        path.addLine(to: CGPoint(x: 26, y: 0))
        path.close()
        path.fill()
    }
}
