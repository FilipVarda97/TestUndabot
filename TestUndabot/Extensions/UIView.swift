//
//  UIView.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//

import UIKit

/// Small extension for better readability.
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
