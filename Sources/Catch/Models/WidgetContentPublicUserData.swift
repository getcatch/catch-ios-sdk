//
//  WidgetContentPublicUserData.swift
//  Catch
//
//  Created by Lucille Benoit on 4/17/23.
//

import Foundation

struct WidgetContentPublicUserData: Codable {
    let availableRewardBreakdown: [AvailableRewardDetail]?
    let firstPurchaseBonusEligibility: Bool
    var userFirstName: String? = nil
    let rewardAmount: Int?
    var wasReferred: Bool = false
    var isCatchEmployee: Bool = false

    static var noData: WidgetContentPublicUserData {
        return WidgetContentPublicUserData(availableRewardBreakdown: [],
                                           firstPurchaseBonusEligibility: true,
                                           rewardAmount: 0)
    }
}
