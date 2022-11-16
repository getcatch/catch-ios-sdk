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

    func toQueryItems() throws -> [URLQueryItem] {
        return try asDictionary().map { URLQueryItem(name: $0, value: "\($1)") }
    }

    private func asDictionary() throws -> [String: Any] {
        let data = try self.encoded()
        guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }

        return dictionary
    }

}
