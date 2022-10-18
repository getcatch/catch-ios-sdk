//
//  MerchantRepository.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import Foundation

protocol MerchantRepositoryInterface {
    func getCurrentMerchant() -> Merchant?
    func fetchMerchant(from merchantPublicKey: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class MerchantRepository: MerchantRepositoryInterface {

    private var merchantPublicKey: String?
    private var merchant: Merchant? {
        didSet {
            if oldValue != merchant {
                NotificationCenter.default.post(name: Notification.Name(NotificationName.merchantUpdate), object: nil)
            }
        }
    }

    private let networkService: MerchantNetworkServiceInterface
    private let cache: MerchantCacheInterface

    init(networkService: MerchantNetworkServiceInterface, cache: MerchantCacheInterface) {
        self.networkService = networkService
        self.cache = cache
    }

    func getCurrentMerchant() -> Merchant? {
        return merchant
    }

    func fetchMerchant(from merchantPublicKey: String,
                       completion: @escaping (Result<Bool, Error>) -> Void) {
        cache.get(from: merchantPublicKey) { [weak self] result in
            if case let .success(merchant?) = result {
                self?.merchant = merchant
                completion(.success(true))
                return
            }

            self?.networkService.get(from: merchantPublicKey) { [weak self] result in

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
