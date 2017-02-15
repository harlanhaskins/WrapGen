import XCTest
@testable import WrapGen

class WrapGenTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(WrapGen().text, "Hello, World!")
    }


    static var allTests : [(String, (WrapGenTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
