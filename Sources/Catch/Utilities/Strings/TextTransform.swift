//
//  TextTransform.swift
//  
//
//  Created by Lucille Benoit on 10/6/22.
//

import Foundation

public enum TextTransform {
    case capitalize
    case lowercase
    case uppercase
    case none

    func transform(_ text: String) -> String {
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
