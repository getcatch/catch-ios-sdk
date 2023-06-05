//
//  DirectCheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

/**
 Class used to create checkout url query params.
 */
class DirectCheckoutURLQuery: CheckoutURLQuery {
    let checkoutId: String
    let flow: String = "iframe"

    init(checkoutId: String,
         prefill: CheckoutPrefill?,
         themeConfig: MerchantThemeConfig?,
         publicKey: String) {
        self.checkoutId = checkoutId
        super.init(publicKey: publicKey, prefill: prefill, themeConfig: themeConfig)
    }

    override func generateQueryString() -> String? {
        guard var queryString = super.generateQueryString() else { return nil }
        queryString += "&checkoutId=\(checkoutId)&flow=\(flow)"
        return queryString
    }
}
