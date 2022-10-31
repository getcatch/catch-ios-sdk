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
                                   completion: @escaping (Result<EarnedReward, Error>) -> Void)
}

struct RewardsCalculatorNetworkService: RewardsCalculatorNetworkServiceInterface {
    var apiClient: APIClientInterface = APIClient()
    func getCalculateEarnedRewards(merchantId: String,
                                   queryItems: [URLQueryItem]?,
                                   completion: @escaping (Result<EarnedReward, Error>) -> Void) {
        let path = String(format: CatchURL.getEarnedRewards, merchantId)
        apiClient.fetchObject(path: path, queryItems: queryItems) { (result: Result<EarnedReward, Error>) in
            switch result {
            case .success(let earnedRewardsSummary):
                completion(.success(earnedRewardsSummary))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
