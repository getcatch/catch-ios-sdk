//
//  CatchStyleConfig.swift
//  
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation
import UIKit

/**
 The global styles that can be used to customize components within Catch widgets.
 Any configurations set locally will override the global configurations.
 */
public struct CatchStyleConfig {

    /// Configures the styling for text components across all widgets
    var textStyle: TextStyle?

    /// Configures the styling for benefit text components across all widgets
    var benefitTextStyle: BenefitTextStyle?

    /// Configures the styling for all info buttons across all widgets which contain them
    var infoButtonStyle: TextStyle?

    /// Configures the styling for all action buttons across all widgets which contain them
    var actionButtonStyle: ActionButtonStyle?

    /// Configures the styling for all callout widgets
    var calloutStyle: LabelWidgetStyle?

    /// Configures the styling for all express checkout callout widgets
    var expressCheckoutCalloutStyle: LabelWidgetStyle?

    /// Configures the styling for all payment method widgets
    var paymentMethodStyle: LabelWidgetStyle?

    /// Configures the styling for all purchase confirmation widgets
    var purchaseConfirmationStyle: ActionWidgetStyle?

    /// Configures the styling for all campaign link widgets
    var campaignLinkStyle: ActionWidgetStyle?

    internal var widgetTextStyles: WidgetTextStyle {
        return WidgetTextStyle(textStyle: textStyle, benefitTextStyle: benefitTextStyle)
    }

    internal func resolvedLabelWidgetStyle(for widgetType: StyleResolver.WidgetType) -> LabelWidgetStyle? {
        guard let labelWidgetStyle = styleConfigForWidgetType(widgetType) as? LabelWidgetStyle else { return nil }
        let infoButtonConfig = TextStyle.resolved(infoButtonStyle, withOverrides: labelWidgetStyle.infoButtonStyle)
        return LabelWidgetStyle(widgetTextStyle: resolvedTextStyles(for: widgetType), infoButtonStyle: infoButtonConfig)
    }

    internal func resolvedActionWidgetStyle(for widgetType: StyleResolver.WidgetType) -> ActionWidgetStyle? {
        guard let actionWidgetStyle = styleConfigForWidgetType(widgetType) as? ActionWidgetStyle else { return nil }
        let actionButtonConfig = ActionButtonStyle.resolved(actionButtonStyle,
                                                            withOverrides: actionWidgetStyle.actionButtonStyle)
        return ActionWidgetStyle(widgetTextStyle: resolvedTextStyles(for: widgetType),
                                 actionButtonStyle: actionButtonConfig)
    }

    internal static func defaults(theme: Theme?) -> CatchStyleConfig {
        return CatchStyleConfig(textStyle: theme?.textStyle(size: .small),
                                benefitTextStyle: theme?.benefitTextStyle(size: .small),
                                infoButtonStyle: theme?.infoButtonStyle,
                                actionButtonStyle: theme?.actionButtonStyle,
                                calloutStyle: theme?.labelWidgetStyle(textSize: .small),
                                expressCheckoutCalloutStyle: theme?.labelWidgetStyle(textSize: .regular),
                                paymentMethodStyle: theme?.labelWidgetStyle(textSize: .small),
                                purchaseConfirmationStyle: theme?.actionWidgetStyle,
                                campaignLinkStyle: theme?.actionWidgetStyle)
    }

    private func resolvedTextStyles(for widgetType: StyleResolver.WidgetType) -> WidgetTextStyle {
        let globalWidgetOverrides = styleConfigForWidgetType(widgetType)
        return WidgetTextStyle.resolved(widgetTextStyles,
                                        withOverrides: globalWidgetOverrides?.widgetTextStyle)
    }

    private func styleConfigForWidgetType(_ type: StyleResolver.WidgetType) -> WidgetStyle? {
        switch type {
        case .callout:
            return calloutStyle
        case .expressCheckoutCallout:
            return expressCheckoutCalloutStyle
        case .paymentMethod:
            return paymentMethodStyle
        case .purchaseConfirmation:
            return purchaseConfirmationStyle
        case .campaignLink:
            return campaignLinkStyle
        }
    }
}
