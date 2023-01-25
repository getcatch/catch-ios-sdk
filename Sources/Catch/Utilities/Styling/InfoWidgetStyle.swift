//
//  InfoWidgetStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

/**
 Styling for Catch widgets which contain a benefit text label and info button.

 This includes the following widgets:
 - ``Callout``
 - ``ExpressCheckoutCallout``
 - ``PaymentMethod``
 */
public struct InfoWidgetStyle: WidgetStyle {
    internal var type: WidgetStyleType = .labelWidget

    /// Configures text attributes for all elements within a Catch widget
    var textStyle: TextStyle?

    /// Configures the colors and font specifically for the benefit text (ex. "Earn x% credit")
    /// All other text attributes will be inherited from the textStyle.
    var benefitTextStyle: BenefitTextStyle?

    /// Configures the styling of the info button within the widget.
    var infoButtonStyle: TextStyle?

    /**
     Initializes a ``InfoWidgetStyle`` configuration.
     - Parameter textStyle: the styling of text components within the widget (see ``TextStyle``).
     - Parameter benefitTextStyle: the styling for the benefit text within Catch widgets. ( see ``BenefitTextStyle``).
     - Parameter infoButtonStyle: the styling of the info button within the widget.
     */
    public init(textStyle: TextStyle? = nil, benefitTextStyle: BenefitTextStyle? = nil, infoButtonStyle: TextStyle? = nil) {
        self.textStyle = textStyle
        self.benefitTextStyle = benefitTextStyle
        self.infoButtonStyle = infoButtonStyle
    }

    internal static func resolved(_ style: InfoWidgetStyle?,
                                  withOverrides overrides: InfoWidgetStyle?) -> InfoWidgetStyle? {
        return InfoWidgetStyle(textStyle: TextStyle.resolved(style?.textStyle,
                                                             withOverrides: overrides?.textStyle),
                               benefitTextStyle: BenefitTextStyle.resolved(style?.benefitTextStyle,
                                                                           withOverrides: overrides?.benefitTextStyle),
                               infoButtonStyle: TextStyle.resolved(style?.infoButtonStyle,
                                                                   withOverrides: overrides?.infoButtonStyle))
    }

    internal static func defaults(theme: Theme?, widgetType: StyleResolver.WidgetType) -> InfoWidgetStyle? {
        let size: CatchFont.Size = widgetType == .expressCheckoutCallout ? .regular : .small
        return theme?.infoWidgetStyle(textSize: size)
    }
}
