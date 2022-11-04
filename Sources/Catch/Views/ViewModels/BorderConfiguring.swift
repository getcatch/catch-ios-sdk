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
            layer.borderColor = theme.borderColor
            layer.cornerRadius = cornerRadius
        } else {
            layer.borderWidth = 0
        }
    }
}
