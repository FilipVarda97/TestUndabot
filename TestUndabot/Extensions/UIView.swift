//
//  UIView.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIView {
    enum Direction {
        case topToBottom
        case leftToRight
        case topLeftToBottomRight
        case bottomLeftToTopRight
    }
    
    
    func addGradientWithColors(colors: [UIColor], alpha: Float = 1, direction: Direction = .topToBottom) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let cgColors = colors.compactMap {
            return $0.cgColor
        }
        gradient.colors = cgColors
        layer.opacity = alpha
        switch direction {
        case .topToBottom:
            break
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        case .topLeftToBottomRight:
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        case .bottomLeftToTopRight:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        self.layer.sublayers?.removeAll()
        self.layer.insertSublayer(gradient, at: 0)
    }
}
