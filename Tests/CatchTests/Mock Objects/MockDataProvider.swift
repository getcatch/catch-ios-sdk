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
                        rewardsRate: 0.1,
                        rewardsLifetimeInDays: 180,
                        cardBackgroundImageUrl: imageURL,
                        cardBackgroundColor: "#C779D0",
                        cardFontColor: "#FFFFFF",
                        donationRecipient: nil)
    }

    static var publicUserDataNoCredits: PublicUserData {
        return PublicUserData(userFirstName: "FirstName",
                              rewardAmount: 0,
                              firstPurchaseBonusEligibility: false)
    }

    static var publicUserDataReturning: PublicUserData {
        return PublicUserData(userFirstName: "FirstName",
                              rewardAmount: 1500,
                              firstPurchaseBonusEligibility: false)
    }

    static var publicUserDataNew: PublicUserData {
        return PublicUserData(userFirstName: "First",
                              rewardAmount: 100,
                              firstPurchaseBonusEligibility: true)
    }

    static var defaultEarnedRewardsSummary: EarnedRewardsSummary {
        return EarnedRewardsSummary(signUpBonusAmount: 0,
                                    signUpDiscountAmount: 0,
                                    percentageRewardRate: 0.1,
                                    earnedRewardsTotal: 1000)
    }

    static var newUserEarnedRewardsSummary: EarnedRewardsSummary {
        return EarnedRewardsSummary(signUpBonusAmount: 1000,
                                    signUpDiscountAmount: 0,
                                    percentageRewardRate: 0.1,
                                    earnedRewardsTotal: 5000)
    }

    static var earnedRewardsSummaryNoRewards: EarnedRewardsSummary {
        return EarnedRewardsSummary(signUpBonusAmount: 0,
                                    signUpDiscountAmount: 0,
                                    percentageRewardRate: 0.15,
                                    earnedRewardsTotal: 0)
    }
}
