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
            case .deviceToken:
                // Override the existing device token if we receive one at checkout.
                if let data = data,
                   let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    if let deviceTokenResult: DeviceTokenResult = try? jsonData.decoded(),
                       let deviceToken = deviceTokenResult.deviceToken {
                        userRepository.saveDeviceToken(deviceToken, override: true)
                    }
                }
            default: ()
        }
    }
}
