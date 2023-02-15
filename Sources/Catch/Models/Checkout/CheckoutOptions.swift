//
//  CheckoutOptions.swift
//  Catch
//
//  Created by Lucille Benoit on 11/12/22.
//

import Foundation
/**
 An object which specifies optional configurations for the checkout flow.
 You may set prefill values for the checkout form fields or pass in callback
 functions to respond when a checkout is confirmed or canceled.
 */
public struct CheckoutOptions: CheckoutOptionsInterface {

    /// Prefill values for consumer data: name, phone, and email.
    let prefill: CheckoutPrefill?

    /// Callback which will be called if the checkout is canceled.
    let onCancel: (() -> Void)?

    /// Callback which will be called if the checkout is confimed.
    let onConfirm: (() -> Void)?

    internal var onConfirmCallback: (() -> Void)? {
        return onConfirm
    }

    /**
     Initializes ``CheckoutOptions`` to configure the checkout flow.
     - Parameter prefill: Specifies pre-fill values to use in the checkout flow (ex. phone, email, name).
     See ``CheckoutPrefill`` for more information.
     - Parameter onCancel: If provided, this function is called when the consumer cancels a checkout flow.
     - Parameter onConfirm: If provided, this function is called when the consumer successfully
     completes a checkout flow.
     */
    public init(prefill: CheckoutPrefill? = nil,
                onCancel: (() -> Void)? = nil,
                onConfirm: (() -> Void)? = nil) {
        self.prefill = prefill
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }
}
