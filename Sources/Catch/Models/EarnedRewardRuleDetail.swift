//
//  EarnedRewardRuleDetail.swift
//  Catch
//
//  Created by Lucille Benoit on 11/12/22.
//

import Foundation

struct EarnedRewardRuleDetail: Codable {
    let rewardRuleId: String
    let earnedRewardAmount: Int
    let userFacingName: String?
    let rewardAmountType: String?
    let ruleEngineType: String?
    let flatRewardAmount: Int?
    let percentageRewardRate: Double?
    let rewardType: String?
    let detailsLink: String?
    let sortOrder: Int?
}
