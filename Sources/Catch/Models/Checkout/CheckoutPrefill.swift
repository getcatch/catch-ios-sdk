//
//  CheckoutPrefill.swift
//  
//
//  Created by Lucille Benoit on 12/14/22.
//

import Foundation

public struct CheckoutPrefill {
    /// The phone number to prefill in the checkout flow.
    let userPhone: String?

    /// The consumer name to prefill in the checkout flow.
    let userName: String?

    /// The email to prefill in the checkout flow.
    let userEmail: String?

    public init(userPhone: String? = nil, userName: String? = nil, userEmail: String? = nil) {
        self.userPhone = userPhone
        self.userName = userName
        self.userEmail = userEmail
    }
}
