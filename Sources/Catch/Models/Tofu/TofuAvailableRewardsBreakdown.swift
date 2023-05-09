//
//  TofuAvailableRewardsBreakdown.swift
//  Catch
//
//  Created by Lucille Benoit on 4/22/23.
//

import Foundation

struct TofuAvailableRewardsBreakdown: Encodable {
    let redeemableRewardsTotal: Int
    let restrictedRewards: [AvailableRewardDetail]?
    let restrictedRewardsTotal: Int
}
