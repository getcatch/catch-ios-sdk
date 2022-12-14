//
//  Price.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

public struct Price: Codable {
    /// The unit price of the item (in cents).
    var amount: Int

    /// The currency that the price of the item is in.
    var currency: String

    /// Initializes a price which stores the amount and currency.
    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}
