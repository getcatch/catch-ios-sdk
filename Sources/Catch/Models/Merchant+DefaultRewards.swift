//
//  Merchant+DefaultRewards.swift
//  
//
//  Created by Lucille Benoit on 12/23/22.
//

import Foundation

/**
 Extension to generate the default earned rewards summary for a merchant.
 */
extension Merchant {
    private var newCatchUserRewardRule: EarnedRewardRuleDetail {
        return EarnedRewardRuleDetail(
            rewardRuleId: newCatchUserRewardRuleId,
            earnedRewardAmount: defaultSignUpBonus,
            userFacingName: RewardType.newCatchUserRewardRuleUserFacingName,
            rewardAmountType: RewardType.flatRewardAmountType,
            ruleEngineType: RewardType.newCatchUserRuleEngineType,
            flatRewardAmount: defaultSignUpBonus
        )
    }

    private func unrestrictedEarnedRewardRule(price: Int,
                                              userRewardAmount: Int) -> EarnedRewardRuleDetail {
        let amountEligibleForEarnedRewards = max(price-userRewardAmount, 0)
        let unrestrictedEarnedRewardAmount = Int(
            ceil(Double(amountEligibleForEarnedRewards) * defaultEarnedRewardsRate)
        )

        return EarnedRewardRuleDetail(
            rewardRuleId: unrestrictedRewardRuleId,
            earnedRewardAmount: unrestrictedEarnedRewardAmount,
            userFacingName: RewardType.unrestrictedRewardRuleUserFacingName,
            rewardAmountType: RewardType.percentageRewardAmountType,
            ruleEngineType: RewardType.unrestrictedRuleEngineType,
            percentageRewardRate: defaultEarnedRewardsRate
        )
    }

    func generateCalculatedRewards(price: Int,
                                   userRewardAmount: Int,
                                   firstPurchaseBonusEligibility: Bool) -> EarnedRewardsSummary {
        let unrestrictedEarnedRewardBreakdown = unrestrictedEarnedRewardRule(price: price,
                                                                             userRewardAmount: userRewardAmount)
        var earnedRewardBreakdownList: [EarnedRewardRuleDetail] = [unrestrictedEarnedRewardBreakdown]

        if firstPurchaseBonusEligibility {
            earnedRewardBreakdownList += [newCatchUserRewardRule]
        }

        let earnedRewardsTotal = earnedRewardBreakdownList.sum(\.earnedRewardAmount)

        return EarnedRewardsSummary(signUpBonusAmount: defaultSignUpBonus,
                                    signUpDiscountAmount: defaultSignUpDiscount,
                                    percentageRewardRate: defaultEarnedRewardsRate,
                                    earnedRewardsTotal: earnedRewardsTotal,
                                    earnedRewardBreakdown: earnedRewardBreakdownList)
    }
}
