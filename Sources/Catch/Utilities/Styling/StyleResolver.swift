//
//  StyleResolver.swift
//  Catch
//
//  Created by Lucille Benoit on 12/7/22.
//

import Foundation

struct StyleResolver {
    enum WidgetType {
        case callout
        case expressCheckoutCallout
        case paymentMethod
        case purchaseConfirmation
        case campaignLink
    }

    internal static func resolved(_ localTheme: Theme?,
                                  widgetType: WidgetType,
                                  localOverrides: WidgetStyle) -> WidgetStyle? {
        /// Calculate the global style configurations for the given widget type
        let globalStyleConfig = resolvedWidgetSpecificGlobalStyle(for: widgetType)

        /// Calculate the local style configurations for the given widget type
        let localStyleConfig = resolvedLocalStyle(localTheme,
                                                  widgetType: widgetType,
                                                  localOverrides: localOverrides)

        /// Resolve the local and global styles by overriding any global style rules with those that are set locally
        if let global = globalStyleConfig as? LabelWidgetStyle, let local = localStyleConfig as? LabelWidgetStyle {
            return LabelWidgetStyle.resolved(global, withOverrides: local)
        }

        if let global = globalStyleConfig as? ActionWidgetStyle, let local = localStyleConfig as? ActionWidgetStyle {
            return ActionWidgetStyle.resolved(global, withOverrides: local)
        }

        return nil
    }

    /// Resolves applicable local style rules between the local Catch theme and any local style overrides.
    private static func resolvedLocalStyle(_ theme: Theme?,
                                           widgetType: WidgetType,
                                           localOverrides: WidgetStyle?) -> WidgetStyle? {
        if let overrides = localOverrides as? LabelWidgetStyle {
            let themeStyling = LabelWidgetStyle.defaults(theme: theme, widgetType: widgetType)
            return LabelWidgetStyle.resolved(themeStyling, withOverrides: overrides)
        }

        if let overrides = localOverrides as? ActionWidgetStyle {
            let themeStyling = ActionWidgetStyle.defaults(theme: theme)
            return ActionWidgetStyle.resolved(themeStyling, withOverrides: overrides)
        }

        return nil
    }

    /// Resolves applicable global styling for a given widget type based on the resolved global style config.
    private static func resolvedWidgetSpecificGlobalStyle(for type: WidgetType) -> WidgetStyle? {
        let globalStyleConfig = resolvedGlobalStyle(withOverrides: nil) // todo this should change to Catch.globalOverrides
        switch type {
        case .callout, .expressCheckoutCallout, .paymentMethod:
            return globalStyleConfig.resolvedLabelWidgetStyle(for: type)
        case .purchaseConfirmation, .campaignLink:
            return globalStyleConfig.resolvedActionWidgetStyle(for: type)
        }
    }

    /// Resolves applicable global styling between the global Catch Theme and the global Catch Style Config overrides.
    private static func resolvedGlobalStyle(_ theme: Theme? = Catch.getTheme(),
                                            withOverrides overrides: CatchStyleConfig?) -> CatchStyleConfig {
        /// Converts the Catch standard theme into a style config struct
        let themeStyle = CatchStyleConfig.defaults(theme: theme)

        /// Resolve all general global style rules
        let resolvedTextStyle = TextStyle.resolved(themeStyle.textStyle, withOverrides: overrides?.textStyle)
        let resolvedBenefitTextStyle = BenefitTextStyle.resolved(themeStyle.benefitTextStyle,
                                                                 withOverrides: overrides?.benefitTextStyle)
        let resolvedInfoButtonStyle = TextStyle.resolved(themeStyle.infoButtonStyle,
                                                         withOverrides: overrides?.infoButtonStyle)
        let resolvedActionButtonStyle = ActionButtonStyle.resolved(themeStyle.actionButtonStyle,
                                                                   withOverrides: overrides?.actionButtonStyle)

        /// Resolve all global widget style rules
        let resolvedCalloutStyle = LabelWidgetStyle.resolved(themeStyle.calloutStyle,
                                                             withOverrides: overrides?.calloutStyle)
        let resolvedExpressCheckoutStyle = LabelWidgetStyle.resolved(
            themeStyle.expressCheckoutCalloutStyle,
            withOverrides: overrides?.expressCheckoutCalloutStyle
        )
        let resolvedPaymentMethodStyle = LabelWidgetStyle.resolved(themeStyle.paymentMethodStyle,
                                                                   withOverrides: overrides?.paymentMethodStyle)
        let resolvedPurchaseConfirmationStyle = ActionWidgetStyle.resolved(
            themeStyle.purchaseConfirmationStyle,
            withOverrides: overrides?.purchaseConfirmationStyle
        )
        let resolvedCampaignLinkStyle = ActionWidgetStyle.resolved(themeStyle.campaignLinkStyle,
                                                                   withOverrides: overrides?.campaignLinkStyle)

        /// Returns all applicable global style rules after resolving the global theme with any global style overrides
        return CatchStyleConfig(
            textStyle: resolvedTextStyle,
            benefitTextStyle: resolvedBenefitTextStyle,
            infoButtonStyle: resolvedInfoButtonStyle,
            actionButtonStyle: resolvedActionButtonStyle,
            calloutStyle: resolvedCalloutStyle,
            expressCheckoutCalloutStyle: resolvedExpressCheckoutStyle,
            paymentMethodStyle: resolvedPaymentMethodStyle,
            purchaseConfirmationStyle: resolvedPurchaseConfirmationStyle,
            campaignLinkStyle: resolvedCampaignLinkStyle
        )
    }
}
