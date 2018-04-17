// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "StorageS3",
    products: [
        .library(name: "StorageS3", targets: ["StorageS3"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gperdomor/storage-kit.git", .branch("beta"))
    ],
    targets: [
        .target(name: "StorageS3", dependencies: ["StorageKit"]),
        .testTarget(name: "StorageS3Tests", dependencies: ["StorageS3"]),
    ]
)
