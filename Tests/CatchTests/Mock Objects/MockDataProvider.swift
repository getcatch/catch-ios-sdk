//
//  MockDataProvider.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import XCTest
@testable import Catch

class MockDataProvider {
    static var defaultMerchant: Merchant {
        let imageURL = """
                        https://dev.assets.getcatch.com/\
                        merchant-assets/humans-s768ng/card_background.png
                        """

        return Merchant(merchantId: "testId",
                        name: "Test Merchant",
                        url: "www.google.com",
                        defaultEarnedRewardsRate: 0.1,
                        enableConfigurableRewards: true,
                        rewardsLifetimeInDays: 180,
                        cardBackgroundImageUrl: imageURL,
                        cardBackgroundColor: "#C779D0",
                        cardFontColor: "#FFFFFF",
                        donationRecipient: DonationRecipient(name: "test recipient", url: "www.recipient.com"),
                        defaultSignUpBonus: 1000,
                        defaultSignUpDiscount: 0,
                        unrestrictedRewardRuleId: "unrestrictedId",
                        newCatchUserRewardRuleId: "newCatchUserId",
                        theme: nil)
    }

    // Mock returning user with no credits
    static var publicUserDataNoCredits: WidgetContentPublicUserData {
        return WidgetContentPublicUserData(availableRewardBreakdown: nil,
                                           firstPurchaseBonusEligibility: false,
                                           userFirstName: "FirstName",
                                           rewardAmount: 0)
    }

    // Mock returning user with credits
    static var publicUserDataReturning: WidgetContentPublicUserData {
        return WidgetContentPublicUserData(availableRewardBreakdown: nil,
                                           firstPurchaseBonusEligibility: false,
                                           userFirstName: "FirstName",
                                           rewardAmount: 1500)
    }

    // Mock brand new user
    static var publicUserDataNew: WidgetContentPublicUserData {
        return WidgetContentPublicUserData(availableRewardBreakdown: nil,
                                           firstPurchaseBonusEligibility: true,
                                           userFirstName: "FirstName",
                                           rewardAmount: 0)
    }

    static var defaultEarnedRewardsSummary: EarnedRewardsSummary {
        return EarnedRewardsSummary(signUpBonusAmount: 0,
                                    signUpDiscountAmount: 0,
                                    percentageRewardRate: 0.1,
                                    earnedRewardsTotal: 1000,
                                    earnedRewardBreakdown: [])
    }

    static var newUserEarnedRewardsSummary: EarnedRewardsSummary {
        return EarnedRewardsSummary(signUpBonusAmount: 0,
                                    signUpDiscountAmount: 1000,
                                    percentageRewardRate: 0.1,
                                    earnedRewardsTotal: 5000,
                                    earnedRewardBreakdown: [])
    }

    static var earnedRewardsSummaryNoRewards: EarnedRewardsSummary {
        return EarnedRewardsSummary(signUpBonusAmount: 0,
                                    signUpDiscountAmount: 0,
                                    percentageRewardRate: 0.15,
                                    earnedRewardsTotal: 0,
                                    earnedRewardBreakdown: [])
    }

    static func mockWidgetContent(rewardsSummary: EarnedRewardsSummary?,
                                  publicUserData: WidgetContentPublicUserData) -> WidgetContent {
        return WidgetContent(earnedRewards: rewardsSummary,
                             publicUserData: publicUserData)
    }

    static func mockAvailableRewardDetail(amount: Int) -> AvailableRewardDetail {
        return AvailableRewardDetail(rewardIds: ["reward_id"],
                                     amount: amount,
                                     rewardAmounts: [amount],
                                     expirations: [],
                                     redeemableFlatOrderTotalMin: nil,
                                     redeemablePercentageOrderTotalMax: nil)
    }

    static func mockOrderTotalRestrictedAvailableRewardDetail(amount: Int, orderMin: Int) -> AvailableRewardDetail {
        return AvailableRewardDetail(rewardIds: ["reward_id"],
                                     amount: amount,
                                     rewardAmounts: [amount],
                                     expirations: [],
                                     redeemableFlatOrderTotalMin: orderMin,
                                     redeemablePercentageOrderTotalMax: nil)
    }

    static func mockPercentageRestrictedAvailableRewardDetail(amount: Int,
                                                              percentage: Double) -> AvailableRewardDetail {
        return AvailableRewardDetail(rewardIds: ["reward_id"],
                                     amount: amount,
                                     rewardAmounts: [amount],
                                     expirations: [],
                                     redeemableFlatOrderTotalMin: nil,
                                     redeemablePercentageOrderTotalMax: percentage)
    }

    static var mockCheckoutPrefill = CheckoutPrefill (userPhone: "123456789",
                                                      userName: "Jane Doe",
                                                      userEmail: "janedoe@gmail.com")
}
