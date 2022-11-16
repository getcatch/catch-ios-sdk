//
//  WebViewConfiguration.swift
//  Catch
//
//  Created by Lucille Benoit on 11/15/22.
//

import WebKit

class WebViewConfiguration: WKWebViewConfiguration {
    convenience init(scriptMessageHandler: WKScriptMessageHandler, name: String) {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let userController = WKUserContentController()
        userController.add(scriptMessageHandler, name: name)

        self.init()
        self.preferences = preferences
        self.userContentController = userController
    }
}
