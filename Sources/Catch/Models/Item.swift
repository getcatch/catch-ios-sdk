//
//  Item.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

/**
 An object specifying item details to be passed into widgets
 in order to calculate sku-based rewards.
 */
public struct Item {
    let sku: String?
    let name: String?
    let price: Int?
    let quantity: Int?

    internal var queryString: String {
        let strings = [sku ?? "",
                       name ?? "",
                       price?.stringValue ?? "",
                       quantity?.stringValue ?? ""]

        return strings.joined(separator: ";")
    }
}
