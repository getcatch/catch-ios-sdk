//
//  ActionWidgetStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

protocol WidgetStyle {
    var widgetTextStyle: WidgetTextStyle? { get set }
    var type: WidgetStyleType { get }
}

enum WidgetStyleType {
    case actionWidget
    case labelWidget
}

/**
 Styling for Catch widgets which contain an action button.

 This includes the following widgets:
 - ``PurchaseConfirmation``
 - ``CampaignLink``
 */
public struct ActionWidgetStyle: WidgetStyle {
    internal var type: WidgetStyleType = .actionWidget

    /// Configures the styling of text components within the widget.
    var widgetTextStyle: WidgetTextStyle?

    /// Configures the styling of the action button within the widget.
    var actionButtonStyle: ActionButtonStyle?

    /**
     Initializes an ``ActionWidgetStyle`` configuration.
     - Parameter widgetTextStyle: the styling of text components within the widget (see ``WidgetTextStyle``).
     - Parameter actionButtonStyle: the styling of the action button within the widget (see ``ActionButtonStyle``).
     */
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
