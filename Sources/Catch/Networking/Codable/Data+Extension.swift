//
//  Data+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

extension Data {
    /**
     Decodes the JSON representation of Data into an inferred type.
     */
    func decoded<T: Decodable>() throws -> T {
        let decoder = APIDecoder()
        let result = try decoder.decode(T.self, from: self)
        return result
    }

}
