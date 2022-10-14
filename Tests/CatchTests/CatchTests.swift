import XCTest
@testable import Catch

final class CatchTests: XCTestCase {
    func testColorFromHex() {
        let redHexString = "#FF0000"
        let redFromHex = UIColor(hexString: redHexString)
        XCTAssertEqual(redFromHex, UIColor.red)
    }

    func testAssetProviderColors() throws {
        XCTAssertNotNil(CatchAssetProvider.color(.pinkName))
        XCTAssertNotNil(CatchAssetProvider.color(.blackName))
    }

    func testAssetProviderImages() throws {
        XCTAssertNotNil(CatchAssetProvider.image(.logoDark))
        XCTAssertNotNil(CatchAssetProvider.image(.logoMonoDark))
        XCTAssertNotNil(CatchAssetProvider.image(.logoWhite))
        XCTAssertNotNil(CatchAssetProvider.image(.logoMonoWhite))
    }

    func testEarnRedeemStringGeneration() throws {
        let amount = StringFormat.priceString(from: 1000)
        let rewardsRate = StringFormat.percentString(from: 0.1)

        let redeemText = StringFormat.getEarnRedeemText(type: .callout(hasOrPrefix: false),
                                                        amountString: amount,
                                                        hasRedeemableCredits: true)
        XCTAssertEqual(redeemText, "Redeem $10.00")

        let earnText = StringFormat.getEarnRedeemText(type: .paymentMethod(isCompact: true),
                                                      amountString: amount,
                                                      hasRedeemableCredits: false)
        XCTAssertEqual(earnText, "Earn $10.00 credit")

        let orEarnText = StringFormat.getEarnRedeemText(type: .callout(hasOrPrefix: true),
                                                      amountString: rewardsRate,
                                                      hasRedeemableCredits: false)
        XCTAssertEqual(orEarnText, "earn 10% credit")

        let merchantName = "Merch by Catch"
        let campaignEarnText = StringFormat.getEarnRedeemText(type: .campaignLink(merchantName: merchantName),
                                                              amountString: amount,
                                                              hasRedeemableCredits: false)
        XCTAssertEqual(campaignEarnText, "$10.00 credit")
    }

    func testFillerStringGeneration() throws {
        var fillerText = StringFormat.getEarnRedeemFillerText(type: .paymentMethod(isCompact: true))
        XCTAssertEqual(fillerText, "")

        fillerText = StringFormat.getEarnRedeemFillerText(type: .paymentMethod(isCompact: false))
        XCTAssertEqual(fillerText, "Pay by bank. ")

        let merchantName = "Merch by Catch"
        fillerText = StringFormat.getEarnRedeemFillerText(type: .campaignLink(merchantName: merchantName))
        XCTAssertEqual(fillerText, " to spend at \(merchantName) the next time you pay with Catch 💸")

        fillerText = StringFormat.getEarnRedeemFillerText(type: .callout(hasOrPrefix: false))
        XCTAssertEqual(fillerText, " by paying with")

        fillerText = StringFormat.getEarnRedeemFillerText(type: .expressCheckoutCallout)
        XCTAssertEqual(fillerText, " with")
    }
}
