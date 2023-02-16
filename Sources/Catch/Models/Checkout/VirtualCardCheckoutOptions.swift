//
//  VirtualCardCheckoutOptions.swift
//  Catch
//
//  Created by Lucille Benoit on 1/13/23.
//

import Foundation

public struct VirtualCardCheckoutOptions: OpenCheckoutOptions {
    /// Prefill values for consumer data: name, phone, and email.
    let prefill: CheckoutPrefill?

    /// Callback which will be called if the checkout is canceled.
    let onCancel: (() -> Void)?

    /// Callback which will be called if the checkout is confimed. The card details are passed into the callback.
    let onConfirm: ((CardDetails?) -> Void)?

    /**
     Initializes ``VirtualCardCheckoutOptions`` to configure the virtual card checkout flow.
     - Parameter prefill: Specifies pre-fill values to use in the virtual card checkout flow (ex. phone, email, name).
     See ``CheckoutPrefill`` for more information.
     - Parameter onCancel: If provided, this function is called when the consumer cancels a checkout flow.
     - Parameter onConfirm: If provided, this function is called when the consumer successfully
     completes a checkout flow. The virtual card details will be passed into the function.
     */
    public init(prefill: CheckoutPrefill? = nil,
                onCancel: (() -> Void)? = nil,
                onConfirm: ((CardDetails?) -> Void)? = nil) {
        self.prefill = prefill
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }
}
