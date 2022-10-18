//
//  MockMerchantURLSession.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import XCTest
@testable import Catch

class MockMerchantURLSession: URLSession {
    private var invalidPublicKey: String?

    private let merchantData = try? MockDataProvider().merchant.encoded()

    /**
     Sets an invalid public key which will trigger a 404 error
     */
    func setInvalidPublicKey(key: String) {
        invalidPublicKey = key
    }

    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        if let url = request.url {
            if let invalidKey = invalidPublicKey, url.absoluteString.contains(invalidKey) {
                mockErrorResponse(url: url, completion: completionHandler)
            } else {
                mockSuccessResponse(url: url, completion: completionHandler)
            }
        }

        return URLSession.shared.dataTask(with: request)
    }

    private func mockErrorResponse(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let response = HTTPURLResponse(url: url,
                                       statusCode: 404,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: nil)
        let error = NetworkError.serverError(.invalidResponse(response))

        completion(nil, response, error)
    }

    private func mockSuccessResponse(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: nil)

        completion(merchantData, response, nil)
    }
}
