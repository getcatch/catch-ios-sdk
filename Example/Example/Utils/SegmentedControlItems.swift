//
//  SegmentedControlItems.swift
//  Example
//
//  Created by Lucille Benoit on 11/15/22.
//

import Catch
import Foundation

/**
Options for widget configurations including: themes, payment method variants and border styles.
Each element is an ordered dictionary mapping the segmented control title to the associated configuration object.
*/
enum SegmentedControlItems {
    // All possible themes to be displayed in the theme toggle
    static var themes: OrderedDictionary<String, Theme> {
        var dict = OrderedDictionary<String, Theme>()
        dict[Strings.lightColor] = .lightColor
        dict[Strings.lightMono] = .lightMono
        dict[Strings.darkColor] = .darkColor
        dict[Strings.darkMono] = .darkMono
        return dict
    }

    // All possible variants to be displayed in the payment method variant toggle
    static var variants: OrderedDictionary<String, PaymentMethodVariant> {
        var dict = OrderedDictionary<String, PaymentMethodVariant>()
        dict[Strings.default] = .standard
        dict[Strings.lightMono] = .compact
        dict[Strings.darkColor] = .logoCompact
        return dict
    }

    /**
    Possible border styles to be displayed in the border style toggles.
    - Parameter restricted: true for card-based widgets where only a subset of border styles is allowed.
    */
    static func borderStyles(restricted: Bool = false) -> OrderedDictionary<String, BorderStyle> {
        var dict = OrderedDictionary<String, BorderStyle>()
        dict[Strings.default] = .roundedRect
        if !restricted {
            dict[Strings.pill] = .pill
        }
        dict[Strings.square] = .square
        dict[Strings.none] = BorderStyle.none
        return dict
    }
}
