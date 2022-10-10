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
}
