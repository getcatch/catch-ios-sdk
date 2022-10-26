//
//  MockUserNetworkService.swift
//
//
//  Created by Lucille Benoit on 10/18/22.
//

import XCTest
@testable import Catch

class MockUserNetworkService: UserNetworkServiceInterface {
    private let shouldFindUser: Bool

    init(shouldFindUser: Bool) {
        self.shouldFindUser = shouldFindUser
    }

    func fetchUserData(deviceToken: String,
                       merchantId: String,
                       completion: @escaping (Result<PublicUserData, Error>) -> Void) {
        if shouldFindUser {
            completion(.success(MockDataProvider.publicUserDataReturning))
        } else {
            completion(.failure(NetworkError.serverError(.invalidResponse(nil))))
        }
    }

}
