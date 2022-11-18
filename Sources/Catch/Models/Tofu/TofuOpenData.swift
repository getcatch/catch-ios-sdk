//
//  TofuOpenData.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

/**
 Data to be post messaged to Tofu webview when opened.
 */
struct TofuOpenData: Encodable {
    let earnedRewardsBreakdown: EarnedRewardsSummary
    let price: String
    let merchantDefaults: MerchantDefaults
    let path: String

    init(earnedRewards: EarnedRewardsSummary, price: Int, merchant: Merchant, path: TofuPath) {
        self.earnedRewardsBreakdown = earnedRewards
        self.price = String(price)
        self.merchantDefaults = MerchantDefaults(merchant: merchant)
        self.path = path.rawValue
    }

    var dict: [String: Any] {
        // Because the Tofu post message requires mixed snake case and camel case params,
        // earned rewards breakdown and merchant defaults must be encoded separately.
        guard let breakdown = try? earnedRewardsBreakdown.encoded(encodingStrategy: .convertToSnakeCase),
              let defaults = try? merchantDefaults.encoded(encodingStrategy: .useDefaultKeys),
              let breakdownDict = try? JSONSerialization.jsonObject(with: breakdown),
                let defaultsDict = try? JSONSerialization.jsonObject(with: defaults) else { return [:] }
        return [
            "earnedRewardsBreakdown": breakdownDict,
            "price": price,
            "merchantDefaults": defaultsDict,
            "path": path
        ]
    }
}
