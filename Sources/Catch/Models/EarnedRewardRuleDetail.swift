//
//  EarnedRewardRuleDetail.swift
//  Catch
//
//  Created by Lucille Benoit on 11/12/22.
//

import Foundation

struct EarnedRewardRuleDetail: Codable, Equatable {
    var rewardRuleId: String
    var earnedRewardAmount: Int
    var userFacingName: String?
    var rewardAmountType: String?
    var ruleEngineType: String?
    var flatRewardAmount: Int?
    var percentageRewardRate: Double?
    var rewardType: String?
    var detailsLink: String?
    var sortOrder: Int?
}
