//
//  ActionWidgetStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

protocol WidgetStyle {
    var widgetTextStyle: WidgetTextStyle? { get set }
}

/**
 Styling for Catch widgets which contain an action button.
 This includes the following widgets:
 - Purchase Confirmation
 - Campaign Link
 */
public struct ActionWidgetStyle: WidgetStyle {
    /// Configures the styling of text components within the widget.
    var widgetTextStyle: WidgetTextStyle?

    /// Configures the styling of the action button within the widget.
    var actionButtonStyle: ActionButtonStyle?

    /// Initializes an ActionWidgetStyle configuration.
    public init(widgetTextStyle: WidgetTextStyle? = nil, actionButtonStyle: ActionButtonStyle? = nil) {
        self.widgetTextStyle = widgetTextStyle
        self.actionButtonStyle = actionButtonStyle
    }

    internal static func resolved(_ style: ActionWidgetStyle?,
                                  withOverrides overrides: ActionWidgetStyle?) -> ActionWidgetStyle? {
        ActionWidgetStyle(widgetTextStyle: WidgetTextStyle.resolved(style?.widgetTextStyle,
                                                                    withOverrides: overrides?.widgetTextStyle),
                          actionButtonStyle: ActionButtonStyle.resolved(style?.actionButtonStyle,
                                                                        withOverrides: overrides?.actionButtonStyle))

    }

    internal static func defaults(theme: Theme?) -> ActionWidgetStyle? {
        return theme?.actionWidgetStyle
    }
}
