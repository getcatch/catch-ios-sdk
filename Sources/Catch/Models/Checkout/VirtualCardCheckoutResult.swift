//
//  VirtualCardCheckoutResult.swift
//  Catch
//
//  Created by Lucille Benoit on 2/14/23.
//

import Foundation

struct VirtualCardCheckoutResult: Decodable {
    /// Amount of rewards (in US cents) that the user applied towards the purchase.
    let appliedRewardsAmount: Int?

    /// Amount (in US cents) that the user donated through the purchase.
    let userDonationAmount: Int?

    /// Amount of rewards (in US cents) that the user earned from the purchase.
    let earnedRewardsAmount: Int?

    /// Amount of rewards (in US cents) that the user earned as a sign up discount.
    let signUpDiscountAmount: Int?

    /// The purchase total (in US cents) after rewards were applied.
    let totalAfterRewards: Int?

    /// The card details for the virtual card used for checkout.
    let cardDetails: CardDetails
}
