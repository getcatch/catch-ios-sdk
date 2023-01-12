//
//  CheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

/**
 Struct used to create checkout url query params.
 */
struct DirectCheckoutURLQuery: Encodable {
    let checkoutId: String
    let prefillUserPhone: String
    let prefillUserName: String
    let prefillUserEmail: String
    let hideHeader: String = "false"
    let flow: String = "iframe"
    let referer: String? = URLComponents.init(path: String()).string
    let publicKey: String
    let loadTheme: String

    init(checkoutId: String,
         prefill: CheckoutPrefill?,
         themeConfig: MerchantThemeConfig?,
         publicKey: String) {
        self.checkoutId = checkoutId
        prefillUserPhone = prefill?.userPhone ?? String()
        prefillUserName = prefill?.userName ?? String()
        prefillUserEmail = prefill?.userEmail ?? String()
        self.publicKey = publicKey
        self.loadTheme = themeConfig == nil ? "false" : "true"
    }
}
