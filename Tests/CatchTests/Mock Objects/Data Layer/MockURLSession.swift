//
//  MockURLSession.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import XCTest
@testable import Catch

class MockURLSession: URLSession {

    var triggerError: Bool = false
    var returnData = try? MockDataProvider().merchant.encoded()

    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        if let url = request.url {
            if triggerError {
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

        completion(returnData, response, nil)
    }
}
