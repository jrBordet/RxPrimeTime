import XCTest
@testable import SceneBuilder

final class SceneBuilderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SceneBuilder().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
