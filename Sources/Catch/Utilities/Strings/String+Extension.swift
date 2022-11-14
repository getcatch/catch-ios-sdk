//
//  String+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 11/9/22.
//

import Foundation

extension String {
    var nonBreaking: String {
        return replacingOccurrences(of: " ", with: "\u{00a0}")
    }

    /**
     Simplifies subscripting a string using the following syntax s[3...]
     */
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}
