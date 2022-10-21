//
//  KeyChainManager.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol KeyChainInterface {
    func saveString(_ string: String, forKey key: String) -> OSStatus?
    func loadString(forKey key: String) -> String?
}

/**
 A simple wrapper to save and load tokens from the KeyChain
 */
class KeyChainManager: KeyChainInterface {

    /**
     Saves a string with the specified key to the KeyChain.
     */
    func saveString(_ string: String, forKey key: String) -> OSStatus? {
        if let data = string.data(using: .utf8) {
            return save(key: key, data: data)
        }

        return nil
    }

    /**
     Loads a string with the specified key from the KeyChain if it exists.
     */
    func loadString(forKey key: String) -> String? {
        if let data = load(key: key) {
            return String(decoding: data, as: UTF8.self)
        }

        return nil
    }

    private func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    private func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr, let data = dataTypeRef as? Data? {
            return data
        } else {
            return nil
        }
    }
}
