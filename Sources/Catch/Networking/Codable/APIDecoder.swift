//
//  APIDecoder.swift
//  Catch
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

class APIDecoder: JSONDecoder {

    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .iso8601
    }

}
