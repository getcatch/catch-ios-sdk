//
//  CatchWebViewController.swift
//  Catch
//
//  Created by Lucille Benoit on 9/14/22.
//

import Foundation
import WebKit

class CatchWebViewController: UIViewController {
    lazy var webView: CatchWebView = {
        let configuration = WebViewConfiguration(scriptMessageHandler: self, name: listenerName)
        let webView = CatchWebView(configuration: configuration, isTransparent: isWebViewTransparent)
        webView.navigationDelegate = self
        return webView
    }()

    weak var postMessageHandler: PostMessageHandler?
    let listenerName = "iOSListener"
    let url: URL
    let userRepository: UserRepositoryInterface
    let isWebViewTransparent: Bool

    // Threshold for allowing a swipe down gesture to dismiss the entire controller.
    private static let swipeDownThreshold: CGFloat = 125

    // MARK: - Initializers

    init(url: URL, isTransparent: Bool = false, userRepository: UserRepositoryInterface = Catch.userRepository) {
        self.url = url
        self.userRepository = userRepository
        self.isWebViewTransparent = isTransparent
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        panGesture.delegate = self
        webView.addGestureRecognizer(panGesture)
    }

    override func loadView() {
        view = webView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.alpha = 0
        UIView.animate(withDuration: UIConstant.modalAnimationDuration,
                       delay: 0.22,
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


    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        print(translation.y)

        switch gesture.state {
            case .changed:
                if translation.y > 0 {
                    view.frame.origin.y = translation.y
                }
            case .ended, .cancelled:
                if translation.y > Self.swipeDownThreshold {
                    dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.view.frame.origin.y = 0
                    }
                }
            default:
                break
        }
    }
}

extension CatchWebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
            webView.evaluateScript(localScript) { [weak self] result in
                if case let .success(value) = result, let token = value as? String {
                    self?.userRepository.saveDeviceToken(token, override: false)
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
        let data = body[JSScript.dataKey]
        postMessageHandler?.handlePostMessage(action, data: data)
    }
}
