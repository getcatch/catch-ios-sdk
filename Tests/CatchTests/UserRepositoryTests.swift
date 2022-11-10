//
//  UserRepositoryTests.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import XCTest
@testable import Catch

final class UserRepositoryTests: XCTestCase {
    let testMerchantId = "merchantID"
    let testDeviceToken = "deviceToken"

    func testGetUserDataSuccess() {
        let notificationCenter = MockNotificationCenter()
        let repository = createUserRepository(shouldFindUser: true, notificationCenter: notificationCenter)

        var currentUser = repository.getCurrentUser()
        XCTAssertNil(currentUser, "Current user should be nil before user is fetched")

        repository.saveDeviceToken(testDeviceToken)
        repository.fetchUserData(merchantId: testMerchantId)

        let testCurrentUserData = MockDataProvider.publicUserDataReturning

        currentUser = repository.getCurrentUser()
        XCTAssertEqual(currentUser, testCurrentUserData, "Current user should match the test user data")
        XCTAssertTrue(notificationCenter.didPostNotifcation(with: NotificationName.publicUserDataUpdate))
    }

    func testGetUserDataFailure() {
        let notificationCenter = MockNotificationCenter()
        let repository = createUserRepository(shouldFindUser: false, notificationCenter: notificationCenter)

        var currentUser = repository.getCurrentUser()
        XCTAssertNil(currentUser, "Current user should be nil before user is fetched")

        repository.saveDeviceToken(testDeviceToken)
        repository.fetchUserData(merchantId: testMerchantId)

        currentUser = repository.getCurrentUser()
        // If no user is found, the current user should be set to "no data"
        XCTAssertEqual(currentUser, PublicUserData.noData)
        XCTAssertTrue(notificationCenter.didPostNotifcation(with: NotificationName.publicUserDataUpdate))
    }

    func testGetUserWithNoDeviceToken() {
        let notificationCenter = MockNotificationCenter()
        let repository = createUserRepository(shouldFindUser: false, notificationCenter: notificationCenter)

        let deviceToken = repository.getDeviceToken()
        XCTAssertNil(deviceToken, "Device token should be nil but instead was \(String(describing: deviceToken))")

        repository.fetchUserData(merchantId: testMerchantId) { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error as? NetworkError,
                                "Fetching user data with no device token should throw a network error")
            case .success:
                XCTFail("Expected user data fetch to fail")
            }
        }

        // In the case of no device token,
        // we should still post a notification signalling that user data fetch has completed.
        XCTAssertTrue(notificationCenter.didPostNotifcation(with: NotificationName.publicUserDataUpdate))
    }

    func testGetUserDeviceToken() {
        let notificationCenter = MockNotificationCenter()
        let repository = createUserRepository(notificationCenter: notificationCenter)
        var keyChainToken = repository.getDeviceToken()
        XCTAssertNil(keyChainToken, "No token should exist in the KeyChain before token is set")

        repository.saveDeviceToken(testDeviceToken)
        keyChainToken = repository.getDeviceToken()
        XCTAssertEqual(keyChainToken, testDeviceToken, "Device token found in KeyChain should match test device token")
    }

    private func createUserRepository(shouldFindUser: Bool = true,
                                      notificationCenter: NotificationCenter) -> UserRepository {

        let keyChain = MockKeyChain()
        let networkService = MockUserNetworkService(shouldFindUser: shouldFindUser)
        return UserRepository(networkService: networkService,
                              keyChain: keyChain,
                              notificationCenter: notificationCenter)
    }
}
