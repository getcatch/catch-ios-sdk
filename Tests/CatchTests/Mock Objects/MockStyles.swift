//
//  MockStyles.swift
//  
//
//  Created by Lucille Benoit on 12/9/22.
//

import UIKit
@testable import Catch

class MockStyles {
    // Styles for widget specific overrides
    static let overrideFont = UIFont.systemFont(ofSize: 10)
    static let overrideSpacing: CGFloat = 2
    static let overrideTextColor = UIColor.black
    static let overrideEarnColor = UIColor.red
    static let overrideRedeemColor = UIColor.green
    static let overrideBackgroundColor = UIColor.yellow

    // Styles for general CatchStyleConfig overrides
    static let generalTextColor = UIColor.white
    static let generalFont = UIFont.systemFont(ofSize: 16)
    static let generalTextTransform: TextTransform = .uppercase

    // Widget styles
    static let localCalloutOverrides = InfoWidgetStyle(widgetTextStyle: overrideTextStyles,
                                                        infoButtonStyle: overrideTextStyle)
    static let localPurchaseConfirmationOverrides = ActionWidgetStyle(widgetTextStyle: overrideTextStyles,
                                                                      actionButtonStyle: overrideButtonStyle)

    // Text styles
    static let overrideTextStyles = WidgetTextStyle(textStyle: overrideTextStyle,
                                                    benefitTextStyle: nil)

    static let generalTextStyle = TextStyle(font: generalFont,
                                            textColor: generalTextColor,
                                            textTransform: generalTextTransform,
                                            lineSpacing: nil,
                                            letterSpacing: nil)
    static let overrideTextStyle = TextStyle(font: overrideFont,
                                             textColor: overrideTextColor,
                                             textTransform: nil,
                                             lineSpacing: nil,
                                             letterSpacing: overrideSpacing)
    static let overrideBenefitStyle = BenefitTextStyle(earnTextColor: overrideEarnColor,
                                                       redeemTextColor: overrideRedeemColor,
                                                       font: overrideFont)

    // Button Styles
    static let overrideButtonStyle = ActionButtonStyle(textStyle: overrideTextStyle,
                                                       backgroundColor: overrideBackgroundColor,
                                                       cornerRadius: nil)

    // Catch Style Config
    static let testCatchStyleConfig = CatchStyleConfig(textStyle: generalTextStyle,
                                                       calloutStyle: localCalloutOverrides)
}
