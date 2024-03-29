//
//  MockMerchantNetworkService.swift
//  
//
//  Created by Lucille Benoit on 10/18/22.
//

import XCTest
@testable import Catch

class MockMerchantNetworkService: MerchantNetworkServiceInterface {
    let containsMerchant: Bool

    init(containsMerchant: Bool) {
        self.containsMerchant = containsMerchant
    }

    func fetchMerchant(withKey publicKey: String, completion: @escaping (Result<Merchant, Error>) -> Void) {
        if containsMerchant {
            let merchant = MockDataProvider.defaultMerchant
            completion(.success(merchant))
        } else {
            completion(.failure(NetworkError.serverError(.invalidResponse(nil))))
        }
    }

}
