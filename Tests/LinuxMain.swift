import XCTest

import StorageS3Tests

var tests = [XCTestCaseEntry]()
tests += StorageS3Tests.allTests()
XCTMain(tests)