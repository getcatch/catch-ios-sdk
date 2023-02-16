//
//  ActionWidgetStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

protocol WidgetStyle {
    var textStyle: TextStyle? { get set }
    var benefitTextStyle: BenefitTextStyle? { get set }
    var type: WidgetStyleType { get }
}

extension WidgetStyle {
    func earnRedeemLabelStyle() -> EarnRedeemLabelStyle {
        return EarnRedeemLabelStyle(textStyle: textStyle, benefitTextStyle: benefitTextStyle)
    }
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

    /// Configures text attributes for all elements within a Catch widget
    var textStyle: TextStyle?

    /// Configures the colors and font specifically for the benefit text (ex. "Earn x% credit")
    /// All other text attributes will be inherited from the textStyle.
    var benefitTextStyle: BenefitTextStyle?

    /// Configures the styling of the action button within the widget.
    var actionButtonStyle: ActionButtonStyle?

    /**
     Initializes an ``ActionWidgetStyle`` configuration.
     - Parameter textStyle: the styling of text components within the widget (see ``TextStyle``).
     - Parameter benefitTextStyle: the styling for the benefit text within Catch widgets. ( see ``BenefitTextStyle``).
     - Parameter actionButtonStyle: the styling of the action button within the widget (see ``ActionButtonStyle``).
     */
    public init(textStyle: TextStyle? = nil,
                benefitTextStyle: BenefitTextStyle? = nil,
                actionButtonStyle: ActionButtonStyle? = nil) {
        self.textStyle = textStyle
        self.benefitTextStyle = benefitTextStyle
        self.actionButtonStyle = actionButtonStyle
    }

    internal static func resolved(_ style: ActionWidgetStyle?,
                                  withOverrides overrides: ActionWidgetStyle?) -> ActionWidgetStyle? {
        ActionWidgetStyle(textStyle: TextStyle.resolved(style?.textStyle,
                                                        withOverrides: overrides?.textStyle),
                          benefitTextStyle: BenefitTextStyle.resolved(style?.benefitTextStyle,
                                                                      withOverrides: overrides?.benefitTextStyle),
                          actionButtonStyle: ActionButtonStyle.resolved(style?.actionButtonStyle,
                                                                        withOverrides: overrides?.actionButtonStyle))

    }

    internal static func defaults(theme: Theme?) -> ActionWidgetStyle? {
        return theme?.actionWidgetStyle
    }
}
