//
//  Amounts.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

public struct Amounts: Codable {
    /// The total amount (in cents) to charge the consumer after all promotions, discounts and fees are appliced.
    var total: Int

    /// The subtotal (in cents) that should be displayed to the consumer.
    var subtotal: Int

    /// The amount of tax (in cents) on the order.
    var tax: Int

    /// The amount of shipping cost (in cents) on the order.
    var shipping: Int

    /// The discount total (in cents) that should be displayed to the consumer.
    var discountTotal: Int?

    /// The currency in which the amounts are represented.
    var currency: String

    /// Initializes an Amounts object which contains the details of the order total.
    public init(total: Int, subtotal: Int, tax: Int, shipping: Int, discountTotal: Int?, currency: String) {
        self.total = total
        self.subtotal = subtotal
        self.tax = tax
        self.shipping = shipping
        self.discountTotal = discountTotal
        self.currency = currency
    }
}
