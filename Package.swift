// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "S3Storage",
    products: [
        .library(name: "S3Storage", targets: ["S3Storage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gperdomor/storage-kit.git", from: "0.1.0"),
        .package(url: "https://github.com/tadija/AEXML.git", from: "4.3.0")
    ],
    targets: [
        .target(name: "S3Storage", dependencies: ["StorageKit", "AEXML"]),
        .testTarget(name: "S3StorageTests", dependencies: ["S3Storage"]),
    ]
)
