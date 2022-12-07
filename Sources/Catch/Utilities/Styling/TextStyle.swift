//
//  TextStyle.swift
//  
//
//  Created by Lucille Benoit on 10/12/22.
//

import UIKit

/**
 Styling for general text components within the Catch widgets.
 */
public struct TextStyle {
    /// Configures the font for text components. The font for the benefit text can be set separately.
    var font: UIFont = CatchFont.bodySmall

    /// Configures the text color for text components. The text color for the benefit text can be set separately.
    var textColor: UIColor = Theme.lightColor.foregroundColor

    /// Transforms the text string to the uppercased, lowercased or capitalized form of the string.
    var textTransform: TextTransform = .none

    /// Configures the line spacing for text components.
    var lineSpacing: CGFloat = UIConstant.defaultLineSpacing

    /// Configures the letter spacing for text components.
    var letterSpacing: CGFloat = 0

    /// Configures the text to appear underlined.
    var isUnderlined: Bool = false

    static var `default`: TextStyle {
        return TextStyle()
    }

    internal static func infoButtonStyle(theme: Theme) -> TextStyle {
        return TextStyle(font: CatchFont.infoButton,
                         textColor: theme.foregroundColor,
                         lineSpacing: 0)
    }

    /**
     Scales the font size for the attributed string.
     */
    internal func withScaledFont(multiplier: Double) -> TextStyle {
        let scaledPointSize = font.pointSize * multiplier
        let scaledFont = font.withSize(scaledPointSize)
        var style = self
        style.font = scaledFont
        return style
    }
}
