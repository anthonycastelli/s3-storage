// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "StorageS3",
    products: [
        .library(name: "StorageS3", targets: ["StorageS3"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gperdomor/storage-kit.git", from: "0.1.0"),
        .package(url: "https://github.com/tadija/AEXML.git", from: "4.3.0")
    ],
    targets: [
        .target(name: "StorageS3", dependencies: ["StorageKit", "AEXML"]),
        .testTarget(name: "StorageS3Tests", dependencies: ["StorageS3"]),
    ]
)
