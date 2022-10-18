//
//  MockDataProvider.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import XCTest
@testable import Catch

class MockDataProvider {
    var merchant: Merchant {
        return Merchant(merchantId: "testId",
                        name: "Test Merchant",
                        url: "www.",
                        rewardsRate: 0.1,
                        rewardsLifetimeInDays: 180,
                        cardBackgroundImageUrl: "https://dev.assets.getcatch.com/merchant-assets/humans-s768ng/card_background.png",
                        cardBackgroundColor: "#C779D0",
                        cardFontColor: "#FFFFFF",
                        donationRecipient: nil)
    }
}
