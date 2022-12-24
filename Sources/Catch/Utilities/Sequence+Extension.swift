//
//  Sequence+Extension.swift
//  
//
//  Created by Lucille Benoit on 12/23/22.
//

import Foundation

extension Sequence {
    // Sum of a property across objects in an array (ex. arr.sum(\.amount))
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
