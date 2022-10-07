//
//  NetworkError.swift
//  Catch
//
//  Created by Lucille Benoit on 9/13/22.
//

import UIKit

enum NetworkError: Swift.Error {
    enum RequestError {
        case invalidURL(URLComponents)
        case invalidRequest(URLRequest)
        case encodingError(Swift.EncodingError)
        case other(NSError)
    }

    enum ServerError {
        case decodingError(Swift.DecodingError)
        case invalidResponse(URLResponse?)
        case noInternetConnection
        case timeout
        case other(statusCode: Int?, response: HTTPURLResponse?)
    }

    case requestError(RequestError)
    case serverError(ServerError)
}