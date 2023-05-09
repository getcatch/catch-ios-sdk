//
//  AvailableRewardDetail.swift
//  Catch
//
//  Created by Lucille Benoit on 4/17/23.
//

import Foundation

struct AvailableRewardDetail: Codable, Equatable {
    let rewardIds: [String]
    var amount: Int
    let rewardAmounts: [Int]
    let expirations: [Date?]
    let redeemableFlatOrderTotalMin: Int?
    let redeemablePercentageOrderTotalMax: Double?
}
