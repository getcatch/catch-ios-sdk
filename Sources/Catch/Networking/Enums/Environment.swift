//
//  Environment.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

/**
 The Environment enum represents the two distinct modes of the Catch iOS SDK: live and sandbox.

 Both modes generally provide the same functionality, but sandbox should be used for development and testing
 while live should be used in production applications.

 Applications should also ensure that the environment they use in the Catch iOS SDK lines up with the
 environments being used for Catch's Transaction APIs. For example, to open a given checkout in live mode,
 the checkout must have been created using Catch's Live Transaction API endpoint (and, for sandbox, the
 environments must be aligned as well).
 */
public enum Environment {
    /// The environment which should be used non-production environments (development, testing, etc).
    case sandbox
    /// The environment which should be used in production/live applications.
    case live

    var host: String {
        switch self {
        case .sandbox:
            return "app-sandbox.getcatch.com"
        case .live:
            return "app.getcatch.com"
        }
    }
}
