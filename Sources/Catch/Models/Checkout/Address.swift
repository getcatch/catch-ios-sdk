//
//  Address.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

/**
 Contains address details for the shipping or billing contact.
 */
public struct Address: Codable {
    /// The name of the contact.
    var name: String

    /// The street address of the contact.
    var address1: String

    /// The optional apartment, suite, unit, etc. of the contact.
    var address2: String?

    /// The city of the contact
    var city: String

    /// For international addresses where needed, such as name of the suburb for NZ or village for UK.
    var area: String?

    /// The state or province abbreviation for the contact, such as 'NY' or 'CA'.
    var zoneCode: String

    /// The country code for the contact.
    var countryCode: String

    /// The postal code of the contact.
    var postalCode: String

    /// The phone number associated with the order's contact. Format: "+12223334444"
    var phoneNumber: String?

    /// Initializes an Address object.
    public init(name: String,
                address1: String,
                address2: String? = nil,
                city: String,
                area: String? = nil,
                zoneCode: String,
                countryCode: String,
                postalCode: String,
                phoneNumber: String? = nil) {
        self.name = name
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.area = area
        self.zoneCode = zoneCode
        self.countryCode = countryCode
        self.postalCode = postalCode
        self.phoneNumber = phoneNumber
    }
}
