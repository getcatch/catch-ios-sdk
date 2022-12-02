//
//  Theme.swift
//  
//
//  Created by Lucille Benoit on 9/2/22.
//

import UIKit

public enum Theme {
    /// Intended for widgets which are displayed over a light background, and features Catch's branding color scheme.
    case lightColor
    /// Intended for widgets which are displayed over a light background and features a monochromatic scheme.
    case lightMono
    /// Intended for widgets which are displayed over a dark background, and features Catch's branding color scheme.
    case darkColor
    /// Intended for widgets which are displayed over a dark background and features a monochromatic scheme.
    case darkMono

    internal var foregroundColor: UIColor {
        switch self {
        case .lightColor, .lightMono:
            return CatchColor.black
        case .darkColor, .darkMono:
            return .white
        }
    }

    internal var borderColor: CGColor {
        return foregroundColor.withAlphaComponent(UIConstant.borderColorAlpha).cgColor
    }

    internal var accentColor: UIColor {
        switch self {
        case .lightColor:
            return CatchColor.pink2
        case .darkColor:
            return CatchColor.pink
        case .lightMono, .darkMono:
            return foregroundColor
        }
    }

    internal var secondaryAccentColor: UIColor {
        switch self {
        case .lightColor:
            return CatchColor.green2
        case .darkColor:
            return CatchColor.green
        case .lightMono, .darkMono:
            return accentColor
        }
    }

    internal var backgroundColor: UIColor {
        switch self {
        case .lightColor, .lightMono:
            return .white
        case .darkColor, .darkMono:
            return CatchColor.black
        }
    }

    internal var buttonTextColor: UIColor {
        switch self {
        case .lightColor, .lightMono, .darkColor:
            return .white
        case .darkMono:
            return CatchColor.black
        }
    }

    internal var logoImage: UIImage? {
        switch self {
        case .lightColor:
            return CatchAssetProvider.image(.logoDark)
        case .lightMono:
            return CatchAssetProvider.image(.logoMonoDark)
        case .darkColor:
            return CatchAssetProvider.image(.logoWhite)
        case .darkMono:
            return CatchAssetProvider.image(.logoMonoWhite)
        }
    }
}
