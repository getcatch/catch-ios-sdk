//
//  NetworkingTests.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import XCTest
@testable import Catch

class NetworkingTests: XCTestCase {

    func testEnvironmentHosts() throws {
        XCTAssertEqual(Environment.production.host, "app.getcatch.com")
        XCTAssertEqual(Environment.sandbox.host, "app-sandbox.getcatch.com")
    }

    func testRequestConstruction() {
        let host = Environment.production.host
        let path = "/api/merchants-svc/merchants"

        let queryKey = "merchant_id"
        let queryValue = "test_id"

        let queryItems = [
            URLQueryItem(name: queryKey, value: queryValue)
        ]

        let components = URLComponents(host: host, path: path, queryItems: queryItems)
        let httpMethod: HTTPMethod = .post
        let request = try? URLRequest(components: components, httpMethod: httpMethod)

        XCTAssertEqual(request?.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertEqual(request?.allHTTPHeaderFields, [HTTPHeader.contentType.rawValue: "application/json"])

        let targetURLString = "https://\(host)\(path)?\(queryKey)=\(queryValue)"
        XCTAssertEqual(request?.url, URL(string: targetURLString))
    }

}
