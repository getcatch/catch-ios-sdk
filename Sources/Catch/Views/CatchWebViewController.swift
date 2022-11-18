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
    let userRepository: UserRepositoryInterface

    // MARK: - Initializers

    init(url: URL, userRepository: UserRepositoryInterface = Catch.userRepository) {
        self.url = url
        self.userRepository = userRepository
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
        webView.alpha = 0
        UIView.animate(withDuration: UIConstant.modalAnimationDuration,
                       delay: 0,
                       options: .curveEaseOut, animations: {
            self.webView.alpha = 1
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
        injectOrSaveDeviceToken(webView)

        let script: JSScript = .addPostMessageListener(name: listenerName)
        webView.evaluateScript(script)
    }

    private func injectOrSaveDeviceToken(_ webView: WKWebView) {
        // Injects the existing device token into the webview if it exists.
        if let existingToken = userRepository.getDeviceToken() {
            let localScript: JSScript = .setLocalStorageItem(name: JSScript.deviceTokenKey, value: existingToken)
            webView.evaluateScript(localScript)
        } else {
            // Pulls device token from the webview's local storage and saves it to the user repository.
            let localScript: JSScript = .getLocalStorageItem(name: JSScript.deviceTokenKey)
            webView.evaluateScript(localScript) { [unowned self] result in
                if case let .success(value) = result, let token = value as? String {
                    self.userRepository.saveDeviceToken(token)
                }
            }
        }
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
              let actionString = body[JSScript.actionKey] as? String,
              let action = PostMessageAction(rawValue: actionString) else { return }
        postMessageHandler?.handlePostMessage(action)
    }
}
