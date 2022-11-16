//
//  CatchWebViewController.swift
//  Catch
//
//  Created by Lucille Benoit on 9/14/22.
//

import Foundation
import WebKit

class CatchWebViewController: UIViewController {
    lazy var webView: TransparentWebView = {
        let configuration = WebViewConfiguration(scriptMessageHandler: self, name: listenerName)
        let webView = TransparentWebView(configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()

    weak var postMessageHandler: PostMessageHandler?

    let listenerName = "iOSListener"
    let url: URL

    // MARK: - Initializers

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    override func loadView() {
        view = webView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: UIConstant.modalAnimationDuration,
                       delay: 0,
                       options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIConstant.modalBackgroundColor
        })
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: UIConstant.modalAnimationDuration,
                       delay: 0,
                       options: .curveEaseOut, animations: {
            self.view.backgroundColor = .clear
        }, completion: {_ in
            super.dismiss(animated: flag, completion: completion)
        })
    }
}

extension CatchWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script: JSScript = .addPostMessageListener(name: listenerName)
        webView.evaluateScript(script)
    }

    // this handles target=_blank links by opening them in Safari
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension CatchWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == listenerName,
              let body = message.body as? [String: Any],
              let actionString = body["action"] as? String,
              let action = PostMessageAction(rawValue: actionString) else { return }
        postMessageHandler?.handlePostMessage(action)
    }
}
