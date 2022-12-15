//
//  UIConstant.swift
//  Catch
//
//  Created by Lucille Benoit on 9/7/22.
//

import UIKit

enum UIConstant {
    /// 2 point spacing
    static let microSpacing: CGFloat = 2

    /// 3 point spacing
    static let extraSmallSpacing: CGFloat = 3

    /// 4 point spacing
    static let smallSpacing: CGFloat = 4

    /// 6 point spacing
    static let smallMediumSpacing: CGFloat = 6

    /// 8 point spacing
    static let mediumSpacing: CGFloat = 8

    /// 16 point spacing
    static let largeSpacing: CGFloat = 16

    /// 24 point spacing
    static let extraLargeSpacing: CGFloat = 24

    /// 4 point default text line spacing
    static let defaultLineSpacing: CGFloat = 4

    /// 24 point larger text line height
    static let largeLineHeight: CGFloat = 24

    /// 4 point default corner radius for borders
    static let defaultCornerRadius: CGFloat = 4

    /// 5 point large corner radius for borders
    static let largeCornerRadius: CGFloat = 5

    /// 1 point default width for borders
    static let defaultBorderWidth: CGFloat = 1

    /// Merchant Card width multiplier
    static let merchantCardWidthMultiplier: CGFloat = 14

    /// Merchant Card aspect ratio
    static let merchantCardAspectRatio: CGFloat = 0.62

    /// Merchant Card shadow offset
    static let merchantCardShadowOffset = CGSize(width: 2.0, height: 2.0)

    /// The radius for the merchant card shadow
    static let merchantCardShadowRadius: CGFloat = 4

    /// The opacity for the merchant card shadow
    static let merchantCardShadowOpacity: Float = 0.2

    /// Merchant Logo width multiplier
    static let merchantLogoWidthMultiplier: CGFloat = 10

    // Merchant Logo aspect ratio
    static let merchantLogoAspectRatio: CGFloat = 0.25

    // Maximum width for external link button
    static let maxExternalLinkButtonWidth: CGFloat = 479

    // Border color alpha
    static let borderColorAlpha: CGFloat = 0.16

    // Disabled transparency alpha
    static let disabledAlpha: CGFloat = 0.48

    // Large logo height
    static let largeLogoHeight: CGFloat = 28

    // Minimum view height for large corner radius
    static let minViewHeightForLargeElement: CGFloat = 200

    // Unicode string for en dash (double dash)
    static let enDash: String = "\u{2013}"

    // Background color for modal views
    static let modalBackgroundColor = UIColor.black.withAlphaComponent(0.2)

    // Modal animation duration
    static let modalAnimationDuration: TimeInterval = 0.3

    // Max tooltip width of 320
    static let maxTooltipWidth: CGFloat = 320
}
