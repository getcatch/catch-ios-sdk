//
//  CatchURLTests.swift
//  
//
//  Created by Lucille Benoit on 6/1/23.
//

import XCTest
@testable import Catch

import XCTest

class DirectCheckoutURLQueryTests: XCTestCase {
    let host = Catch.environmentHost

    func testGenerateQueryString() {
        let prefill = MockDataProvider.mockCheckoutPrefill
        let themeConfig = MerchantThemeConfig(name: "theme")
        let publicKey = "test_public_key"
        let checkoutId = "123"

        let directCheckoutQuery = DirectCheckoutURLQuery(checkoutId: checkoutId,
                                                         prefill: prefill,
                                                         themeConfig: themeConfig,
                                                         publicKey: publicKey)

        let queryString = directCheckoutQuery.generateQueryString()
        XCTAssertEqual(
            queryString,
            "?hideHeader=false&publicKey=\(publicKey)&loadTheme=true&referer=https://\(host)&prefillUserPhone=123456789&prefillUserName=Jane%20Doe&prefillUserEmail=janedoe@gmail.com&checkoutId=123&flow=iframe")
    }

    func testGenerateQueryStringNoPrefill() {
        let themeConfig = MerchantThemeConfig(name: "theme")
        let publicKey = "test_public_key"
        let checkoutId = "123"

        let directCheckoutQuery = DirectCheckoutURLQuery(checkoutId: checkoutId,
                                                         prefill: nil,
                                                         themeConfig: themeConfig,
                                                         publicKey: publicKey)

        let queryString = directCheckoutQuery.generateQueryString()
        XCTAssertEqual(
            queryString,
            "?hideHeader=false&publicKey=\(publicKey)&loadTheme=true&referer=https://\(host)&checkoutId=123&flow=iframe"
        )
    }
}

class VirtualCardCheckoutURLQueryTests: XCTestCase {
    let host = Catch.environmentHost

    func testGenerateQueryString() {
        let prefill = MockDataProvider.mockCheckoutPrefill
        let themeConfig: MerchantThemeConfig? = nil
        let publicKey = "test_public_key"

        let virtualCardCheckoutQuery = VirtualCardCheckoutURLQuery(prefill: prefill,
                                                                   themeConfig: themeConfig,
                                                                   publicKey: publicKey)

        let queryString = virtualCardCheckoutQuery.generateQueryString()
        XCTAssertEqual(queryString, "?hideHeader=false&publicKey=test_public_key&loadTheme=false&referer=https://\(host)&prefillUserPhone=123456789&prefillUserName=Jane%20Doe&prefillUserEmail=janedoe@gmail.com&integration=vcn")
    }
}
