//
//  MerchantNetworkService.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import Foundation

protocol MerchantNetworkServiceInterface {
    func get(from publicKey: String, completion: @escaping (Result<Merchant, Error>) -> Void)
}

struct MerchantNetworkService: MerchantNetworkServiceInterface {
    var session = URLSession.shared

    func get(from publicKey: String, completion: @escaping (Result<Merchant, Error>) -> Void) {
        let path = String(format: CatchURL.getPublicMerchantData, publicKey)
        let components = URLComponents(path: path)
        if let request = try? URLRequest(components: components) {
            session.perform(request) { result in
                switch result {
                case .success(let data):
                    do {
                        let merchant: Merchant = try data.decoded()
                        completion(.success(merchant))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure:
                    completion(.failure(NetworkError.requestError(.invalidPublicKey(publicKey))))
                }
            }
        }
    }
}
