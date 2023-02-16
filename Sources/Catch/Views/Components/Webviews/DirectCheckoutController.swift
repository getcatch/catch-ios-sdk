//
//  DirectCheckoutController.swift
//  Catch
//
//  Created by Lucille Benoit on 2/16/23.
//

import Foundation

class DirectCheckoutController: CheckoutController {
    var options: DirectCheckoutOptions?

    init?(checkoutId: String,
          options: DirectCheckoutOptions?,
          merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.options = options
        guard let url = CatchURL.directCheckout(checkoutId: checkoutId,
                                                prefillFields: options?.prefill,
                                                merchantRepository: merchantRepository) else { return nil }
        super.init(url: url, onCancel: options?.onCancel)
    }

    override func handlePostMessage(_ postMessage: PostMessageAction, data: Any? = nil) {
        switch postMessage {
        case .checkoutSuccess:
            dismiss(animated: true) { [weak self] in
                self?.options?.onConfirm?()
            }
        default:
            super.handlePostMessage(postMessage, data: data)
        }
    }
}
