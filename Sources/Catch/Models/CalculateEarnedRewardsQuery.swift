//
//  CalculateEarnedRewardsQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

struct CalculateEarnedRewardsQuery: Encodable {
    let amountEligibleForEarnedRewards: Int
    let isNewCatchUser: Bool
    let excludeCartBasedRules: Bool = false
    let includeEarnedRewardBreakdown: Bool = true
    var items: String?
    var userCohorts: String?
}
