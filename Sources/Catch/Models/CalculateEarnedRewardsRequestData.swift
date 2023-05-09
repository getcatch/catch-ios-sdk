//
//  CalculateEarnedRewardsRequestData.swift
//  Catch
//
//  Created by Lucille Benoit on 4/19/23.
//

import Foundation

struct CalculateEarnedRewardRequestData {
    let price: Int
    let items: [Item]?
    let userCohorts: [String]?

    /**
     Generates query params for the `/calculate` endpoint
     */
    func generateQueryParams(publicUserData: WidgetContentPublicUserData?) -> [URLQueryItem] {
        let userData = publicUserData ?? WidgetContentPublicUserData.noData
        let userRewardAmount = userData.rewardAmount ?? 0
        let amount = max(price - userRewardAmount, 0)

        var calculateEarnedRewardsQuery = CalculateEarnedRewardsQuery(
            amountEligibleForEarnedRewards: amount,
            isNewCatchUser: userData.firstPurchaseBonusEligibility
        )

        // Convert items and userCohorts to comma separated strings
        if let items = items, !items.isEmpty {
            calculateEarnedRewardsQuery.items = items.map { $0.queryString }.joined(separator: ",")
        }

        if let userCohorts = userCohorts, !userCohorts.isEmpty {
            calculateEarnedRewardsQuery.userCohorts = userCohorts.joined(separator: ",")
        }

        let queryItems = try? calculateEarnedRewardsQuery.toQueryItems()

        return queryItems ?? []
    }

    /**
     Generates query params for the `/widget_content` endpoint.
     */
    func generateWidgetContentQueryParams(deviceToken: String?, enableConfigurableRewards: Bool) -> [URLQueryItem] {
        let itemsAsStrings = items?.map { $0.queryString }
        let query = WidgetContentQuery(deviceToken: deviceToken ?? String(),
                                       items: itemsAsStrings,
                                       orderTotal: price,
                                       useConfigurableRewards: enableConfigurableRewards,
                                       userCohorts: userCohorts)
        let queryItems = try? query.toQueryItems()

        return queryItems ?? []
    }
}
