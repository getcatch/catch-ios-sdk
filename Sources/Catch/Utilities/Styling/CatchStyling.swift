//
//  CatchStyling.swift
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
public struct CatchStyling {

    /// Configures the styling for text components across all widgets
    var textStyle: TextStyle?

    /// Configures the styling for benefit text components across all widgets
    var benefitTextStyle: BenefitTextStyle?

    /// Configures the styling for all info buttons across all widgets which contain them
    var infoButtonStyle: TextStyle?

    /// Configures the styling for all action buttons across all widgets which contain them
    var actionButtonStyle: ActionButtonStyle?

    /// Configures the styling for all callout widgets
    var calloutStyle: CalloutWidgetStyle?

    /// Configures the styling for all express checkout callout widgets
    var expressCheckoutCalloutStyle: CalloutWidgetStyle?

    /// Configures the styling for all payment method widgets
    var paymentMethodStyle: CalloutWidgetStyle?

    /// Configures the styling for all purchase confirmation widgets
    var purchaseConfirmationStyle: ActionWidgetStyle?

    /// Configures the styling for all campaign link widgets
    var campaignLinkStyle: ActionWidgetStyle?
}
