//
//  PublicUserData.swift
//  
//
//  Created by Lucille Benoit on 9/15/22.
//

import Foundation

struct PublicUserData: Codable, Equatable {

    /// The user's public first name
    let userFirstName: String

    /** Amount of rewards (in US cents) that the user has available for use at this merchant.
     Includes flex rewards.
     */
    let rewardAmount: Int

    /// Whether or not the current user is eligible for a first-time purchase bonus.
    let firstPurchaseBonusEligibility: Bool

    static func == (lhs: PublicUserData, rhs: PublicUserData) -> Bool {
        return lhs.userFirstName == rhs.userFirstName
        && lhs.rewardAmount == rhs.rewardAmount
        && lhs.firstPurchaseBonusEligibility == rhs.firstPurchaseBonusEligibility
    }

    static var `noData`: PublicUserData {
        return PublicUserData(userFirstName: String(), rewardAmount: 0, firstPurchaseBonusEligibility: true)
    }
}
