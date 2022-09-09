import XCTest
@testable import Catch

final class CatchTests: XCTestCase {

    func testAssetProviderColors() throws {
        XCTAssertNotNil(CatchAssetProvider.color(.catchPink))
        XCTAssertNotNil(CatchAssetProvider.color(.catchBlack))
    }

    func testAssetProviderImages() throws {
        XCTAssertNotNil(CatchAssetProvider.image(.logoDark))
        XCTAssertNotNil(CatchAssetProvider.image(.logoMonoDark))
        XCTAssertNotNil(CatchAssetProvider.image(.logoWhite))
        XCTAssertNotNil(CatchAssetProvider.image(.logoMonoWhite))
    }
}
