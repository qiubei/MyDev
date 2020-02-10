//
//  BaseCard.swift
//  HiWallet
//
//  Created by Anonymous on 2020/1/3.
//  Copyright © 2020 TOP. All rights reserved.
//

import UIKit


class BaseCard: UIView {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    private let gradientLayer = CAGradientLayer()
    
    /// 设置卡片的圆角和渐变色，如果 bgcolor 只有一种颜色，相当于设置背景颜色
    /// - Parameters:
    ///   - radius: 圆角弧度
    ///   - bgColors: 背景渐变色
    ///   - direction: 渐变方向
    func set(radius: CGFloat, bgColors: [CGColor] , direction: Orientation = .horizontal) {
        if bgColors.count == 1 {
            gradientLayer.backgroundColor = bgColors.first!
        }
        gradientLayer.cornerRadius = radius
        gradientLayer.colors = bgColors
        gradientLayer.locations = [0, 1]
        
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private var _offset: CGSize = .zero
    private var _effect: CGFloat = 0
    private var _color: UIColor = .white
    private var _opacity: CGFloat = 0
    
    /// 为卡片设置阴影
    /// - Parameters:
    ///   - shadowOffset: 整个阴影的偏移大小
    ///   - effect: 阴影的发散长度
    ///   - color: 阴影的颜色
    ///   - opacity: 阴影的透明度
    func set(shadowOffset: CGSize, effect: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = effect
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrame()
    }
    
    var isLayerSetup = false
    private func updateLayerFrame() {
        if isLayerSetup { return }
        isLayerSetup = true
        gradientLayer.frame = bounds
    }
}
