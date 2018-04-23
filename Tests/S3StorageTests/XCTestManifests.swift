import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(S3StorageTests.allTests),
    ]
}
#endif
