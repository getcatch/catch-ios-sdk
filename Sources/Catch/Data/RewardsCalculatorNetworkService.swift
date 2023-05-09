//
//  RewardsCalculatorNetworkService.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol RewardsCalculatorNetworkServiceInterface {
    func getCalculateEarnedRewards(merchantId: String,
                                   queryItems: [URLQueryItem]?,
                                   completion: @escaping (Result<EarnedRewardsSummary, Error>) -> Void)
    func getWidgetContent(merchantID: String,
                          queryItems: [URLQueryItem]?,
                          completion: @escaping (Result<WidgetContent, Error>) -> Void)
}

struct RewardsCalculatorNetworkService: RewardsCalculatorNetworkServiceInterface {
    var apiClient: APIClientInterface = APIClient()

    func getCalculateEarnedRewards(merchantId: String,
                                   queryItems: [URLQueryItem]?,
                                   completion: @escaping (Result<EarnedRewardsSummary, Error>) -> Void) {
        let path = String(format: CatchURL.getEarnedRewards, merchantId)
        apiClient.fetchObject(path: path, queryItems: queryItems, completion: completion)
    }

    func getWidgetContent(merchantID: String,
                          queryItems: [URLQueryItem]?,
                          completion: @escaping (Result<WidgetContent, Error>) -> Void) {
        let path = String(format: CatchURL.getWidgetContent, merchantID)
        apiClient.fetchObject(path: path, queryItems: queryItems, completion: completion)
    }
}
