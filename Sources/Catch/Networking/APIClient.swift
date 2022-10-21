//
//  APIClient.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol APIClientInterface {

    func fetchObject<T: Decodable>(path: String,
                                   queryItems: [URLQueryItem]?,
                                   completion: @escaping (Result<T, Error>) -> Void)
}

struct APIClient: APIClientInterface {

    var session = URLSession.shared

    func fetchObject<T: Decodable>(path: String,
                                   queryItems: [URLQueryItem]?,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        let components = URLComponents(path: path, queryItems: queryItems)
        if let request = try? URLRequest(components: components) {
            session.perform(request) { result in
                switch result {
                case .success(let data):
                    do {
                        let object: T = try data.decoded()
                        completion(.success(object))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
