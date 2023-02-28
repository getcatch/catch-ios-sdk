//
//  VirtualCardCheckoutController.swift
//  Catch
//
//  Created by Lucille Benoit on 2/16/23.
//

import Foundation

class VirtualCardCheckoutController: CheckoutController {
    var virtualCardCheckoutData: CreateVirtualCardCheckoutBody
    var options: VirtualCardCheckoutOptions?

    init?(orderId: String,
          checkoutData: CreateVirtualCardCheckoutBody,
          options: VirtualCardCheckoutOptions?,
          merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.virtualCardCheckoutData = checkoutData
        self.options = options
        guard let url = CatchURL.virtualCardCheckout(orderId: orderId,
                                                     prefillFields: options?.prefill,
                                                     merchantRepository: merchantRepository) else { return nil }
        super.init(url: url, onCancel: options?.onCancel)
    }

    override func handlePostMessage(_ postMessage: PostMessageAction, data: Any? = nil) {
        switch postMessage {
        case .checkoutReady:
            if let checkoutData = try? virtualCardCheckoutData.asDictionary(encodingStrategy: .convertToSnakeCase) {
                let sendVCNCheckoutData: JSScript = .postMessage(action: .virtualCardCheckoutData,
                                                                 dataObject: checkoutData)
                webView.evaluateScript(sendVCNCheckoutData)
            }
        case .checkoutSuccess:
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                if let data = data,
                   let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    let virtualCardCheckoutResult: VirtualCardCheckoutResult? = try? jsonData.decoded()
                    self.options?.onConfirm?(virtualCardCheckoutResult?.cardDetails)
                }
            }
        default:
            super.handlePostMessage(postMessage, data: data)
        }
    }
}
