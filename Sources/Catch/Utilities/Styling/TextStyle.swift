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
    internal var isUnderlined: Bool?

    /// Initializes a TextStyle configuration.
    public init(font: UIFont? = nil,
                textColor: UIColor? = nil,
                textTransform: TextTransform? = nil,
                lineSpacing: CGFloat? = nil,
                letterSpacing: CGFloat? = nil) {
        self.init(font: font,
                  textColor: textColor,
                  textTransform: textTransform,
                  lineSpacing: lineSpacing,
                  letterSpacing: letterSpacing,
                  isUnderlined: nil)
    }

    internal init(font: UIFont? = nil,
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

    /**
     Scales the font size for the attributed string.
     */
    internal func withScaledFont(multiplier: Double) -> TextStyle? {
        guard let font = font else { return nil }
        let scaledPointSize = font.pointSize * multiplier
        let scaledFont = font.withSize(scaledPointSize)
        var style = self
        style.font = scaledFont
        return style
    }

    internal static func resolved(_ textStyle: TextStyle?,
                                  withOverrides overrides: TextStyle?) -> TextStyle? {
        TextStyle(font: overrides?.font ?? textStyle?.font,
                  textColor: overrides?.textColor ?? textStyle?.textColor,
                  textTransform: overrides?.textTransform ?? textStyle?.textTransform,
                  lineSpacing: overrides?.lineSpacing ?? textStyle?.lineSpacing,
                  letterSpacing: overrides?.letterSpacing ?? textStyle?.letterSpacing,
                  isUnderlined: overrides?.isUnderlined ?? textStyle?.isUnderlined)

    }
}
