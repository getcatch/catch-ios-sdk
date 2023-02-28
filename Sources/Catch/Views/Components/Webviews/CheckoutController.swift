//
//  CheckoutController.swift
//  Catch
//
//  Created by Lucille Benoit on 11/13/22.
//

import Foundation

class CheckoutController: CatchWebViewController, PostMessageHandler {
    let merchantRepository: MerchantRepositoryInterface
    let onCancel: (() -> Void)?

    init(url: URL,
         onCancel: (() -> Void)?,
         merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.merchantRepository = merchantRepository
        self.onCancel = onCancel
        super.init(url: url, isTransparent: false)
        postMessageHandler = self
    }

    func handlePostMessage(_ postMessage: PostMessageAction, data: Any? = nil) {
        switch postMessage {
        case .checkoutBack:
            dismiss(animated: true) { [weak self] in
                self?.onCancel?()
            }
        default: ()
        }
    }
}
