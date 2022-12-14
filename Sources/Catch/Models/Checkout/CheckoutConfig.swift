//
//  CheckoutOptions.swift
//  Catch
//
//  Created by Lucille Benoit on 11/12/22.
//

import Foundation

public struct CheckoutOptions {
    /// Prefill values for consumer data: name, phone, and email.
    let prefill: CheckoutPrefill?

    /// Callback which will be called if the checkout is canceled.
    let onCancel: (() -> Void)?

    /// Callback which will be called if the checkout is confimed.
    let onConfirm: (() -> Void)?

    public init(prefill: CheckoutPrefill? = nil,
                onCancel: (() -> Void)? = nil,
                onConfirm: (() -> Void)? = nil) {
        self.prefill = prefill
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }
}
