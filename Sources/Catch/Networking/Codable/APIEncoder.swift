//
//  APIEncoder.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

class APIEncoder: JSONEncoder {

    convenience init(encodingStrategy: KeyEncodingStrategy = .convertToSnakeCase) {
        self.init()
        keyEncodingStrategy = encodingStrategy
        outputFormatting = .sortedKeys
        dateEncodingStrategy = .iso8601
    }

}
