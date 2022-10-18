//
//  MerchantCache.swift
//  
//
//  Created by Lucille Benoit on 10/5/22.
//

import Foundation

protocol MerchantCacheInterface {
    func get(from publicKey: String, completion: @escaping (Result<Merchant?, Error>) -> Void)
    func save(merchant: Merchant, for publicKey: String)
}

struct MerchantCache: MerchantCacheInterface {

    let merchantCacheExpirationFormat = "CacheExpirationDate: %@"
    let merchantCacheTime: Double = 3600 * 2 // cache merchant information for two hours

    var cache: UserDefaults = UserDefaults.standard

    /**
     Gets cached Merchant data associated with the given public key.
     If the cache is expired, this will clear the merchant data and return a nil Merchant.
     */
    func get(from publicKey: String, completion: @escaping (Result<Merchant?, Error>) -> Void) {

        if merchantCacheIsExpired(for: publicKey) {
            clearMechantCache(for: publicKey)
            completion(.success(nil))
            return
        }

        if let data = UserDefaults.standard.data(forKey: publicKey) {
            do {
                let merchant: Merchant = try data.decoded()
                completion(.success(merchant))
            } catch {
                completion(.failure(error))
                Logger().log(error: error)
            }
        } else {
            completion(.success(nil))
        }
    }

    /**
     Caches the Merchant data associated with the given public key and sets cache to expire in two hours.
     */
    func save(merchant: Merchant, for publicKey: String) {
        do {
            let data = try merchant.encoded()
            let expirationDate = NSDate(timeIntervalSinceNow: merchantCacheTime)

            cache.setValue(data, forKey: publicKey)
            cache.setValue(expirationDate, forKey: expirationKey(for: publicKey))
        } catch {
            Logger().log(error: error)
        }
    }

    private func merchantCacheIsExpired(for publicKey: String) -> Bool {
        let now = Date()
        if let expirationDate = cache.object(forKey: expirationKey(for: publicKey)) as? Date,
           expirationDate < now {
            return true
        }
        return false
    }

    private func clearMechantCache(for publicKey: String) {
        cache.removeObject(forKey: publicKey)
        cache.removeObject(forKey: expirationKey(for: publicKey))
    }

    private func expirationKey(for publicKey: String) -> String {
        return String(format: merchantCacheExpirationFormat, publicKey)
    }
}
