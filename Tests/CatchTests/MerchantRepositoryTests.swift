//
//  MerchantRepositoryTests.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import XCTest
@testable import Catch

final class MerchantRepositoryTests: XCTestCase {

    let testPublicKey = "TEST_KEY"

    func testFetchMerchantFromCache() {
        let notificationCenter = MockNotificationCenter()
        let repository = createMerchantRepository(merchantIsCached: false,
                                                  merchantIsFoundOnNetwork: true,
                                                  notificationCenter: notificationCenter)

        let currentMerchant = repository.getCurrentMerchant()
        XCTAssertNil(currentMerchant, "Current merchant should be nil before merchant is fetched")

        repository.fetchMerchant(from: testPublicKey) { result in
            if case let .success(succeeded) = result {
                XCTAssertTrue(succeeded)
                let currentMerchant = repository.getCurrentMerchant()
                XCTAssertNotNil(currentMerchant, "Current merchant should be returned after merchant is fetched")
                XCTAssertTrue(notificationCenter.didPostNotifcation(with: NotificationName.merchantUpdate))
            } else {
                XCTFail("Merchant should be returned since merchant exists in cache")
            }
        }
    }

    func testFetchMerchantFromNetwork() {
        let notificationCenter = MockNotificationCenter()
        let repository = createMerchantRepository(merchantIsCached: false,
                                                  merchantIsFoundOnNetwork: true,
                                                  notificationCenter: notificationCenter)

        repository.fetchMerchant(from: testPublicKey) { result in
            if case let .success(succeeded) = result {
                XCTAssertTrue(succeeded)
                let currentMerchant = repository.getCurrentMerchant()
                XCTAssertNotNil(currentMerchant, "Current merchant should be returned after merchant is fetched")
                XCTAssertTrue(notificationCenter.didPostNotifcation(with: NotificationName.merchantUpdate))
            } else {
                XCTFail("Merchant should be returned since merchant exists on network")
            }
        }
    }

    func testFetchMerchantNotFoundAnywhere() {
        let notificationCenter = MockNotificationCenter()
        let repository = createMerchantRepository(merchantIsCached: false,
                                                  merchantIsFoundOnNetwork: false,
                                                  notificationCenter: notificationCenter)

        repository.fetchMerchant(from: testPublicKey) { result in
            if case .failure = result {
                XCTAssertFalse(notificationCenter.didPostNotifcation(),
                               "No notifications should be sent in case of failure")
            } else {
                XCTFail("No merchant should be returned since merchant doesn't exist in cache or network")
            }
        }
    }

    private func createMerchantRepository(merchantIsCached: Bool,
                                          merchantIsFoundOnNetwork: Bool,
                                          notificationCenter: NotificationCenter) -> MerchantRepository {

        let cache = MockMerchantCache(containsMerchant: merchantIsCached)
        let networkService = MockMerchantNetworkService(containsMerchant: merchantIsFoundOnNetwork)
        return MerchantRepository(networkService: networkService, cache: cache, notificationCenter: notificationCenter)
    }
}
