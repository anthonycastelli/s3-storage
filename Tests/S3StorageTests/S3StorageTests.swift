import XCTest
@testable import S3Storage

final class S3StorageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(StorageS3().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
