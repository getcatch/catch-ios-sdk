//
//  BorderConfiguring.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import UIKit

protocol BorderConfiguring: UIView {
    var borderStyle: BorderStyle { get set }
}

extension BorderConfiguring {
    func configureBorder(viewHeight: CGFloat, theme: Theme) {
        if let cornerRadius = borderStyle.cornerRadius(for: viewHeight) {
            layer.borderWidth = UIConstant.defaultBorderWidth
            layer.cornerRadius = cornerRadius
            setBorderColor(for: theme)
        } else {
            layer.borderWidth = 0
        }
    }

    private func setBorderColor(for theme: Theme) {
        var borderColor = theme.borderColor
        // If custom border color was passed in, override theme border color.
        if case let .custom(_, color) = borderStyle, let color = color {
            borderColor = color.cgColor
        }
        // Set layer's border color
        layer.borderColor = borderColor
    }
}
