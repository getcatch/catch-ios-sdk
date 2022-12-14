//
//  CatchWebView.swift
//  Catch
//
//  Created by Lucille Benoit on 11/14/22.
//

import WebKit

/**
 A fullscreen web view which can be made transparent to display modals.
 */
class CatchWebView: WKWebView {
    let isTransparent: Bool

    init(configuration: WKWebViewConfiguration, isTransparent: Bool = false) {
        self.isTransparent = isTransparent
        // Initial size must be non-zero to prevent ViewportSizing error logs
        let initialSize = CGRect(x: 0, y: 0, width: 0.1, height: 0.1)
        super.init(frame: initialSize, configuration: configuration)

        allowsBackForwardNavigationGestures = false
        isOpaque = !isTransparent
        if isTransparent {
            backgroundColor = .clear
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var safeAreaInsets: UIEdgeInsets {
        if isTransparent {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return super.safeAreaInsets
    }
}
