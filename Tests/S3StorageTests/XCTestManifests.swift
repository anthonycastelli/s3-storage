import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StorageS3Tests.allTests),
    ]
}
#endif