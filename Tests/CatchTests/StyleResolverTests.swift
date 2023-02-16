//
//  StyleResolverTests.swift
//  
//
//  Created by Lucille Benoit on 12/7/22.
//

import XCTest
@testable import Catch

final class StyleResolverTests: XCTestCase {

    /// Tests that local label widget overrides successfully override the local theme
    func testStyleResolverCalloutOverrideLocalTheme() {
        let localTheme: Theme = .darkColor
        let localOverrides = MockStyles.localCalloutOverrides
        let widgetType: StyleResolver.WidgetType = .callout
        let resolvedStyle = StyleResolver.resolved(widgetType: widgetType,
                                                   localTheme: localTheme,
                                                   localOverrides: localOverrides,
                                                   globalTheme: .lightColor,
                                                   globalOverrides: nil) as? InfoWidgetStyle

        XCTAssertNotNil(resolvedStyle, "The resolved style should be of type InfoWidgetStyle")
        let textStyle = resolvedStyle?.textStyle
        let overrideTextStyle = localOverrides.textStyle
        let themeTextStyle = localTheme.styleDefaultForWidgetType(widgetType)?.textStyle

        let infoButtonStyle = resolvedStyle?.infoButtonStyle
        let overrideInfoButtonStyle = localOverrides.infoButtonStyle

        // Attributes which were defined in the local overrides should exist in the resolved style
        XCTAssertEqual(textStyle?.font, overrideTextStyle?.font)
        XCTAssertEqual(textStyle?.textColor, overrideTextStyle?.textColor)
        XCTAssertEqual(textStyle?.letterSpacing, overrideTextStyle?.letterSpacing)
        XCTAssertEqual(infoButtonStyle?.font, overrideInfoButtonStyle?.font)
        XCTAssertEqual(infoButtonStyle?.textColor, overrideInfoButtonStyle?.textColor)
        XCTAssertEqual(infoButtonStyle?.letterSpacing, overrideInfoButtonStyle?.letterSpacing)

        // Attributes which were left empty in the local overrides should fall back on local theme styling
        XCTAssertEqual(textStyle?.textTransform, themeTextStyle?.textTransform)
        XCTAssertEqual(textStyle?.lineSpacing, themeTextStyle?.lineSpacing)
    }

    /// Tests that local action widget overrides successfully override the local theme
    func testStyleResolverPurchaseConfirmationOverrideLocalTheme() {
        let widgetType: StyleResolver.WidgetType = .purchaseConfirmation
        let localTheme = Theme.lightColor
        let localOverrides = MockStyles.localPurchaseConfirmationOverrides
        let resolvedStyle = StyleResolver.resolved(widgetType: widgetType,
                                                   localTheme: localTheme,
                                                   localOverrides: localOverrides,
                                                   globalTheme: .lightColor,
                                                   globalOverrides: nil) as? ActionWidgetStyle

        XCTAssertNotNil(resolvedStyle, "The resolved style should be of type ActionWidgetStyle")

        let resolvedActionButtonStyle = resolvedStyle?.actionButtonStyle
        let overrideActionButtonStyle = localOverrides.actionButtonStyle
        let themeStyle = localTheme.styleDefaultForWidgetType(widgetType) as? ActionWidgetStyle
        XCTAssertNotNil(themeStyle, "The theme style should be of type ActionWidgetStyle")

        let themeActionButtonStyle = themeStyle?.actionButtonStyle

        // Attributes which were defined in the local overrides should exist in the resolved style
        XCTAssertEqual(resolvedActionButtonStyle?.textStyle?.font, overrideActionButtonStyle?.textStyle?.font)
        XCTAssertEqual(resolvedActionButtonStyle?.backgroundColor, overrideActionButtonStyle?.backgroundColor)

        // Attributes which were left empty in the local overrides should fall back on local theme styling
        XCTAssertEqual(resolvedActionButtonStyle?.cornerRadius, themeActionButtonStyle?.cornerRadius)
    }

    /// Tests that global widget-specific overrides override universal global overrides
    /// and that both override the global theme.
    func testStyleResolverOverrideGlobalThemeWithGlobalOverrides() {
        let globalCatchConfig = MockStyles.testCatchStyleConfig
        let globalWidgetSpecificOverrides = globalCatchConfig.calloutStyle
        let globalTheme: Theme = .darkColor
        let widgetType: StyleResolver.WidgetType = .callout
        let resolvedStyle = StyleResolver.resolved(widgetType: widgetType,
                                                   localTheme: nil,
                                                   localOverrides: nil,
                                                   globalTheme: globalTheme,
                                                   globalOverrides: globalCatchConfig) as? InfoWidgetStyle

        XCTAssertNotNil(resolvedStyle, "The resolved style should be of type InfoWidgetStyle")
        let textStyle = resolvedStyle?.textStyle
        let globalWidgetSpecificTextStyle = globalWidgetSpecificOverrides?.textStyle
        let themeTextStyle = globalTheme.styleDefaultForWidgetType(widgetType)?.textStyle

        // Attributes which were defined in the widget-specific global overrides should exist in the resolved style
        XCTAssertEqual(textStyle?.font, globalWidgetSpecificTextStyle?.font)
        XCTAssertEqual(textStyle?.textColor, globalWidgetSpecificTextStyle?.textColor)
        XCTAssertEqual(textStyle?.letterSpacing, globalWidgetSpecificTextStyle?.letterSpacing)

        // Attributes which were left empty in the widget-specific global overrides
        // should fall back on the general global overrides and then the global theme style
        let generalTextStyle = globalCatchConfig.textStyle
        XCTAssertEqual(textStyle?.textTransform, generalTextStyle?.textTransform)
        XCTAssertEqual(textStyle?.lineSpacing, themeTextStyle?.lineSpacing)

    }

    /// Tests that local overrides successfully override global styling
    func testStyleResolverOverrideGlobalThemeWithLocalOverrides() {
        let localOverrides = MockStyles.localPurchaseConfirmationOverrides
        let widgetType: StyleResolver.WidgetType = .purchaseConfirmation
        let globalTheme = Theme.darkColor
        let resolvedStyle = StyleResolver.resolved(widgetType: widgetType,
                                                   localTheme: nil,
                                                   localOverrides: localOverrides,
                                                   globalTheme: globalTheme,
                                                   globalOverrides: nil) as? ActionWidgetStyle

        XCTAssertNotNil(resolvedStyle, "The resolved style should be of type ActionWidgetStyle")

        let resolvedActionButtonStyle = resolvedStyle?.actionButtonStyle
        let overrideActionButtonStyle = localOverrides.actionButtonStyle
        let themeStyle = globalTheme.styleDefaultForWidgetType(widgetType) as? ActionWidgetStyle
        XCTAssertNotNil(themeStyle, "The theme style should be of type ActionWidgetStyle")

        let themeActionButtonStyle = themeStyle?.actionButtonStyle

        // Attributes which were defined in the local overrides should exist in the resolved style
        XCTAssertEqual(resolvedActionButtonStyle?.textStyle?.font, overrideActionButtonStyle?.textStyle?.font)
        XCTAssertEqual(resolvedActionButtonStyle?.backgroundColor, overrideActionButtonStyle?.backgroundColor)

        // Attributes which were left empty in the local overrides should fall back on global theme styling
        XCTAssertEqual(resolvedActionButtonStyle?.cornerRadius, themeActionButtonStyle?.cornerRadius)
    }

}
