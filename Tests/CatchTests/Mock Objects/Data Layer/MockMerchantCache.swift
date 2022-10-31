//
//  MockMerchantCache.swift
//  
//
//  Created by Lucille Benoit on 10/12/22.
//

import XCTest
@testable import Catch

class MockMerchantCache: MerchantCacheInterface {
    let containsMerchant: Bool

    init(containsMerchant: Bool) {
        self.containsMerchant = containsMerchant
    }

    func get(from publicKey: String, completion: @escaping (Result<Merchant?, Error>) -> Void) {
        let merchant = containsMerchant ? MockDataProvider.defaultMerchant : nil
        completion(.success(merchant))
    }

    func save(merchant: Merchant, for publicKey: String) {
        return
    }

}
