//
//  WKWebView+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 11/15/22.
//

import WebKit

extension WKWebView {
    func evaluateScript(_ script: JSScript, completion: ((Result<Any?, Error>) -> Void)? = nil) {
        guard let scriptString = script.value else {
            return
        }
        evaluateJavaScript(scriptString) { (result, error) in
            if let error = error {
                completion?(.failure(error))
            } else if let result = result {
                completion?(.success(result))
            }
        }
    }
}
