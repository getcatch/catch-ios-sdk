//
//  VirtualCardCheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

struct VirtualCardCheckoutURLQuery: Encodable {
    let orderId: String
    let prefillUserPhone: String
    let prefillUserName: String
    let prefillUserEmail: String
    let hideHeader: String = "false"
    let referer: String? = URLComponents.init(path: String()).string
    let publicKey: String
    let loadTheme: String

    init(orderId: String,
         prefill: CheckoutPrefill?,
         themeConfig: MerchantThemeConfig?,
         publicKey: String) {
        self.orderId = orderId
        prefillUserPhone = prefill?.userPhone ?? String()
        prefillUserName = prefill?.userName ?? String()
        prefillUserEmail = prefill?.userEmail ?? String()
        self.publicKey = publicKey
        self.loadTheme = themeConfig == nil ? "false" : "true"
    }
}
