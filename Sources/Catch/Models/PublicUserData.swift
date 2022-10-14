//
//  PublicUserData.swift
//  
//
//  Created by Lucille Benoit on 9/15/22.
//

import Foundation

struct PublicUserData: Codable {

    /// The user's public first name
    let userFirstName: String

    /** Amount of rewards (in US cents) that the user has available for use at this merchant.
     Includes flex rewards.
     */
    let rewardAmount: Int

    /// Whether or not the current user is eligible for a first-time purchase bonus.
    let firstPurchaseBonusEligibility: Bool

}
