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
    static let secondaryBackgroundColor: UIColor? = UIColor(named: "SecondaryBackgroundColor")
    static let catchGreen: UIColor? = UIColor(named: "CatchGreen")

    // Price Slider
    static let minPriceValue: Float = 0
    static let maxPriceValue: Float = 500
    static let priceSliderHeight: CGFloat = 30

    // Demo App
    static let headerHeight: CGFloat = 60
    static let defaultMargin: CGFloat = 12
    static let demoStackSpacing: CGFloat = 48
    static let configurationViewSpacing: CGFloat = 24

    // Fonts
    static let bodyFont = UIFont.systemFont(ofSize: 12)
    static let bodySmallFont = UIFont.systemFont(ofSize: 10)

    // Purchase Confirmation Demo
    static let initialEarnedAmount = 1000
}
