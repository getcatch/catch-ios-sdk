//
//  CatchFont.swift
//  
//
//  Created by Lucille Benoit on 9/16/22.
//

import UIKit

enum CatchFont {
    private enum FontName: String, CaseIterable {
        case black = "CircularXXTT-Black"
        case blackItalic = "CircularXXTT-BlackItalic"
        case bold = "CircularXXTT-Bold"
        case boldItalic = "CircularXXTT-BoldItalic"
        case book = "CircularXXTT-Book"
        case bookItalic = "CircularXXTT-BookItalic"
        case extraBlack = "CircularXXTT-ExtraBlack"
        case extraBlackItalic = "CircularXXTT-ExtraBlackItalic"
        case italic = "CircularXXTT-Italic"
        case light = "CircularXXTT-Light"
        case lightItalic = "CircularXXTT-LightItalic"
        case medium = "CircularXXTT-Medium"
        case mediumItalic = "CircularXXTT-MediumItalic"
        case regular = "CircularXXTT-Regular"
        case thin = "CircularXXTT-Thin"
        case thinItalic = "CircularXXTT-ThinItalic"
    }

    static var allFontNames: [String] {
        return FontName.allCases.map { $0.rawValue }
    }
}

extension CatchFont {
    /// Circular Bold 26 point font
    static let heading1 = getCatchFont(name: FontName.bold, size: 26)

    /// Circular Bold 20 point font
    static let heading2 = getCatchFont(name: FontName.bold, size: 20)

    /// Circular Bold 16 point font
    static let heading3 = getCatchFont(name: FontName.bold, size: 16)

    /// Circular Bold 14 point font
    static let heading4 = getCatchFont(name: FontName.bold, size: 14)

    /// Circular Regular 18 point font
    static let bodyLarge = getCatchFont(name: FontName.regular, size: 18)

    /// Circular Regular 16 point font
    static let bodyRegular = getCatchFont(name: FontName.regular, size: 16)

    /// Circular Regular 14 point font
    static let bodySmall = getCatchFont(name: FontName.regular, size: 14)

    /// Circular Bold 18 point font
    static let linkLarge = getCatchFont(name: FontName.bold, size: 18)

    /// Circular Medium 16 point font
    static let linkRegular = getCatchFont(name: FontName.medium, size: 16)

    /// Circular Bold 14 point font
    static let linkSmall = getCatchFont(name: FontName.bold, size: 14)

    /// Circular Bold 18 point font
    static let buttonLabel = getCatchFont(name: FontName.bold, size: 18)

    /// Circular Bold 16 point font
    static let buttonLabelCompact = getCatchFont(name: FontName.bold, size: 16)

    /// Circular Regular 12 point font
    static let infoButton = getCatchFont(name: FontName.regular, size: 12)

    private static func getCatchFont(name: FontName, size: CGFloat) -> UIFont {
        return UIFont(name: name.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    enum Size {
        case small
        case regular
        case large
    }

    static func body(size: Size) -> UIFont {
        switch size {
        case .small:
            return bodySmall
        case .regular:
            return bodyRegular
        case .large:
            return bodyLarge
        }
    }

    static func link(size: Size) -> UIFont {
        switch size {
        case .small:
            return linkSmall
        case .regular:
            return linkRegular
        case .large:
            return linkLarge
        }
    }
}
