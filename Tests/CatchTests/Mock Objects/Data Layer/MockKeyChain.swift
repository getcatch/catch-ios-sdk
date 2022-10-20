//
//  MockKeyChain.swift
//
//
//  Created by Lucille Benoit on 10/19/22.
//

import XCTest
@testable import Catch

class MockKeyChain: KeyChainInterface {
    private var savedKeyChainItems: [String: String] = [:]

    func saveString(_ string: String, forKey key: String) -> OSStatus? {
        savedKeyChainItems[key] = string
        return OSStatus(0)
    }

    func loadString(forKey key: String) -> String? {
        return savedKeyChainItems[key]
    }

}
