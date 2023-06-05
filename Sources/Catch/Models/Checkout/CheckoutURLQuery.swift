//
//  CheckoutURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 2/16/23.
//

import Foundation

class CheckoutURLQuery {
    let prefillUserPhone: String?
    let prefillUserName: String?
    let prefillUserEmail: String?
    let hideHeader: String = "false"
    let referer: String?
    let publicKey: String
    let loadTheme: String

    init(publicKey: String, prefill: CheckoutPrefill?, themeConfig: MerchantThemeConfig?) {
        self.publicKey = publicKey
        self.prefillUserPhone = prefill?.userPhone
        self.prefillUserName = prefill?.userName
        self.prefillUserEmail = prefill?.userEmail
        self.loadTheme = themeConfig == nil ? "false" : "true"
        self.referer = URLComponents(path: String()).string
    }

    func generateQueryString() -> String? {
        var queryString = "?hideHeader=\(hideHeader)" +
        "&publicKey=\(publicKey)" +
        "&loadTheme=\(loadTheme)"

        if let referer = referer {
            queryString += "&referer=\(referer)"
        }

        if let prefillPhone = prefillUserPhone {
            queryString += "&prefillUserPhone=\(prefillPhone)"
        }

        if let prefillName = prefillUserName {
            queryString += "&prefillUserName=\(prefillName)"
        }

        if let prefillEmail = prefillUserEmail {
            queryString += "&prefillUserEmail=\(prefillEmail)"
        }

        return queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
