//
//  MerchantRepository.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import Foundation

protocol MerchantRepositoryInterface {
    var merchantPublicKey: String? { get }
    func getCurrentMerchant() -> Merchant?
    func fetchMerchant(from merchantPublicKey: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class MerchantRepository: MerchantRepositoryInterface {

    internal var merchantPublicKey: String?
    private var merchant: Merchant? {
        didSet {
            if oldValue != merchant {
                notificationCenter.post(name: NotificationName.merchantUpdate, object: merchant)
            }
        }
    }

    private let networkService: MerchantNetworkServiceInterface
    private let cache: MerchantCacheInterface
    private let notificationCenter: NotificationCenter

    init(networkService: MerchantNetworkServiceInterface,
         cache: MerchantCacheInterface,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.networkService = networkService
        self.cache = cache
        self.notificationCenter = notificationCenter
    }

    func getCurrentMerchant() -> Merchant? {
        return merchant
    }

    func fetchMerchant(from merchantPublicKey: String,
                       completion: @escaping (Result<Bool, Error>) -> Void) {
        self.merchantPublicKey = merchantPublicKey
        cache.get(from: merchantPublicKey) { [weak self] result in
            if case let .success(merchant?) = result {
                self?.merchant = merchant
                completion(.success(true))
                return
            }

            self?.networkService.fetchMerchant(withKey: merchantPublicKey) { [weak self] result in

                switch result {
                case .success(let merchant):
                    guard let self = self else { return }
                    self.cache.save(merchant: merchant, for: merchantPublicKey)
                    self.merchant = merchant
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
