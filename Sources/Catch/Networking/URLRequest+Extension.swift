//
//  URLRequest+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 9/13/22.
//

import UIKit

extension URLRequest {

    init(components: URLComponents,
         httpMethod: HTTPMethod = .get,
         headers: [HTTPHeader: String] = [.contentType: "application/json"],
         body: Data? = nil) throws {

        guard let url = components.url else {
            throw NetworkError.requestError(.invalidURL(components))
        }

        self = Self(url: url)

        headers.forEach { key, value in
            addValue(value, forHTTPHeaderField: key.rawValue)
        }

        self.httpMethod = httpMethod.rawValue

        if let body = body {
            httpBody = try body.encoded()
        }
    }

}
