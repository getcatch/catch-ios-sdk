//
//  CreateVirtualCardCheckoutBody.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

public struct CreateVirtualCardCheckoutBody: Codable {
    /// The ID of this order in the merchant's system which Catch will store
    /// for shared identification purposes. This ID should be unique per order.
    let merchantOrderId: String

    /// The merchant's public API key.
    let merchantPublicKey: String

    /// Contains details of the order total.
    let amounts: Amounts

    /// Contains details of the billing contact.
    let billing: Address

    /// Contains details of the shipping contact.
    let shipping: Address

    /// The name of the shipping method (e.g., "express").
    let shippingMethod: String?

    /// Contains details of the order's items.
    let items: [Item]

    /// The ID of the consumer in the merchant's system which Catch will store for shared identification purposes.
    /// (While this field is required, the value null may be explicitly passed if the consumer is anonymous and
    /// doesn't have an ID. However, it is recommended to provide an ID wherever possible).
    let merchantUserId: String

    /// Contains the name and version of the platform in use.
    let platform: Platform?

    /// User cohorts that this checkout should be associated with.
    let userCohorts: [String]

    /// Initializes the data object which houses all parameters needed to create a virtual card checkout.
    public init(merchantOrderId: String,
                merchantPublicKey: String,
                amounts: Amounts,
                billing: Address,
                shipping: Address,
                shippingMethod: String?,
                items: [Item],
                merchantUserId: String,
                platform: Platform?,
                userCohorts: [String]) {
        self.merchantOrderId = merchantOrderId
        self.merchantPublicKey = merchantPublicKey
        self.amounts = amounts
        self.billing = billing
        self.shipping = shipping
        self.shippingMethod = shippingMethod
        self.items = items
        self.merchantUserId = merchantUserId
        self.platform = platform
        self.userCohorts = userCohorts
    }
}
