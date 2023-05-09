//
//  TofuOpenDataTests.swift
//  
//
//  Created by Lucille Benoit on 5/3/23.
//

import Foundation

import XCTest
@testable import Catch

final class TofuOpenDataTests: XCTestCase {
    static let mockMerchant = MockDataProvider.defaultMerchant
    static let earnedRewards = MockDataProvider.defaultEarnedRewardsSummary
    static var returningUser = MockDataProvider.publicUserDataReturning
    static var defaultTofuDataResult: [String: Any?] = [:]

    override class func setUp() {
        super.setUp()
        // Called once before all tests are run
        let tofuData = TofuOpenData(earnedRewards: earnedRewards,
                                    price: 1000,
                                    merchant: mockMerchant,
                                    publicUserData: returningUser,
                                    path: .howItWorks)
        defaultTofuDataResult = tofuData.toDict()
    }

    // Test that the merchant defaults are encoded correctly
    func testTofuMerchantDefaults() {
        let merchant = TofuOpenDataTests.mockMerchant
        let result = TofuOpenDataTests.defaultTofuDataResult
        guard let merchantDefaults = result["merchantDefaults"] as? [String: Any] else {
            XCTFail("Merchant defaults should not be nil")
            return
        }
        // Validate all fields remained in camel case and match the mock merchant's values
        XCTAssertEqual(merchantDefaults["defaultEarnedRewardsRate"] as? Double, merchant.defaultEarnedRewardsRate)
        XCTAssertEqual(merchantDefaults["defaultSignUpBonus"] as? Int, merchant.defaultSignUpBonus)
        XCTAssertEqual(merchantDefaults["defaultSignUpDiscount"] as? Int, merchant.defaultSignUpDiscount)
        XCTAssertEqual(merchantDefaults["enableConfigurableRewards"] as? Bool, merchant.enableConfigurableRewards)
    }

    // Test that the merchant donation recipient was encoded correctly
    func testTofuDonationRecipient() {
        let merchant = TofuOpenDataTests.mockMerchant
        let result = TofuOpenDataTests.defaultTofuDataResult
        guard let donationRecipient = result["donationRecipient"] as? [String: Any] else {
            XCTFail("Donation recipient should not be nil")
            return
        }
        // Validate all fields remained in camel case and match the mock merchant's values
        XCTAssertEqual(donationRecipient["name"] as? String?, merchant.donationRecipient?.name)
        XCTAssertEqual(donationRecipient["url"] as? String?, merchant.donationRecipient?.url)
    }

    // Test that the public user data was encoded correctly
    func testTofuPublicUserData() {
        let publicUserData = TofuOpenDataTests.returningUser
        let result = TofuOpenDataTests.defaultTofuDataResult
        guard let userDataDict = result["publicUserData"] as? [String: Any] else {
            XCTFail("Public user data should not be nil")
            return
        }
        // Validate all fields were converted to snake case and match the mock user data values
        XCTAssertEqual(userDataDict["first_purchase_bonus_eligibility"] as? Bool,
                       publicUserData.firstPurchaseBonusEligibility)
        XCTAssertEqual(userDataDict["user_first_name"] as? String?,
                       publicUserData.userFirstName)
        XCTAssertEqual(userDataDict["reward_amount"] as? Int?,
                       publicUserData.rewardAmount)
        XCTAssertEqual(userDataDict["was_referred"] as? Bool,
                       publicUserData.wasReferred)
        XCTAssertEqual(userDataDict["is_catch_employee"] as? Bool,
                       publicUserData.isCatchEmployee)
    }

    // Test that the earned rewards breakdown was encoded correctly
    func testTofuEarnedRewards() {
        let result = TofuOpenDataTests.defaultTofuDataResult
        let earnedRewards = TofuOpenDataTests.earnedRewards
        guard let earnedRewardsDict = result["earnedRewardsBreakdown"] as? [String: Any] else {
            XCTFail("Earned rewards breakdown should not be nil")
            return
        }

        // Validate that earned rewards were converted to snake case and match expected values
        XCTAssertEqual(earnedRewardsDict["sign_up_bonus_amount"] as? Int,
                       earnedRewards.signUpBonusAmount)
        XCTAssertEqual(earnedRewardsDict["sign_up_discount_amount"] as? Int,
                       earnedRewards.signUpDiscountAmount)
        XCTAssertEqual(earnedRewardsDict["percentage_reward_rate"] as? Double,
                       earnedRewards.percentageRewardRate)
        XCTAssertEqual(earnedRewardsDict["earned_rewards_total"] as? Int?,
                       earnedRewards.earnedRewardsTotal)
    }

    func testTofuOpenDataNoRewards() {
        let merchant = TofuOpenDataTests.mockMerchant
        let price = 1000
        let path = TofuPath.howItWorks
        let publicUserData = MockDataProvider.publicUserDataNew
        let tofuData = TofuOpenData(earnedRewards: MockDataProvider.newUserEarnedRewardsSummary,
                                    price: price,
                                    merchant: merchant,
                                    publicUserData: publicUserData,
                                    path: path)
        let result = tofuData.toDict()
        XCTAssertEqual(result["path"] as? String, path.rawValue)
        XCTAssertEqual(result["price"] as? String, String(price))
        XCTAssertEqual(result["userIsRedeeming"] as? Bool, false)
    }

    // Test tofu open available rewards are encoded correctly when all rewards are available.
    func testTofuOpenDataAvailableRewards() {
        // Add available rewards to the user's available reward breakdown
        var userWithRewards = TofuOpenDataTests.returningUser
        let unrestrictedAmount = 1000
        let restrictedAmount = 2000
        let orderMinimum = 50000
        let percentageAmount = 10000
        let percentageMaximum = 0.1
        let price = orderMinimum + 1
        let allowablePercentage = Int(min(Double(percentageAmount),
                                          Double(price) * percentageMaximum))
        userWithRewards.availableRewardBreakdown = createAwardDetails(
            unrestrictedAmount: unrestrictedAmount,
            orderTotalRestrictedAmount: restrictedAmount,
            orderMinimum: orderMinimum,
            percentageTotalRestrictedAmount: percentageAmount,
            percentageMaximum: percentageMaximum
        )

        // Create tofu data for order which meets the minimum required order total for the restricted reward.
        let tofuData = TofuOpenData(earnedRewards: TofuOpenDataTests.earnedRewards,
                                    price: price,
                                    merchant: TofuOpenDataTests.mockMerchant,
                                    publicUserData: userWithRewards,
                                    path: .howItWorks)
        let result = tofuData.toDict()
        guard let availableRewardsDict = result["availableRewardsBreakdown"] as? [String: Any] else {
            XCTFail("Available rewards breakdown should not be nil")
            return
        }
        XCTAssertEqual(availableRewardsDict["redeemableRewardsTotal"] as? Int,
                       restrictedAmount + unrestrictedAmount + allowablePercentage)
        XCTAssertEqual(availableRewardsDict["restrictedRewardsTotal"] as? Int, 0)
    }

    // Test tofu open available rewards are encoded correctly when some rewards are restricted.
    func testTofuOpenDataRestrictedRewards() {
        // Add available rewards to the user's available reward breakdown
        var userWithRewards = TofuOpenDataTests.returningUser
        let unrestrictedAmount = 1000
        let restrictedAmount = 2000
        let orderMinimum = 50000
        let percentageAmount = 200
        let percentageMaximum = 0.1
        let price = orderMinimum - 1
        let allowablePercentageAmount = Int(min(Double(percentageAmount),
                                                Double(price) * percentageMaximum))
        userWithRewards.availableRewardBreakdown = createAwardDetails(
            unrestrictedAmount: unrestrictedAmount,
            orderTotalRestrictedAmount: restrictedAmount,
            orderMinimum: orderMinimum,
            percentageTotalRestrictedAmount: percentageAmount,
            percentageMaximum: percentageMaximum
        )

        // Create tofu data for order which doesn't hit the minimum required order total for the restricted reward.
        let tofuData = TofuOpenData(earnedRewards: TofuOpenDataTests.earnedRewards,
                                    price: price,
                                    merchant: TofuOpenDataTests.mockMerchant,
                                    publicUserData: userWithRewards,
                                    path: .howItWorks)
        let result = tofuData.toDict()
        guard let availableRewardsDict = result["availableRewardsBreakdown"] as? [String: Any] else {
            XCTFail("Available rewards breakdown should not be nil")
            return
        }
        XCTAssertEqual(availableRewardsDict["redeemableRewardsTotal"] as? Int,
                       unrestrictedAmount + allowablePercentageAmount)
        XCTAssertEqual(availableRewardsDict["restrictedRewardsTotal"] as? Int, restrictedAmount)
    }

    private func createAwardDetails(unrestrictedAmount: Int,
                                    orderTotalRestrictedAmount: Int,
                                    orderMinimum: Int,
                                    percentageTotalRestrictedAmount: Int,
                                    percentageMaximum: Double) -> [AvailableRewardDetail] {
        let unrestrictedReward = MockDataProvider.mockAvailableRewardDetail(
            amount: unrestrictedAmount
        )
        let totalRestrictedReward = MockDataProvider.mockOrderTotalRestrictedAvailableRewardDetail(
            amount: orderTotalRestrictedAmount,
            orderMin: orderMinimum
        )

        let percentageRestrictedReward = MockDataProvider.mockPercentageRestrictedAvailableRewardDetail(
            amount: percentageTotalRestrictedAmount,
            percentage: percentageMaximum
        )

        return [unrestrictedReward, totalRestrictedReward, percentageRestrictedReward]
    }
}
