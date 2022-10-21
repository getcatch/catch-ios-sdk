//
//  MerchantNetworkService.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import Foundation

protocol MerchantNetworkServiceInterface {
    func fetchMerchant(withKey publicKey: String, completion: @escaping (Result<Merchant, Error>) -> Void)
}

struct MerchantNetworkService: MerchantNetworkServiceInterface {
    var apiClient: APIClientInterface = APIClient()

    func fetchMerchant(withKey publicKey: String,
                       completion: @escaping (Result<Merchant, Error>) -> Void) {
        let path = String(format: CatchURL.getPublicMerchantData, publicKey)

        apiClient.fetchObject(path: path, queryItems: nil) { (result: Result<Merchant, Error>) in
            switch result {
            case .success(let merchant):
                completion(.success(merchant))
            case .failure:
                completion(.failure(NetworkError.requestError(.invalidPublicKey(publicKey))))
            }
        }
    }
}
