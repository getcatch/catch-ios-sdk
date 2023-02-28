//
//  VirtualCardCheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

class VirtualCardCheckoutURLQuery: CheckoutURLQuery {
    let orderId: String

    init(orderId: String,
         prefill: CheckoutPrefill?,
         themeConfig: MerchantThemeConfig?,
         publicKey: String) {
        self.orderId = orderId
        super.init(publicKey: publicKey, prefill: prefill, themeConfig: themeConfig)
    }
}
