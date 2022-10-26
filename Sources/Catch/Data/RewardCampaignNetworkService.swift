//
//  RewardCampaignNetworkService.swift
//  Catch
//
//  Created by Lucille Benoit on 10/20/22.
//

import Foundation

protocol RewardCampaignNetworkServiceInterface {
    func fetchRewardCampaign(named campaignName: String,
                             publicKey: String, completion: @escaping (Result<RewardCampaign, Error>) -> Void)
}

struct RewardCampaignNetworkService: RewardCampaignNetworkServiceInterface {
    var apiClient: APIClientInterface = APIClient()
    func fetchRewardCampaign(named campaignName: String,
                             publicKey: String,
                             completion: @escaping (Result<RewardCampaign, Error>) -> Void) {
        let path = String(format: CatchURL.getRewardCampaignByExternalName, publicKey, campaignName)
        apiClient.fetchObject(path: path, queryItems: nil) { (result: Result<RewardCampaign, Error>) in
            switch result {
            case .success(let rewardCampaign):
                completion(.success(rewardCampaign))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
