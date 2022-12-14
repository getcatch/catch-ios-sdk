//
//  CheckoutController.swift
//  Catch
//
//  Created by Lucille Benoit on 11/13/22.
//

import Foundation

class CheckoutController: CatchWebViewController, PostMessageHandler {
    let merchantRepository: MerchantRepositoryInterface
    let options: CheckoutOptions?

    init?(checkoutId: String,
          options: CheckoutOptions?,
          merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.merchantRepository = merchantRepository
        self.options = options
        guard let url = CatchURL.checkout(checkoutId: checkoutId,
                                          prefillFields: options?.prefill,
                                          merchantRepository: merchantRepository) else { return nil }
        super.init(url: url, isTransparent: false)
        postMessageHandler = self
    }

    func handlePostMessage(_ postMessage: PostMessageAction) {
        switch postMessage {
        case .checkoutBack:
            dismiss(animated: true) { [weak self] in
                self?.options?.onCancel?()
            }
        case .checkoutSuccess:
            dismiss(animated: true) { [weak self] in
                self?.options?.onConfirm?()
            }
        default: ()
        }
    }
}
