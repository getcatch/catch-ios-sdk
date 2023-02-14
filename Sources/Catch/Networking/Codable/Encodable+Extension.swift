//
//  Encodable+Extension.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

extension Encodable {

    func encoded(encodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) throws -> Data {
        return try APIEncoder(encodingStrategy: encodingStrategy).encode(self)
    }

    func toQueryItems(
        encodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    ) throws -> [URLQueryItem] {
        return try asDictionary(encodingStrategy: encodingStrategy).map { URLQueryItem(name: $0, value: "\($1)") }
    }

    func asDictionary(encodingStrategy: JSONEncoder.KeyEncodingStrategy) throws -> [String: Any] {
        let data = try self.encoded(encodingStrategy: encodingStrategy)
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: Any] else {
            throw NSError.init(domain: NSCocoaErrorDomain, code: NSCoderInvalidValueError)
        }

        return dictionary
    }

}
