//
//  CatchURL.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import Foundation

enum CatchURL {
    static let getPublicMerchantData = "/api/merchants-svc/merchants/public_keys/%@/public"
    static let getPublicUserData = "/api/transactions-svc/user_devices/%@/user_data"
    static let getEarnedRewards = "/api/transactions-svc/merchants/%@/calculate_earned_rewards/public"
    static let getRewardCampaignByExternalName = "/api/transactions-svc/merchants/%@/reward_campaigns/%@/public"
    static let getDonationCampaign = "/api/transactions-svc/merchants/%@/active_donation_campaign/public"
    static let logoImage = "https://assets.getcatch.com/merchant-assets/%@/card_logo.png"
    static let signIn = "https://app.getcatch.com/u/sign-in"
    static let rewardCampaignLandingPage = "/u/e/%@"
    static let tofuPath = "/t/"
}
