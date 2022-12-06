//
//  TransparentWebView.swift
//  Catch
//
//  Created by Lucille Benoit on 11/14/22.
//

import WebKit

/**
 A fullscreen, transparent background web view.
 */
class TransparentWebView: WKWebView {
    init(configuration: WKWebViewConfiguration) {
        // Initial size must be non-zero to prevent ViewportSizing error logs
        let initialSize = CGRect(x: 0, y: 0, width: 0.1, height: 0.1)
        super.init(frame: initialSize, configuration: configuration)
        allowsBackForwardNavigationGestures = false
        isOpaque = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
