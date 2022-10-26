//
//  MockRewardsCalculatorNetworkService.swift
//  
//
//  Created by Lucille Benoit on 10/26/22.
//

import XCTest
@testable import Catch

class MockRewardsCalculatorNetworkService: RewardsCalculatorNetworkServiceInterface {
    private var targetRewardSummary: EarnedRewardsSummary?

    init(targetRewardSummary: EarnedRewardsSummary?) {
        self.targetRewardSummary = targetRewardSummary
    }

    func getCalculateEarnedRewards(merchantId: String,
                                   queryItems: [URLQueryItem]?,
                                   completion: @escaping (Result<EarnedRewardsSummary, Error>) -> Void) {
        guard let rewardSummary = targetRewardSummary else {
            completion(.failure(NetworkError.requestError(.noPublicUserData)))
            return
        }

        completion(.success(rewardSummary))

    }

}
