//
//  TextTransform.swift
//  
//
//  Created by Lucille Benoit on 10/6/22.
//

import Foundation

/**
 Text transformation used to capitalize, lowercase or uppercase a string.
 */
public enum TextTransform {
    /// Capitalizes every first character in the string (ex. "Test String").
    case capitalize

    /// Lowercases the entire string (ex. "test string").
    case lowercase

    /// Uppercases the entrie string (ex. "TEST STRING").
    case uppercase

    /// Leaves the string in its original form.
    case none

    internal func transform(_ text: String) -> String {
        switch self {
        case .capitalize:
            return text.capitalized
        case .lowercase:
            return text.lowercased()
        case .uppercase:
            return text.uppercased()
        case .none:
            return text
        }
    }
}
