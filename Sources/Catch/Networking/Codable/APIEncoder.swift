//
//  APIEncoder.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

class APIEncoder: JSONEncoder {

    override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
        dateEncodingStrategy = .iso8601
    }

}
