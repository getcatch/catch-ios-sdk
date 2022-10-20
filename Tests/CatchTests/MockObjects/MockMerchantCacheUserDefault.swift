//
//  MockMerchantCacheUserDefault.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import XCTest
@testable import Catch

class MockMerchantCacheUserDefault: UserDefaults {
    var shouldExpire: Bool = false
    var merchantData: Data? = Data()
    var persistedData: [String: Any] = [:]

    override func set(_ value: Any?, forKey defaultName: String) {
        persistedData[defaultName] = value
    }

    override func object(forKey defaultName: String) -> Any? {
        let now = Date()
        return shouldExpire ? now.addingTimeInterval(-3600) : now.addingTimeInterval(3600 * 24)
    }

    override func data(forKey defaultName: String) -> Data? {
        return merchantData
    }

}
