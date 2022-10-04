//
//  Environment.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

public enum Environment {
    case sandbox
    case production

    var host: String {
        switch self {
        case .sandbox:
            return "app-sandbox.getcatch.com"
        case .production:
            return "app.getcatch.com"
        }
    }
}
