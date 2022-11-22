//
//  UIView+Extension.swift
//  
//
//  Created by Lucille Benoit on 11/9/22.
//

import UIKit

extension UIView {
    /**
     Adds a rasterized border shadow to the view with the given parameters.
     */
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    /**
     Sets the view's layout priorities to prioritize expanding to fill available space.
     */
    func setExpandingLayoutPriorities() {
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
