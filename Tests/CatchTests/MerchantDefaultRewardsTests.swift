//
//  MerchantDefaultRewardsTests.swift
//  
//
//  Created by Lucille Benoit on 12/23/22.
//

import Foundation

import XCTest
@testable import Catch

final class MerchantDefaultRewardsTests: XCTestCase {
    let price = 2000
    let userRewardAmount = 200
    let merchant = MockDataProvider.defaultMerchant

    // Test default calculated merchant rewards for a user not eligible for the first purchase bonus
    func testDefaultRewardsReturningUser() {
        let defaultRewardSummary = merchant.generateCalculatedRewards(price: price,
                                                                userRewardAmount: userRewardAmount,
                                                                firstPurchaseBonusEligibility: false)
        let amountEligibleForEarnedRewards = max(price-userRewardAmount, 0)
        let unrestrictedEarnedRewardAmount = Int(
            ceil(Double(amountEligibleForEarnedRewards) * merchant.defaultEarnedRewardsRate)
        )

        let expectedRewardRuleDetail = EarnedRewardRuleDetail(
            rewardRuleId: merchant.unrestrictedRewardRuleId,
            earnedRewardAmount: unrestrictedEarnedRewardAmount,
            userFacingName: RewardType.unrestrictedRewardRuleUserFacingName,
            rewardAmountType: RewardType.percentageRewardAmountType,
            ruleEngineType: RewardType.unrestrictedRuleEngineType,
            percentageRewardRate: merchant.defaultEarnedRewardsRate
        )

        // Validate that merchant default bonuses exist on the earned rewards summary
        XCTAssertEqual(defaultRewardSummary.signUpBonusAmount, merchant.defaultSignUpBonus)
        XCTAssertEqual(defaultRewardSummary.signUpDiscountAmount, merchant.defaultSignUpDiscount)
        XCTAssertEqual(defaultRewardSummary.percentageRewardRate, merchant.defaultEarnedRewardsRate)

        // The total reward should equal the unrestricted earned reward amount
        XCTAssertEqual(defaultRewardSummary.earnedRewardsTotal, expectedRewardRuleDetail.earnedRewardAmount)

        // Earned reward breakdown should only include the unrestricted reward rule detail
        XCTAssertEqual(defaultRewardSummary.earnedRewardBreakdown, [expectedRewardRuleDetail])
    }

    // Test default calculated merchant rewards for a user eligible for the first purchase bonus
    func testDefaultRewardsFirstTimeUser() {
        let defaultRewardSummary = merchant.generateCalculatedRewards(price: price,
                                                                userRewardAmount: userRewardAmount,
                                                                firstPurchaseBonusEligibility: true)
        let amountEligibleForEarnedRewards = max(price-userRewardAmount, 0)
        let unrestrictedEarnedRewardAmount = Int(
            ceil(Double(amountEligibleForEarnedRewards) * merchant.defaultEarnedRewardsRate)
        )

        let expectedUnrestrictedRewardRule = EarnedRewardRuleDetail(
            rewardRuleId: merchant.unrestrictedRewardRuleId,
            earnedRewardAmount: unrestrictedEarnedRewardAmount,
            userFacingName: RewardType.unrestrictedRewardRuleUserFacingName,
            rewardAmountType: RewardType.percentageRewardAmountType,
            ruleEngineType: RewardType.unrestrictedRuleEngineType,
            percentageRewardRate: merchant.defaultEarnedRewardsRate
        )

        let expectedNewCatchUserRewardRule = EarnedRewardRuleDetail(
            rewardRuleId: merchant.newCatchUserRewardRuleId,
            earnedRewardAmount: merchant.defaultSignUpBonus,
            userFacingName: RewardType.newCatchUserRewardRuleUserFacingName,
            rewardAmountType: RewardType.flatRewardAmountType,
            ruleEngineType: RewardType.newCatchUserRuleEngineType,
            flatRewardAmount: merchant.defaultSignUpBonus
        )

        // Validate that merchant default bonuses exist on the earned rewards summary
        XCTAssertEqual(defaultRewardSummary.signUpBonusAmount, merchant.defaultSignUpBonus)
        XCTAssertEqual(defaultRewardSummary.signUpDiscountAmount, merchant.defaultSignUpDiscount)
        XCTAssertEqual(defaultRewardSummary.percentageRewardRate, merchant.defaultEarnedRewardsRate)

        // The total reward should equal the unrestricted earned reward amount plus the new user reward amount
        let expectedTotal = expectedUnrestrictedRewardRule.earnedRewardAmount
        + expectedNewCatchUserRewardRule.earnedRewardAmount
        XCTAssertEqual(defaultRewardSummary.earnedRewardsTotal, expectedTotal)

        // The reward breakdown should include both the unrestricted reward rule and the new user reward rule
        let expectedBreakdown = [expectedUnrestrictedRewardRule, expectedNewCatchUserRewardRule]
        XCTAssertEqual(defaultRewardSummary.earnedRewardBreakdown, expectedBreakdown)
    }
}
