//
//  RewardsCalculatorTests.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import XCTest
@testable import Catch

final class RewardsCalculatorTests: XCTestCase {
    let defaultRate: Double = 0.1
    let purchasePrice: Int = 1400

    func testCalculateRewardInvalidPrice() {
        let calculator = createRewardsCalculator()
        calculator.fetchCalculatedEarnedReward(price: 0,
                                               items: nil,
                                               userCohorts: nil) { result in
            switch result {
            case .success(let rewardResult):
                if case let Reward.percentRate(rate) = rewardResult.prioritizedReward {
                    XCTAssertEqual(rate, self.defaultRate, "Calculate rewards should have returned the default rate")
                } else {
                    XCTFail("Calculate earned rewards should have fallen back to percentage rate due to invalid price")
                }
            case .failure:
                XCTFail("Calculate earned rewards should not fail due to invalid price")
            }
        }
    }

    // Test valid purchase price for users with sign up discount
    func testCalculateRewardWithSignUpBonus() {
        let userData = MockDataProvider.publicUserDataNew
        let earnedRewards = MockDataProvider.newUserEarnedRewardsSummary
        let calculator = createRewardsCalculator(existingUserData: userData, targetEarnedReward: earnedRewards)

        let savedAmount = earnedRewards.signUpDiscountAmount + (userData.rewardAmount ?? 0)
        let expectedCreditAmount = min(savedAmount, purchasePrice)
        calculator.fetchCalculatedEarnedReward(price: purchasePrice,
                                               items: nil,
                                               userCohorts: nil) { result in
            switch result {
            case .success(let rewardResult):
                if case let Reward.earnedCredits(credits) = rewardResult.prioritizedReward {
                    XCTAssertEqual(credits, expectedCreditAmount)
                    XCTAssertNotNil(calculator.getEarnedRewardsSummary)
                } else {
                    XCTFail("Calculate earned rewards should have returned earned credits")
                }
            case .failure:
                XCTFail("Calculate earned rewards should not fail for reward with sign up bonus")
            }
        }

    }

    // Test rewards calculator for users with no sign up discount, but with redeemable credits
    func testCalculateRewardWithRedeemableCredits() {
        let userData = MockDataProvider.publicUserDataReturning
        let earnedRewards = MockDataProvider.defaultEarnedRewardsSummary
        let calculator = createRewardsCalculator(existingUserData: userData, targetEarnedReward: earnedRewards)

        let expectedCreditAmount = min(userData.rewardAmount ?? 0, purchasePrice)
        calculator.fetchCalculatedEarnedReward(price: purchasePrice,
                                               items: nil,
                                               userCohorts: nil) { result in
            switch result {
            case .success(let rewardResult):
                if case let Reward.redeemableCredits(credits) = rewardResult.prioritizedReward {
                    XCTAssertEqual(credits, expectedCreditAmount)
                    XCTAssertNotNil(calculator.getEarnedRewardsSummary)
                } else {
                    XCTFail("Calculate earned rewards should have returned redeemable credits")
                }
            case .failure:
                XCTFail("Calculate earned rewards should not fail for reward with redeemable credits")
            }
        }
    }

    // Test rewards calculator for users with no sign up discount, nor redeemable credits but with earned rewards
    func testCalculateRewardWithEarnedRewards() {
        let userData = MockDataProvider.publicUserDataNoCredits
        let earnedRewards = MockDataProvider.defaultEarnedRewardsSummary
        let calculator = createRewardsCalculator(existingUserData: userData, targetEarnedReward: earnedRewards)

        let expectedCreditAmount = earnedRewards.earnedRewardsTotal
        calculator.fetchCalculatedEarnedReward(price: purchasePrice,
                                               items: nil,
                                               userCohorts: nil) { result in
            switch result {
            case .success(let rewardResult):
                if case let Reward.earnedCredits(credits) = rewardResult.prioritizedReward {
                    XCTAssertEqual(credits, expectedCreditAmount)
                    XCTAssertNotNil(calculator.getEarnedRewardsSummary)
                } else {
                    XCTFail("Calculate earned rewards should have returned earned credits")
                }
            case .failure:
                XCTFail("Calculate earned rewards should not fail for reward with earned rewards")
            }
        }
    }

    // Test rewards calculator fallback on default percentage rate if all else fails
    func testCalculateRewardFallback() {
        let merchant = MockDataProvider.defaultMerchant
        let userData = MockDataProvider.publicUserDataNoCredits
        let earnedRewards = MockDataProvider.earnedRewardsSummaryNoRewards
        let calculator = createRewardsCalculator(existingUserData: userData, targetEarnedReward: earnedRewards)

        let expectedRate = max(merchant.defaultEarnedRewardsRate, earnedRewards.percentageRewardRate)
        calculator.fetchCalculatedEarnedReward(price: purchasePrice,
                                               items: nil,
                                               userCohorts: nil) { result in

            if case let .success(rewardResult) = result,
                case let Reward.percentRate(rate) = rewardResult.prioritizedReward {
                XCTAssertEqual(rate, expectedRate)
                XCTAssertNotNil(calculator.getEarnedRewardsSummary)
            } else {
                XCTFail("Calculate earned rewards should have fallen back to percent rewards rate")
            }
        }
    }

    // Test rewards calculator when there is no user data previously loaded (going through /widget_content)
    // In this case the fetched user has redeemable credits
    func testCalculateWidgetContentRedeemableCredits() {
        let earnedRewards = MockDataProvider.defaultEarnedRewardsSummary
        let targetUserData = MockDataProvider.publicUserDataReturning
        let calculator = createRewardsCalculator(existingUserData: nil,
                                                 targetEarnedReward: earnedRewards,
                                                 targetUserData: targetUserData)
        var userData = calculator.getWidgetContentPublicUserData()
        XCTAssertNil(userData, "There should be no user data cached prior to widget content call.")
        let expectedCredits = targetUserData.rewardAmount
        calculator.fetchCalculatedEarnedReward(price: 50000,
                                               items: nil,
                                               userCohorts: nil) { result in
            if case let .success(rewardResult) = result,
                case let Reward.redeemableCredits(credits) = rewardResult.prioritizedReward {
                // Validate redeemable credit amount matches expected amount
                XCTAssertEqual(credits, expectedCredits)
                XCTAssertNotNil(calculator.getEarnedRewardsSummary)
                // Validate that user data was cached after /widget_content call
                userData = calculator.getWidgetContentPublicUserData()
                XCTAssertEqual(userData, targetUserData)
            } else {
                XCTFail("Widget content should have returned the redeemable credits from the fetched user")
            }
        }
    }

    // Test rewards calculator when there is no user data previously loaded (going through /widget_content)
    // In this case the fetched user is a new user
    func testCalculateWidgetContentNewUser() {
        let earnedRewards = MockDataProvider.newUserEarnedRewardsSummary
        let targetUserData = MockDataProvider.publicUserDataNew
        let calculator = createRewardsCalculator(existingUserData: nil,
                                                 targetEarnedReward: earnedRewards,
                                                 targetUserData: targetUserData)
        var userData = calculator.getWidgetContentPublicUserData()
        XCTAssertNil(userData, "There should be no user data cached prior to widget content call.")
        calculator.fetchCalculatedEarnedReward(price: 50000,
                                               items: nil,
                                               userCohorts: nil) { result in
            if case let .success(rewardResult) = result,
                case let Reward.earnedCredits(credits) = rewardResult.prioritizedReward {
                // Validate earned reward amount matches expected amount
                XCTAssertEqual(credits, earnedRewards.signUpDiscountAmount)
                XCTAssertNotNil(calculator.getEarnedRewardsSummary)
                // Validate that user data was cached after /widget_content call
                userData = calculator.getWidgetContentPublicUserData()
                XCTAssertEqual(userData, targetUserData)
            } else {
                XCTFail("Widget content should have returned the earned credits from the new user")
            }
        }
    }

    /**
        Creates a reward calculator
     - Parameter existingUserData: Public user data that is already cached at the time of the network call
     - Parameter targetEarnedReward: The earned rewards summary that will be returned by the network service.
     - Parameter targetUserData: Public user data that will be returned by the /widget_content network call.
     */
    private func createRewardsCalculator(
        existingUserData: WidgetContentPublicUserData? = MockDataProvider.publicUserDataReturning,
        targetEarnedReward: EarnedRewardsSummary = MockDataProvider.defaultEarnedRewardsSummary,
        targetUserData: WidgetContentPublicUserData? = nil
    ) -> RewardsCalculator {

        let merchantRepository = MockMerchantRepository()
        let userRepository = MockUserRepository(userOverride: existingUserData)
        let rewardsNetworkService = MockRewardsCalculatorNetworkService(
            targetRewardSummary: targetEarnedReward,
            targetUserData: targetUserData
        )
        return RewardsCalculator(userRepository: userRepository,
                                 merchantRepository: merchantRepository,
                                 rewardsNetworkService: rewardsNetworkService)
    }

}
