//
//  UserNetworkService.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol UserNetworkServiceInterface {
    func fetchUserData(deviceToken: String,
                       merchantId: String,
                       completion: @escaping (Result<PublicUserData, Error>) -> Void)
}

struct UserNetworkService: UserNetworkServiceInterface {
    var apiClient: APIClientInterface = APIClient()

    func fetchUserData(deviceToken: String,
                       merchantId: String,
                       completion: @escaping (Result<PublicUserData, Error>) -> Void) {
        let path = String(format: CatchURL.getPublicUserData, deviceToken)
        let queryItems = [
            URLQueryItem(name: Constant.merchantIdKey, value: merchantId)
        ]

        apiClient.fetchObject(path: path, queryItems: queryItems, completion: completion)
    }
}
