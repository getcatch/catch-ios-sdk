//
//  WidgetTextStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import UIKit

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

    /// Initializes a WidgetTextStyle configuration.
    public init(textStyle: TextStyle? = nil, benefitTextStyle: BenefitTextStyle? = nil) {
        self.textStyle = textStyle
        self.benefitTextStyle = benefitTextStyle
    }

    /// The calculated earn message text style.
    internal func earnTextStyle(isUnderlined: Bool) -> TextStyle? {
        calculateBenefitTextStyle(color: benefitTextStyle?.earnTextColor, isUnderlined: isUnderlined)
    }

    /// The calculated redeem message text style.
    internal var redeemTextStyle: TextStyle? {
        calculateBenefitTextStyle(color: benefitTextStyle?.redeemTextColor, isUnderlined: true)
    }

    /// Calculates the text style for the benefit text.
    private func calculateBenefitTextStyle(color: UIColor?, isUnderlined: Bool) -> TextStyle? {
        if var benefitStyle = textStyle {
            if let color = color {
                benefitStyle.textColor = color
            }
            if let font =  benefitTextStyle?.font {
                benefitStyle.font = font
            }
            benefitStyle.isUnderlined = isUnderlined
            return benefitStyle
        }
        return nil
    }
}
