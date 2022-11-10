//
//  RewardCampaign.swift
//  
//
//  Created by Lucille Benoit on 9/15/22.
//

import Foundation
import QuartzCore

struct RewardCampaign: Codable {

    /// The unique identifier used to navigate to the reward campaign URL.
    let rewardCampaignId: String

    /// Amount of the total reward in cents, must be greater than 0.
    let totalAmount: Int

    /// The date when the rewards expire.
    let rewardsExpiration: Date

    var campaignURLPath: String {
        // removes the reward campaign id prefix "rc-" to generate the campaign url
        let suffix = rewardCampaignId[3...]
        return String(format: CatchURL.rewardCampaignLandingPage, suffix)
    }
}
