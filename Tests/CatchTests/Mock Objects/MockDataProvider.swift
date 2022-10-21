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
        let imageURL = """
                        https://dev.assets.getcatch.com/\
                        merchant-assets/humans-s768ng/card_background.png
                        """

        return Merchant(merchantId: "testId",
                        name: "Test Merchant",
                        url: "www.google.com",
                        rewardsRate: 0.1,
                        rewardsLifetimeInDays: 180,
                        cardBackgroundImageUrl: imageURL,
                        cardBackgroundColor: "#C779D0",
                        cardFontColor: "#FFFFFF",
                        donationRecipient: nil)
    }

    var publicUserData: PublicUserData {
        return PublicUserData(userFirstName: "FirstName",
                              rewardAmount: 1000,
                              firstPurchaseBonusEligibility: false)
    }
}
