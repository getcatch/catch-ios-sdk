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
 - Callout
 - Express Checkout Callout
 - Payment Method
 */
public struct InfoWidgetStyle: WidgetStyle {
    internal var type: WidgetStyleType = .labelWidget

    /// Configures the styling of text components within the widget.
    var widgetTextStyle: WidgetTextStyle?

    /// Configures the styling of the info button within the widget.
    var infoButtonStyle: TextStyle?

    /// Initializes a InfoWidgetStyle configuration.
    public init(widgetTextStyle: WidgetTextStyle? = nil, infoButtonStyle: TextStyle? = nil) {
        self.widgetTextStyle = widgetTextStyle
        self.infoButtonStyle = infoButtonStyle
    }

    internal static func resolved(_ style: InfoWidgetStyle?,
                                  withOverrides overrides: InfoWidgetStyle?) -> InfoWidgetStyle? {
        return InfoWidgetStyle(widgetTextStyle: WidgetTextStyle.resolved(style?.widgetTextStyle,
                                                                          withOverrides: overrides?.widgetTextStyle),
                                infoButtonStyle: TextStyle.resolved(style?.infoButtonStyle,
                                                                    withOverrides: overrides?.infoButtonStyle))
    }

    internal static func defaults(theme: Theme?, widgetType: StyleResolver.WidgetType) -> InfoWidgetStyle? {
        let size: CatchFont.Size = widgetType == .expressCheckoutCallout ? .regular : .small
        return theme?.infoWidgetStyle(textSize: size)
    }
}
