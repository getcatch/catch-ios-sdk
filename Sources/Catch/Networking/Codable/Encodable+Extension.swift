//
//  Encodable+Extension.swift
//  
//
//  Created by Lucille Benoit on 9/13/22.
//

import Foundation

extension Encodable {

    func encoded() throws -> Data {
        return try APIEncoder().encode(self)
    }

}
