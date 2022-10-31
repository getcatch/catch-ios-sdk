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
        let amount = 1000
        let rewardsRate: Double =  0.1

        let redeemableReward = Reward.redeemableCredits(amount)

        let redeemText = StringFormat.getEarnRedeemText(type: .callout(hasOrPrefix: false),
                                                        reward: redeemableReward)
        XCTAssertEqual(redeemText, "Redeem $10.00")

        let earnedReward = Reward.earnedCredits(amount)
        let earnText = StringFormat.getEarnRedeemText(type: .paymentMethod(isCompact: true),
                                                      reward: earnedReward)
        XCTAssertEqual(earnText, "Earn $10.00 credit")

        let percentReward = Reward.percentRate(rewardsRate)
        let orEarnText = StringFormat.getEarnRedeemText(type: .callout(hasOrPrefix: true),
                                                        reward: percentReward)
        XCTAssertEqual(orEarnText, "earn 10% credit")

        let merchantName = "Merch by Catch"
        let campaignEarnText = StringFormat.getEarnRedeemText(type: .campaignLink(merchantName: merchantName),
                                                              reward: earnedReward)
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
