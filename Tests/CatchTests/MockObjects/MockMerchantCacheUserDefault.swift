//
//  File.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import XCTest
@testable import Catch

class MockMerchantCacheUserDefault: UserDefaults {
    var shouldExpire: Bool = false
    var merchantData: Data = Data()
    var persistedData: [String: Any] = [:]

    override func set(_ value: Any?, forKey key: String) {
        persistedData[key] = value
    }

    override func object(forKey key: String) -> Any? {
        if key.contains("Expiration") {
            let now = Date()
            return shouldExpire ? now.addingTimeInterval(-3600) : now.addingTimeInterval(3600 * 24)
        } else {
            return merchantData
        }
    }
}
