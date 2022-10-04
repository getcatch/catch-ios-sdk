//
//  URLSession+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 9/13/22.
//

import UIKit

extension URLSession {

    func perform(_ request: URLRequest,
                 completionHandler: @escaping (Result<Data, Error>) -> Void) {

        dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                let error = NetworkError.serverError(.invalidResponse(response))
                completionHandler(.failure(error))
                return
            }

            completionHandler(.success(data))
        }.resume()

    }

}
