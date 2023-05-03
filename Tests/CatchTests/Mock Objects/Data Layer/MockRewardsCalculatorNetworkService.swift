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
    private var targetUserData: WidgetContentPublicUserData?

    init(targetRewardSummary: EarnedRewardsSummary?, targetUserData: WidgetContentPublicUserData? = nil) {
        self.targetRewardSummary = targetRewardSummary
        self.targetUserData = targetUserData
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

    func getWidgetContent(merchantID: String, queryItems: [URLQueryItem]?,
                          completion: @escaping (Result<Catch.WidgetContent, Error>) -> Void) {
        guard let userData = targetUserData else {
            completion(.failure(NetworkError.requestError(.noPublicUserData)))
            return
        }
        let widgetContent = MockDataProvider.mockWidgetContent(rewardsSummary: targetRewardSummary,
                                                               publicUserData: userData)
        completion(.success(widgetContent))
    }

}
