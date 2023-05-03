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
    let donationRecipient: DonationRecipient?
    let path: String
    let publicUserData: WidgetContentPublicUserData

    // Because the Tofu post message requires mixed snake case and camel case params,
    // the different fields must be encoded separately.
    private var availableRewardsBreakdownDict: [String: Any]? {
        return try? generateAvailableRewardsBreakdown().asDictionary(encodingStrategy: .useDefaultKeys)
    }

    private var earnedRewardsBreakdownDict: [String: Any]? {
        return try? earnedRewardsBreakdown.asDictionary(encodingStrategy: .convertToSnakeCase)
    }

    private var merchantDefaultsDict: [String: Any]? {
        return try? merchantDefaults.asDictionary(encodingStrategy: .useDefaultKeys)
    }

    private var publicUserDataDict: [String: Any]? {
        return try? publicUserData.asDictionary(encodingStrategy: .convertToSnakeCase)
    }

    private var donationRecipientDict: [String: Any]? {
        return try? donationRecipient?.asDictionary(encodingStrategy: .convertToSnakeCase)
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
        self.donationRecipient = merchant.donationRecipient
        self.publicUserData = publicUserData
        self.path = path.rawValue
    }

    func toDict() -> [String: Any?] {
        return [
            "earnedRewardsBreakdown": earnedRewardsBreakdownDict,
            "price": String(price),
            "merchantDefaults": merchantDefaultsDict,
            "donationRecipient": donationRecipientDict,
            "availableRewardsBreakdown": availableRewardsBreakdownDict,
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
