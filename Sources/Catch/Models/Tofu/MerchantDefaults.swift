//
//  MerchantDefaults.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

/**
 Merchant defaults used by the Tofu web view.
 */
struct MerchantDefaults: Encodable {
    let defaultEarnedRewardsRate: Double
    let defaultSignUpBonus: Int
    let defaultSignUpDiscount: Int
    let enableConfigurableRewards: Bool

    init(merchant: Merchant) {
        self.defaultEarnedRewardsRate = merchant.defaultEarnedRewardsRate
        self.defaultSignUpBonus = merchant.defaultSignUpBonus
        self.defaultSignUpDiscount = merchant.defaultSignUpDiscount
        self.enableConfigurableRewards = merchant.enableConfigurableRewards
    }
}
