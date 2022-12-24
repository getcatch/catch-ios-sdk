//
//  RewardType.swift
//  
//
//  Created by Lucille Benoit on 12/23/22.
//

import Foundation

/**
 Reward types used to generate default merchant rewards summaries.
 */
enum RewardType {
    static let unrestrictedRewardRuleUserFacingName = "on every order"
    static let unrestrictedRuleEngineType = "unrestricted"
    static let newCatchUserRewardRuleUserFacingName = "First order boost"
    static let newCatchUserRuleEngineType = "new_catch_user"
    static let percentageRewardAmountType = "percentage"
    static let flatRewardAmountType = "flat"
}
