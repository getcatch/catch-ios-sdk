//
//  CheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 2/16/23.
//

import Foundation

class CheckoutURLQuery: Encodable {
    let prefillUserPhone: String
    let prefillUserName: String
    let prefillUserEmail: String
    let hideHeader: String = "false"
    let referer: String? = URLComponents.init(path: String()).string
    let publicKey: String
    let loadTheme: String

    init(publicKey: String, prefill: CheckoutPrefill?, themeConfig: MerchantThemeConfig?) {
        self.publicKey = publicKey
        self.prefillUserPhone = prefill?.userPhone ?? String()
        self.prefillUserName = prefill?.userPhone ?? String()
        self.prefillUserEmail = prefill?.userEmail ?? String()
        self.loadTheme = themeConfig == nil ? "false" : "true"
    }
}
