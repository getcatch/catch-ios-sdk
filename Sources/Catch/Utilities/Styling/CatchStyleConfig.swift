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

 Any styling defined at the widget-level (ex. calloutStyle) will override styling defined globally (ex. textStyle).
 Additionally, any themes or overrides set on an individual widget will override the gloobal configurations set here.
 All styling parameters are optional and only non-nil values will override those at a higher level.
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
    var calloutStyle: InfoWidgetStyle?

    /// Configures the styling for all express checkout callout widgets
    var expressCheckoutCalloutStyle: InfoWidgetStyle?

    /// Configures the styling for all payment method widgets
    var paymentMethodStyle: InfoWidgetStyle?

    /// Configures the styling for all purchase confirmation widgets
    var purchaseConfirmationStyle: ActionWidgetStyle?

    /// Configures the styling for all campaign link widgets
    var campaignLinkStyle: ActionWidgetStyle?

    /**
     Initializes a global style config for the Catch widgets.
     - Parameter textStyle: The styling for all text components globally (see ``TextStyle``).
     - Parameter benefitTextStyle: The styling for all benefit text components globally (see ``BenefitTextStyle``).
     - Parameter infoButtonStyle: The info button styling for all widgets which contain them (see ``TextStyle``).
     - Parameter actionButtonStyle: The action button styling for all widgets which contain them
     (see ``ActionButtonStyle``).
     - Parameter calloutStyle: The styling for all ``Callout`` widgets.
     - Parameter expressCheckoutCalloutStyle: The styling for all ``ExpressCheckoutCallout`` widgets.
     - Parameter paymentMethodStyle: The styling for all ``PaymentMethod`` widgets.
     - Parameter purchaseConfirmationStyle: The styling for all ``PurchaseConfirmation`` widgets.
     - Parameter campaignLinkStyle: The styling for all ``CampaignLink`` widgets.
     */
    public init(textStyle: TextStyle? = nil,
                benefitTextStyle: BenefitTextStyle? = nil,
                infoButtonStyle: TextStyle? = nil,
                actionButtonStyle: ActionButtonStyle? = nil,
                calloutStyle: InfoWidgetStyle? = nil,
                expressCheckoutCalloutStyle: InfoWidgetStyle? = nil,
                paymentMethodStyle: InfoWidgetStyle? = nil,
                purchaseConfirmationStyle: ActionWidgetStyle? = nil,
                campaignLinkStyle: ActionWidgetStyle? = nil) {
        self.textStyle = textStyle
        self.benefitTextStyle = benefitTextStyle
        self.infoButtonStyle = infoButtonStyle
        self.actionButtonStyle = actionButtonStyle
        self.calloutStyle = calloutStyle
        self.expressCheckoutCalloutStyle = expressCheckoutCalloutStyle
        self.paymentMethodStyle = paymentMethodStyle
        self.purchaseConfirmationStyle = purchaseConfirmationStyle
        self.campaignLinkStyle = campaignLinkStyle
    }

    internal static func defaults(theme: Theme?) -> CatchStyleConfig {
        return CatchStyleConfig(textStyle: theme?.textStyle(size: .small),
                                benefitTextStyle: theme?.benefitTextStyle(size: .small),
                                infoButtonStyle: theme?.infoButtonStyle,
                                actionButtonStyle: theme?.actionButtonStyle,
                                calloutStyle: theme?.infoWidgetStyle(textSize: .small),
                                expressCheckoutCalloutStyle: theme?.infoWidgetStyle(textSize: .regular),
                                paymentMethodStyle: theme?.infoWidgetStyle(textSize: .small),
                                purchaseConfirmationStyle: theme?.actionWidgetStyle,
                                campaignLinkStyle: theme?.actionWidgetStyle)
    }

    internal func styleConfigForWidget(_ type: StyleResolver.WidgetType) -> WidgetStyle? {
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

    internal func universalConfigForWidget(_ type: StyleResolver.WidgetType) -> WidgetStyle {
        switch type {
        case .callout, .expressCheckoutCallout, .paymentMethod:
            return InfoWidgetStyle(textStyle: textStyle,
                                   benefitTextStyle: benefitTextStyle,
                                   infoButtonStyle: infoButtonStyle)
        case .purchaseConfirmation, .campaignLink:
            return ActionWidgetStyle(textStyle: textStyle,
                                     benefitTextStyle: benefitTextStyle,
                                     actionButtonStyle: actionButtonStyle)
        }
    }
}
