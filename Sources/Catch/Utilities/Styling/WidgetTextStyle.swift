//
//  WidgetTextStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

/**
 The text style set for Catch widgets. This includes the general text styling (see ``TextStyle``)
 as well as configurations specific to the benefit text components (see ``BenefitTextStyle``)
 */
public struct WidgetTextStyle {
    /// Configures text attributes for all elements within a Catch widget
    var textStyle: TextStyle?

    /// Configures the colors and font specifically for the benefit text (ex. "Earn x% credit")
    /// All other text attributes will be inherited from the textStyle.
    var benefitTextStyle: BenefitTextStyle?
}
