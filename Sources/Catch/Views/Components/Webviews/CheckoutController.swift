//
//  CheckoutController.swift
//  Catch
//
//  Created by Lucille Benoit on 11/13/22.
//

import Foundation

class CheckoutController: CatchWebViewController, PostMessageHandler {
    let merchantRepository: MerchantRepositoryInterface
    let integrationType: IntegrationType
    let options: CheckoutOptionsInterface?
    var virtualCardCheckoutData: CreateVirtualCardCheckoutBody?

    enum IntegrationType {
        case direct
        case virtualCard
    }

    init?(checkoutId: String,
          options: CheckoutOptions?,
          merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.merchantRepository = merchantRepository
        self.options = options
        self.integrationType = .direct
        guard let url = CatchURL.directCheckout(checkoutId: checkoutId,
                                          prefillFields: options?.prefill,
                                          merchantRepository: merchantRepository) else { return nil }
        super.init(url: url, isTransparent: false)
        postMessageHandler = self
    }

    init?(orderId: String,
          checkoutData: CreateVirtualCardCheckoutBody,
          options: VirtualCardCheckoutOptions?,
          merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.merchantRepository = merchantRepository
        self.options = options
        self.integrationType = .virtualCard
        self.virtualCardCheckoutData = checkoutData
        guard let url = CatchURL.virtualCardCheckout(orderId: orderId,
                                                     prefillFields: options?.prefill,
                                                     merchantRepository: merchantRepository) else { return nil }
        super.init(url: url, isTransparent: false)
        postMessageHandler = self
    }

    func handlePostMessage(_ postMessage: PostMessageAction, data: Any? = nil) {
        switch postMessage {
        case .checkoutReady:
            if integrationType == .virtualCard,
                let checkoutData = try? virtualCardCheckoutData?.asDictionary(encodingStrategy: .convertToSnakeCase) {
                let sendVCNCheckoutData: JSScript = .postMessage(action: .virtualCardCheckoutData,
                                                                 dataObject: checkoutData)
                webView.evaluateScript(sendVCNCheckoutData)
            }
        case .checkoutBack:
            dismiss(animated: true) { [weak self] in
                self?.options?.onCancel?()
            }
        case .checkoutSuccess:
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                if self.integrationType == .direct {
                    self.options?.onConfirmCallback?()
                } else if let data = data,
                          let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    let virtualCardCheckoutResult: VirtualCardCheckoutResult? = try? jsonData.decoded()
                    self.options?.virtualCardOnConfirmCallback?(virtualCardCheckoutResult?.cardDetails)
                }
            }
        default: ()
        }
    }
}
