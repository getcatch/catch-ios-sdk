//
//  MerchantNetworkServiceTests.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import XCTest
@testable import Catch

final class MerchantNetworkServiceTests: XCTestCase {

    func testValidPublicKey() {
        let validKey = "TEST_KEY"
        let mockAPIClient = MockAPIClient()
        let merchantNetworkService = MerchantNetworkService(apiClient: mockAPIClient)
        merchantNetworkService.fetchMerchant(withKey: validKey) { result in
            switch result {
            case .success(let merchant):
                XCTAssertEqual(merchant, MockDataProvider().merchant)
            case .failure:
                XCTFail("Request with valid public key should succeed and return merchant")
            }
        }
    }

    func testInvalidPublicKey() {
        let invalidKey = "INVALID_PUBLIC_KEY"
        let mockAPIClient = MockAPIClient()
        mockAPIClient.triggerFailure = true

        let merchantNetworkService = MerchantNetworkService(apiClient: mockAPIClient)

        merchantNetworkService.fetchMerchant(withKey: invalidKey) { result in
            switch result {
            case .success:
                XCTFail("Request with invalid public key should fail and return non-nil error")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}
