//
//  CheckoutPrefill.swift
//  
//
//  Created by Lucille Benoit on 12/14/22.
//

import Foundation

/**
 Specifies pre-fill values to use in the checkout flow.

 If provided, the prefill object should contain string values for the keys
 userPhone, userName, and userEmail. Applications should always try
 to provide as much pre-fill data as possible. However, all prefill entries
 are individually optional.
 */
public struct CheckoutPrefill {
    /// The phone number to prefill in the checkout flow.
    let userPhone: String?

    /// The consumer name to prefill in the checkout flow.
    let userName: String?

    /// The email to prefill in the checkout flow.
    let userEmail: String?

    /**
     Initalizes ``CheckoutPrefill`` to prefill consumer information in the checkout flow.

     The provided phone number value should be stripped of any formatting and contain numbers
     only (for example "4155550132").
     - Parameter userPhone: The consumer phone number.
     - Parameter userName: The consumer name.
     - Parameter userEmail: The consumer email.
     */
    public init(userPhone: String? = nil, userName: String? = nil, userEmail: String? = nil) {
        self.userPhone = userPhone
        self.userName = userName
        self.userEmail = userEmail
    }
}
