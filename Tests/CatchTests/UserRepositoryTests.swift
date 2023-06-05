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
        XCTAssertNil(currentUser, "Current user should be nil before user is stored")

        repository.saveDeviceToken(testDeviceToken, override: false)

        let testCurrentUserData = MockDataProvider.publicUserDataReturning
        repository.saveUserData(testCurrentUserData)

        currentUser = repository.getCurrentUser()
        XCTAssertEqual(currentUser, testCurrentUserData, "Current user should match the test user data")
        XCTAssertTrue(notificationCenter.didPostNotifcation(with: NotificationName.deviceTokenUpdate))
    }

    func testGetUserDeviceToken() {
        let notificationCenter = MockNotificationCenter()
        let repository = createUserRepository(notificationCenter: notificationCenter)
        var keyChainToken = repository.getDeviceToken()
        XCTAssertNil(keyChainToken, "No token should exist in the KeyChain before token is set")

        repository.saveDeviceToken(testDeviceToken, override: false)
        keyChainToken = repository.getDeviceToken()
        XCTAssertEqual(keyChainToken, testDeviceToken, "Device token found in KeyChain should match test device token")
    }

    private func createUserRepository(shouldFindUser: Bool = true,
                                      notificationCenter: NotificationCenter) -> UserRepository {

        let keyChain = MockKeyChain()
        return UserRepository(keyChain: keyChain,
                              notificationCenter: notificationCenter)
    }
}
