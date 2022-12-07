//
//  BenefitTextStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

/**
 Styling for the benefit text within Catch widgets.
 The benefit text displays the earned or redeemable credits to the user.

 Examples: "You earned $x", "Redeem $x" or "Earn x% credit".

 This portion of the text can be highlighted with a different text color or font weight.
 All other text attributes will be inherited from the general ``TextStyle``.
 */
public struct BenefitTextStyle {
    /// Configures the text color of the benefit text in the case when a user is earning credits.
    /// Example: "Earn $x credit"
    var earnTextColor: UIColor?

    /// Configures the text color of the benefit text in the case when a user is redeeming credits.
    /// Example: "Redeem $x"
    var redeemTextColor: UIColor?

    /// Configures the font to highlight the benefit text.
    var font: UIFont?
}
