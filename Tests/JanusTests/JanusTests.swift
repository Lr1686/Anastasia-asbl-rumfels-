import XCTest
@testable import Janus

final class JanusTests: XCTestCase {
    func testJanusSensorBridgeInitialization() {
        let bridge = JanusSensorBridge.shared
        XCTAssertNotNil(bridge)
    }
}
