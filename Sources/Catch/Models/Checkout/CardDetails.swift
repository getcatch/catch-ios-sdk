//
//  CardDetails.swift
//  Catch
//
//  Created by Lucille Benoit on 12/14/22.
//

import Foundation

/**
 Contains payment card details.
 */
public struct CardDetails: Decodable {
    /// The card number.
    let cardNumber: String

    /// The year the card expires.
    let expirationYear: String

    /// The month the card expires.
    let expirationMonth: String

    /// The three- or four-digit security code.
    let cvc: String

    /// The billing zipcode associated with the card.
    let zipCode: String
}
