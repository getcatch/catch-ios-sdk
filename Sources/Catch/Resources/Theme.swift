//
//  Theme.swift
//  
//
//  Created by Lucille Benoit on 9/2/22.
//

import UIKit

public enum Theme {
    case lightColor
    case lightMono
    case darkColor
    case darkMono

    var foregroundColor: UIColor? {
        switch self {
        case .lightColor, .lightMono:
            return CatchAssetProvider.color(.catchBlack)
        case .darkColor, .darkMono:
            return .white
        }
    }

    var accentColor: UIColor? {
        switch self {
        case .lightColor, .darkColor:
            return CatchAssetProvider.color(.catchPink)
        case .lightMono:
            return CatchAssetProvider.color(.catchBlack)
        case .darkMono:
            return .white
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .lightColor, .lightMono, .darkColor:
            return .white
        case .darkMono:
            return CatchAssetProvider.color(.catchBlack)
        }
    }

    var logoImage: UIImage? {
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
