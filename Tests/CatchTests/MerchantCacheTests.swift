//
//  MerchantCacheTests.swift
//  
//
//  Created by Lucille Benoit on 10/5/22.
//

import XCTest
@testable import Catch

final class MerchantCacheTests: XCTestCase {
    let dataProvider = MockDataProvider()
    let publicKey = "TEST_PUBLIC_KEY"

    func testSavingMerchantData() {
        let now = Date()
        let mockUserDefaults = MockMerchantCacheUserDefault()
        let merchantCache = MerchantCache(cache: mockUserDefaults)

        let merchant = dataProvider.merchant

        merchantCache.save(merchant: merchant, for: publicKey)

        let persistedData = mockUserDefaults.persistedData

        let merchantData = persistedData[publicKey] as? Data
        let encodedMerchant = try? merchant.encoded()
        XCTAssertEqual(encodedMerchant, merchantData, "Merchant data should match the merchant that was passed in.")

        let expirationKey = String(format: merchantCache.merchantCacheExpirationFormat, publicKey)
        let expirationDate = persistedData[expirationKey] as? Date

        XCTAssertNotNil(expirationDate, "Expiration date should not be nil")

        if let expiration = expirationDate {
            XCTAssertLessThan(now, expiration, "Expiration date should be sometime in the future")
        }
    }

    func testGetExpiredMerchant() {
        let merchant = dataProvider.merchant
        let merchantCache = createMerchantCache(merchantToBeCached: merchant, shouldBeExpired: true)

        merchantCache.get(from: publicKey) { result in
            switch result {
            case .success(let merchant):
                XCTAssertNil(merchant, "Merchant should be nil since the cache is expired")
            case .failure:
                XCTFail("Get expired merchant from cache should not fail")
            }
        }
    }

    func testGetValidMerchant() {
        let merchant = dataProvider.merchant
        let merchantCache = createMerchantCache(merchantToBeCached: merchant, shouldBeExpired: false)

        merchantCache.get(from: publicKey) { result in
            switch result {
            case .success(let cachedMerchant):
                XCTAssertEqual(cachedMerchant, merchant, "Merchant returned should match mock merchant")
            case .failure:
                XCTFail("Get merchant from cache should not fail")
            }
        }
    }

    private func createMerchantCache(merchantToBeCached: Merchant, shouldBeExpired: Bool) -> MerchantCache {
        let mockUserDefaults = MockMerchantCacheUserDefault()
        mockUserDefaults.shouldExpire = shouldBeExpired
        mockUserDefaults.merchantData = try? merchantToBeCached.encoded()

        return MerchantCache(cache: mockUserDefaults)
    }
}
