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

    private let userData: PublicUserData

    init(userOverride: PublicUserData = MockDataProvider.publicUserDataReturning) {
        self.userData = userOverride
    }

    func getCurrentUser() -> PublicUserData? {
        return userData
    }

    func getDeviceToken() -> String? {
        return "test_device_token"
    }

    func saveDeviceToken(_ token: String) { }

    func fetchUserData(merchantId: String, completion: @escaping (Result<PublicUserData, Error>) -> Void) {
        didFetchUserData = true
        completion(.success(userData))
    }

}
