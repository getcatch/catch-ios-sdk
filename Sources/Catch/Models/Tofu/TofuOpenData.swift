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
    let price: Int
    let merchantDefaults: MerchantDefaults
    let path: String
    let publicUserData: WidgetContentPublicUserData

    var availableRewardsBreakdownDict: Any? {
        if let encodedData = try? generateAvailableRewardsBreakdown().encoded(encodingStrategy: .useDefaultKeys) {
            let dict = try? JSONSerialization.jsonObject(with: encodedData)
            return dict
        }
        return nil
    }

    var publicUserDataDict: Any? {
        if let encodedData = try? publicUserData.encoded(encodingStrategy: .convertToSnakeCase) {
            return try? JSONSerialization.jsonObject(with: encodedData)
        }
        return nil
    }

    var isUserRedeeming: Bool {
        guard let rewardAmount = publicUserData.rewardAmount,
              rewardAmount > 0 else { return false }
        return true
    }

    init(earnedRewards: EarnedRewardsSummary,
         price: Int,
         merchant: Merchant,
         publicUserData: WidgetContentPublicUserData,
         path: TofuPath
    ) {
        self.earnedRewardsBreakdown = earnedRewards
        self.price = price
        self.merchantDefaults = MerchantDefaults(merchant: merchant)
        self.publicUserData = publicUserData
        self.path = path.rawValue
    }

    func toDict() -> [String: Any] {
        // Because the Tofu post message requires mixed snake case and camel case params,
        // earned rewards breakdown and merchant defaults must be encoded separately.
        guard let breakdown = try? earnedRewardsBreakdown.encoded(encodingStrategy: .convertToSnakeCase),
              let defaults = try? merchantDefaults.encoded(encodingStrategy: .useDefaultKeys),
              let availableRewardsDict = availableRewardsBreakdownDict,
              let publicUserDataDict = publicUserDataDict,
              let breakdownDict = try? JSONSerialization.jsonObject(with: breakdown),
                let defaultsDict = try? JSONSerialization.jsonObject(with: defaults) else { return [:] }
        return [
            "earnedRewardsBreakdown": breakdownDict,
            "price": String(price),
            "merchantDefaults": defaultsDict,
            "availableRewardsBreakdown": availableRewardsDict,
            "publicUserData": publicUserDataDict,
            "userIsRedeeming": isUserRedeeming,
            "path": path
        ]
    }

    private func generateAvailableRewardsBreakdown() -> TofuAvailableRewardsBreakdown {
        // For rewards restricted by percentage order total max,
        // limit the available rewards to the max percentage of the order total.
        let availableRewards = publicUserData.availableRewardBreakdown?.map  {
            if let redeemablePercentageOrderTotalMax = $0.redeemablePercentageOrderTotalMax {
                var reward = $0
                reward.amount = Int(min(Double($0.amount), Double(price) * redeemablePercentageOrderTotalMax))
                return reward
            } else {
                return $0
            }
        }

        // Calculate the redeemable total by filtering out rewards where the order
        // total minimum has not been set and taking the sum of all other available rewards.
        let redeemableRewardsTotal = availableRewards?.sum {
            let isRedeemable = price >= ($0.redeemableFlatOrderTotalMin ?? 0)
            return isRedeemable ? $0.amount : 0
        } ?? 0

        // Filter out rewards restricted by order minimum
        let restrictedRewards = availableRewards?.filter {
            price < ($0.redeemableFlatOrderTotalMin ?? 0)
        } ?? []

        // Sum the amounts in all the available rewards with restrictions
        let restrictedRewardsTotal = restrictedRewards.sum {
            $0.amount
        }

        return TofuAvailableRewardsBreakdown(redeemableRewardsTotal: redeemableRewardsTotal,
                                             restrictedRewards: restrictedRewards,
                                             restrictedRewardsTotal: restrictedRewardsTotal)
    }
}
