//
//  MockMerchantRepository.swift
//  
//
//  Created by Lucille Benoit on 10/26/22.
//

import XCTest
@testable import Catch

class MockMerchantRepository: MerchantRepositoryInterface {
    func getCurrentMerchant() -> Merchant? {
        MockDataProvider.defaultMerchant
    }

    func fetchMerchant(from merchantPublicKey: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }

}
