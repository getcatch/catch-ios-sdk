//
//  EarnedReward.swift
//  
//
//  Created by Lucille Benoit on 9/15/22.
//

import Foundation

struct EarnedReward: Codable {

    /// Amount of rewards (in US cents) that the user can earn as a sign up bonus.
    let signUpDiscountAmount: Int

    /// Between 0 and 1, the fraction of amount paid that a user earns back from their purchase.
    let percentageRewardRate: Double

}
