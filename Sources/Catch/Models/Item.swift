//
//  Item.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

/**
 An object specifying item details.
 */
public struct Item: Codable {
    var name: String
    var sku: String
    var price: Price
    var quantity: Int
    var category: [String]?
    var imageUrl: String

    /// Initializes an item object.
    public init(name: String, sku: String, price: Price, quantity: Int, category: [String]? = nil, imageUrl: String) {
        self.name = name
        self.sku = sku
        self.price = price
        self.quantity = quantity
        self.category = category
        self.imageUrl = imageUrl
    }

    internal var queryString: String {
        let strings = [sku, name, price.amount.stringValue, quantity.stringValue]

        return strings.joined(separator: ";")
    }
}
