//
//  TofuURLQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

/**
 Struct used to create tofu url query params.
 */
struct TofuURLQuery: Encodable {
    let merchantId: String
    let merchantName: String
    let credit: Int
    let referer: String? = URLComponents.init(path: String()).string
    let publicKey: String
    let loadTheme: String

    init(merchant: Merchant, publicKey: String) {
        self.merchantId = merchant.merchantId
        self.merchantName = merchant.name
        self.credit = Int(merchant.defaultEarnedRewardsRate * 100)
        self.publicKey = publicKey
        self.loadTheme = merchant.theme == nil ? "false" : "true"
    }
}
