//
//  Merchant.swift
//
//
//  Created by Lucille Benoit on 9/15/22.
//

import Foundation

struct Merchant: Codable, Equatable {

    /// The merchant's unique identifier
    let merchantId: String

    /// Name to show in checkout flow, merchant cards, etc.
    let name: String

    /// URL (base and path only) to use when directing a user to shop at this merchant.
    let url: String

    /// Between 0 and 1, the fraction of amount paid that a user gets back at this merchant.
    let defaultEarnedRewardsRate: Double

    /// Flag determining if merchant uses configurable rewards.
    let enableConfigurableRewards: Bool

    /// Number of days after earning that the rewards expire.
    let rewardsLifetimeInDays: Int

    /// Full URL for the merchant card background image
    let cardBackgroundImageUrl: String?

    /// Hexadecimal string representing the background color for the merchant card. ex. #FFFFFF
    let cardBackgroundColor: String

    /// Hexadecimal string representing the font color for the merchant card. ex. #000000
    let cardFontColor: String

    /// The recipient of donation campaigns.
    let donationRecipient: DonationRecipient?

    /// Flat amount that a new Catch user will receive in rewards at this merchant
    let defaultSignUpBonus: Int

    /// Flat amount that a new Catch user will receive as a discount at this merchant
    let defaultSignUpDiscount: Int

    /// ID corresponding to the currently active unrestricted reward rule with the highest percentage
    let unrestrictedRewardRuleId: String

    /// ID corresponding to the currently active new catch user reward rule with the highest amount
    let newCatchUserRewardRuleId: String

    /// Theme for web views
    let theme: MerchantThemeConfig?

    /// The expiration date as calculated by using the current date and the merchant's rewards lifetime.
    var expirationDate: Date? {
        return Date().byAdding(days: rewardsLifetimeInDays)
    }
}

struct MerchantThemeConfig: Codable, Equatable {
    let name: String
}
