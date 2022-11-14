//
//  NSAttributedStringStyle.swift
//  
//
//  Created by Lucille Benoit on 10/12/22.
//

import UIKit

struct NSAttributedStringStyle {
    var font: UIFont = CatchFont.bodySmall
    var textColor: UIColor = Theme.lightColor.foregroundColor
    var backgroundColor: UIColor = Theme.lightColor.backgroundColor
    var textTransform: TextTransform = .none
    var lineSpacing: CGFloat = UIConstant.defaultLineSpacing
    var isTappable: Bool = false

    static var `default`: NSAttributedStringStyle {
        return NSAttributedStringStyle()
    }

    static func infoButtonStyle(theme: Theme) -> NSAttributedStringStyle {
        return NSAttributedStringStyle(font: CatchFont.infoButton,
                                            textColor: theme.foregroundColor,
                                            lineSpacing: 0)
    }
}
