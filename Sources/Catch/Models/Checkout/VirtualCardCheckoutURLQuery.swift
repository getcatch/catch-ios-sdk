//
//  VirtualCardCheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

class VirtualCardCheckoutURLQuery: CheckoutURLQuery {
    /// Required query param to indicate this is a virtual card checkout
    let integation: String = "vcn"

    init(prefill: CheckoutPrefill?,
         themeConfig: MerchantThemeConfig?,
         publicKey: String) {
        super.init(publicKey: publicKey, prefill: prefill, themeConfig: themeConfig)
    }
}
