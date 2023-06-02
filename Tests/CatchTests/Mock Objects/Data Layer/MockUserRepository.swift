//
//  MockUserRepository.swift
//  
//
//  Created by Lucille Benoit on 10/26/22.
//

import XCTest
@testable import Catch

class MockUserRepository: UserRepositoryInterface {

    var didFetchUserData: Bool = false

    private var userData: WidgetContentPublicUserData?

    init(userOverride: WidgetContentPublicUserData? = MockDataProvider.publicUserDataReturning) {
        self.userData = userOverride
    }

    func getCurrentUser() -> WidgetContentPublicUserData? {
        return userData
    }

    func saveUserData(_ widgetUserData: Catch.WidgetContentPublicUserData) {
        userData = widgetUserData
    }

    func getDeviceToken() -> String? {
        return "test_device_token"
    }

    func saveDeviceToken(_ token: String, override: Bool) {}

}
