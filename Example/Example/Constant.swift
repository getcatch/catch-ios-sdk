//
//  Constant.swift
//  Example
//
//  Created by Lucille Benoit on 9/10/22.
//

import UIKit

enum Constant {
    // SDK Configuration
    static let publicKey = "Ei6eCMabeqZT3AuiFcX3XuUC"

    // Colors
    static let headerColor: UIColor? = UIColor(named: "HeadingColor")
    static let backgroundColor: UIColor? = UIColor(named: "BackgroundColor")
    static let catchGreen: UIColor? = UIColor(named: "CatchGreen")

    // Price Slider
    static let minPriceValue: Float = 0
    static let maxPriceValue: Float = 500
    static let priceSliderHeight: CGFloat = 30
    static let sliderLabelFormat: String = "Price: $%d"

    // Demo App
    static let headerHeight: CGFloat = 60
    static let defaultMargin: CGFloat = 12
    static let demoStackSpacing: CGFloat = 48

    // Fonts
    static let bodyFont = UIFont.systemFont(ofSize: 12)
}
