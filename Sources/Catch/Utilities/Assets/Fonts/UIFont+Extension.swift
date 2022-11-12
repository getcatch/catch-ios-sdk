//
//  UIFont+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import UIKit

extension UIFont {

    // Converts font weight scale to positive values
    var absoluteWeightValue: CGFloat {
        return weight.rawValue + 1
    }

    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }

    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
}
