//
//  MockAPIClient.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import XCTest
@testable import Catch

class MockAPIClient: APIClientInterface {

    var triggerFailure: Bool = false
    var returnObject: Any = MockDataProvider().merchant

    func fetchObject<T>(path: String,
                        queryItems: [URLQueryItem]?,
                        completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        if !triggerFailure, let result = returnObject as? T {
            completion(.success(result))
        } else {
            completion(.failure(NetworkError.serverError(.invalidResponse(nil))))
        }
    }

}
