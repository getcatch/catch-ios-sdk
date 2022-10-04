//
//  URLComponents+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 9/13/22.
//

import UIKit

extension URLComponents {

    /**
     Creates and initializes a new URLComponents struct with the given scheme, host, path and query items.
     - Parameter scheme: The scheme subcomponent of the URL. `https` by default.
     - Parameter host: The host subcomponent.
     - Parameter path: The path subcomponent.
     - Parameter queryItems: An array of query parameters for the URL in the order in which they appear. `nil` by default.
     */
    init(scheme: String = "https",
         host: String,
         path: String,
         queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        self = components
    }

}
