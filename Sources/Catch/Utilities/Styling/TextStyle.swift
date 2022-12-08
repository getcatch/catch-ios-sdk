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
    var font: UIFont?

    /// Configures the text color for text components. The text color for the benefit text can be set separately.
    var textColor: UIColor?

    /// Transforms the text string to the uppercased, lowercased or capitalized form of the string.
    var textTransform: TextTransform?

    /// Configures the line spacing for text components.
    var lineSpacing: CGFloat?

    /// Configures the letter spacing for text components.
    var letterSpacing: CGFloat?

    /// Configures the text to appear underlined.
    var isUnderlined: Bool?

    static var `default`: TextStyle {
        return TextStyle()
    }

    /// Initializes a TextStyle configuration.
    public init(font: UIFont? = nil,
                textColor: UIColor? = nil,
                textTransform: TextTransform? = nil,
                lineSpacing: CGFloat? = nil,
                letterSpacing: CGFloat? = nil,
                isUnderlined: Bool? = nil) {
        self.font = font
        self.textColor = textColor
        self.textTransform = textTransform
        self.lineSpacing = lineSpacing
        self.letterSpacing = letterSpacing
        self.isUnderlined = isUnderlined
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
        guard let font = font else { return self }
        let scaledPointSize = font.pointSize * multiplier
        let scaledFont = font.withSize(scaledPointSize)
        var style = self
        style.font = scaledFont
        return style
    }
}
