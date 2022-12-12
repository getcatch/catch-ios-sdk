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

    internal static func resolved(
        widgetType: WidgetType,
        localTheme: Theme?,
        localOverrides: WidgetStyle?,
        globalTheme: Theme = Catch.getTheme(),
        globalOverrides: CatchStyleConfig? = Catch.getGlobalStyleOverrides()
    ) -> WidgetStyle? {
        var finalWidgetStyle: WidgetStyle?
        let localThemeStyling = localTheme?.styleDefaultForWidgetType(widgetType)

        // If a local theme has been set, ignore all global styling
        if localThemeStyling != nil {
            // Override local theme with any local overrides
            finalWidgetStyle = resolveWidgetStyle(localThemeStyling, overrides: localOverrides)
        } else {
            // Convert the global theme to the default global WidgetStyle for the specific widget type.
            let globalStyle = CatchStyleConfig.defaults(theme: globalTheme).styleConfigForWidget(widgetType)

            // Get global overrides for the specific widget type
            let globalWidgetOverrides = resolvedGlobalOverridesForWidget(globalStyleConfig: globalOverrides,
                                                                         type: widgetType)

            // Override the global theme with global overrides
            let resolvedGlobalStyle = resolveWidgetStyle(globalStyle, overrides: globalWidgetOverrides)

            // Override the resolved global WidgetStyle with any local overrides
            finalWidgetStyle = resolveWidgetStyle(resolvedGlobalStyle, overrides: localOverrides)
        }

        return finalWidgetStyle
    }

    // Given a base WidgetStyle and overrides, resolves all applicable style rules
    private static func resolveWidgetStyle(_ style: WidgetStyle?, overrides: WidgetStyle?) -> WidgetStyle? {
        guard style != nil else { return overrides }
        guard overrides != nil else { return style }
        guard let type = style?.type, type == overrides?.type else { return  nil }
        switch type {
        case .labelWidget:
            return InfoWidgetStyle.resolved(style as? InfoWidgetStyle, withOverrides: overrides as? InfoWidgetStyle)
        case .actionWidget:
            return ActionWidgetStyle.resolved(style as? ActionWidgetStyle,
                                              withOverrides: overrides as? ActionWidgetStyle)
        }
    }

    // Resolves all overrides which are applicable to a given widget type
    private static func resolvedGlobalOverridesForWidget(globalStyleConfig: CatchStyleConfig?,
                                                         type: StyleResolver.WidgetType) -> WidgetStyle? {
        guard let globalStyle = globalStyleConfig else { return nil }
        let universalGlobalOverrides = globalStyle.universalConfigForWidget(type)
        let widgetGlobalOverrides = globalStyle.styleConfigForWidget(type)
        return resolveWidgetStyle(universalGlobalOverrides, overrides: widgetGlobalOverrides)
    }
}
